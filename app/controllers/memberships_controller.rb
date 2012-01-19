class MembershipsController < ApplicationController
  before_filter :require_user
  before_filter :find_topic
  before_filter :check_topic_owner
  
  def find_topic
    @topic = Topic.find(params[:topic_id])
  end

  def check_topic_owner
    redirect_to root_path unless @topic.owner?(current_user)
  end  
  
  def create_multiple    
    emails = params[:emails].split(',')
    memberships = []
    
    emails.each do |email|
      user = User.where("email = ?", email.strip).first
      unless user.nil? || user.member_or_owner?(@topic)
        memberships << Membership.create({:topic => @topic, :user => user})
        UserMailer.topic_invitation(user, @topic).deliver
      end
    end
    
    respond_to do |format|
      format.html { redirect_to(@topic, :notice => "#{memberships.size} von #{emails.size} #{(emails.size==1 ? 'Benutzer wurde' : 'Benutzern wurden')} hinzugefügt.") }
    end
  end
  
  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @membership = Membership.find(params[:id])
    if @topic.owner? current_user
      @membership.destroy
    end

    respond_to do |format|
      format.html { redirect_to(@topic) }
      format.js do
        render :update do |page|
          page.remove "membership_#{params[:id]}"
        end
      end
      format.xml  { head :ok }
    end
  end
end
