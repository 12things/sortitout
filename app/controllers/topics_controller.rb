class TopicsController < ApplicationController
  before_filter :require_user, :except => [:imprint]
  before_filter :find_topic, :except => [:new, :create, :imprint]
  before_filter :check_owner, :except => [:new, :create, :imprint]
  before_filter :check_member, :only => [:show]
  
  def find_topic
    @topic = Topic.find(params[:id])
  end
  
  def check_owner
    redirect_to root_url unless @topic.owner?(current_user)
  end

  def check_member
    redirect_to root_url unless @topic.member_or_owner?(current_user)
  end
  
  # GET /topics
  # GET /topics.xml
  def index
    redirect_to root_path
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    respond_to do |format|
      format.html
      format.xml
    end
  end
    
  # GET /topics/new
  # GET /topics/new.xml
  def new
    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.xml
  def create
    @topic = Topic.new(params[:topic])
    @topic.user = current_user

    respond_to do |format|
      if @topic.save
        format.html { redirect_to(@topic, :notice => 'Thema wurde angelegt.') }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to(@topic, :notice => 'Thema wurde gespeichert.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(root_url) }
      format.xml  { head :ok }
    end
  end
  
  def imprint
    
  end
end
