class PostsController < ApplicationController
  before_filter :require_user
  before_filter :find_topic
  before_filter :check_topic_member
  
  def check_topic_member
    redirect_to root_url unless @topic.member_or_owner?(current_user)
  end
  
  def find_topic
    @topic = Topic.find(params[:topic_id])
  end
  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = @topic.posts.arrange
    @post = Post.new
    @tags = @topic.posts.tag_counts_on(:tags)
    
    @share = params[:share]? params[:share] : ""

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def vote
    @post = Post.find(params[:id])
    
    respond_to do |format|
      format.js do
        if @post.votes.empty? || @post.votes.where("user_id = ?", current_user.id).all.empty?
          @post.votes.create({:user => current_user})
          render :update do |page|
            page.replace "post_#{@post.id}", :partial => 'post', :locals => {:post => @post, :topic => @topic}
          end
        else
          render :nothing => true
        end
      end
    end
  end
  
  # POST /posts
  # POST /posts.xml
  def create
    @post = @topic.posts.new(params[:post])
    @post.user = current_user
    
    respond_to do |format|
      if @post.save
        if @post.reply_to_post_id
          @post.parent = Post.find(@post.reply_to_post_id)
          @post.save
        end
        
        format.html { redirect_to(topic_posts_path(@topic), :notice => 'Post was successfully created.') }
        format.js do
          render :update do |page|
            page.replace "posts", :partial => 'thread', :locals => {:posts => @topic.posts.arrange, :topic => @topic }
            page << "$('post_original_body').clear();"
            page << "$('post_#{@post.id}').scrollTo();"
            page << "$('post_#{@post.id}').highlight();"
          end
        end

      else
        format.html { render :action => "new" }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    if @post.owner? current_user      
      @post.destroy
    end

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.js do
        render :update do |page|
          page.replace "posts", :partial => 'thread', :locals => {:posts => @topic.posts.arrange, :topic => @topic }
        end
      end
      format.xml  { head :ok }
    end
  end
  
  def check_for_new
    @count = Post.where("topic_id = ? and id > ?", @topic.id, params[:highest_id]).count
    respond_to do |format|
      format.js do
        if @count > 0
          render :update do |page|
            page['new-posts-bar'].update pluralize(@count, 'neuer Post', 'neue Posts')
            page['new-posts-bar'].appear({:duration => 0.5})
          end
        else
          render :nothing => true
        end
      end
    end
  end

  
  def refresh
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace "posts", :partial => 'thread', :locals => {:posts => @topic.posts.arrange, :topic => @topic }
          page['new-posts-bar'].hide    
        end
      end
    end
  end
end
