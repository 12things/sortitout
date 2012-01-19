module ApplicationHelper
  def lightbox_for embed, options={}
    tags = embed.post.machinetag_list
    logger.debug tags.inspect
    options = {:gallery => false,
               :title => embed.title}.merge options
    link_to(image_tag((tags.include?('photo:full') ? embed.url : embed.thumbnail_url), :class => 'gallery', :alt => options[:title]), embed.url, 
    :rel => 'lightbox'+(options[:gallery] ? ("["+options[:gallery]+"]") : ''), :title => options[:title])
  end
end
