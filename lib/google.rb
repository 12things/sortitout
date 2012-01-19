require 'net/http'

class Google
  def self.translate tag, ip
    result=[]
    langs=['de','en','es','it','fr']
    
    langs.each do |lang|
      gateway = "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q="+URI.encode(tag)+"&langpair="+URI.encode("|"+lang)+"&key=ABQIAAAAaAoeSsvKr-YNimqQ3CqJmBQHY4wHW2aPWk-1Z_MSMxc65Q0PhhRJuIGm3mHR4gb6KFyCfExdlkCqaQ&userip="+ip
      res = Net::HTTP.get(URI.parse(gateway))
      result << ActiveSupport::JSON.decode(res)['responseData']['translatedText']
    end
    
    return result
  end
end