require 'net/http'

class Flickr
  def self.api_request tags
    tags = tags.kind_of?(String) ? tags : tags.join(",")
    gateway = 'http://api.flickr.com/services/feeds/photos_public.gne?format=json&tagmode=any&nojsoncallback=1&tags=' + URI.encode(tags)
    res = Net::HTTP.get(URI.parse(gateway))

    data = ActiveSupport::JSON.decode(res)
  end
end