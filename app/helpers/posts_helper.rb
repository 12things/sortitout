module PostsHelper
  GLOBALTAG_REGEX = /(?:^|\s)(#(\S+))(?=\s|$)/

  def css_class post
    hotness_class(post) + ' ' + new_class(post)
  end
  
  def new_class post
    post.new_since_last_visit?(current_user) ? 'new' : ''
  end
  
  def hotness_class post
    if post.hotness < 50
      return 'cold'
    elsif post.hotness < 75
      return 'medium'
    end
    return 'hot'
  end
  
  def replace_urls_with_links
    
  end
  
  def replace_hashtags_with_links body, topic
    body.gsub(GLOBALTAG_REGEX) do |s|
      " " + link_to($1, '#', :class => 'carbon-load', 'data-carbon-href' => show_associations_path, 'data-carbon-params' => {:topic_id => topic.id, :tag => $2}.to_json)
    end
  end
end
