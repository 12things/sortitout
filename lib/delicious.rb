require 'net/http'

class Delicious
  def self.api_request tags
    result=[]
    is_string = tags.kind_of?(String)
    tags = is_string ? [tags] : tags

    tags.each do |tag|
      gateway = 'http://feeds.delicious.com/v2/json/popular/' + URI.encode(is_string ? tag+'?count=10' : tag.name)

      res = Net::HTTP.get(URI.parse(gateway))
      data = ActiveSupport::JSON.decode(res)
      
      if tag.is_a?(String)
        result = data unless data.empty?
      else
        result << data[0] unless data.empty?
      end
    end
    
    return result
  end
end
