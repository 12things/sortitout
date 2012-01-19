class AssociationsController < ApplicationController
  def create
  end
  
  def show
    if params[:topic_id]
      @topic = Topic.find(params[:topic_id])
      @tags = @topic.posts.tag_counts_on(:tags)
    end
    @tag = params[:tag]

    # @google_translations = Google.translate @tag, request.remote_ip
    @flickr_photos = Flickr.api_request @tag.blank? ? @tags : @tag
    @delicious_links = Delicious.api_request @tag.blank? ? @tags : @tag

    respond_to do |format|
      format.html
      format.js  { render :partial => "association" }
    end
  end
end
