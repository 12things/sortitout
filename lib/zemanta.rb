require 'net/http'

class Zemanta
  def initialize text
    @json = Zemanta.api_request text
  end

  def self.api_request text
    gateway = 'http://api.zemanta.com/services/rest/0.0/'
    res = Net::HTTP.post_form(URI.parse(gateway),
                           {
                           'method'=>'zemanta.suggest',
                           'api_key'=> 'c8umye38s2v4qpkkrypq2nas',
                           'text'=> text,
                           'format' => 'json'
                           })

    data = ActiveSupport::JSON.decode(res.body)
  end
  
  def get_tags
    @json['keywords']
  end
  
  def get_articles
    @json['articles']
  end
end