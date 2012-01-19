class Embed < ActiveRecord::Base
  include Embedly
  belongs_to :post
  before_save :query_embedly
  
  private
  def query_embedly
    if self.original_url.match(EMBEDLY_REGEX)
      begin
        url = EMBEDLY_URL + URI.encode(self.original_url)
        res = Net::HTTP.get(URI.parse(url))
        set_from_embedly_json ActiveSupport::JSON.decode(res)
      rescue
        log.warn "Could not access embedly"
      end
    end
  end
  
  def set_from_embedly_json data
    self.provider_name    = data['provider_name']
    self.provider_url     = data['provider_url']
    self.embed_type       = data['type']
    self.description      = data['description']
    self.title            = data['title']
    self.url              = data['url']
    self.html             = data['html']
    self.width            = data['width']
    self.height           = data['height']
    self.author_name      = data['author_name']
    self.author_url       = data['author_url']
    self.thumbnail_url    = data['thumbnail_url']
    self.thumbnail_width  = data['thumbnail_width']
    self.thumbnail_height = data['thumbnail_height']
    self.version          = data['version']
    self.cache_age        = data['cache_age']
  end
end
