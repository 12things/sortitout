class Post < ActiveRecord::Base
  include Embedly
  GLOBALTAG_REGEX = /(?:^|\s)#(\S+)(?=\s|$)/
  HASHTAG_REGEX = /(?:^|\s)#([^:\s]*)(?=\s|$)/
  MACHINETAG_REGEX = /(?:^|\s)#(\S*:\S*)(?=\s|$)/
  REPLY_REGEX = /(?:^|\s)@(\d+)(?=\s|$)/
  URL_REGEX = /((http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:\/~\+#]*[\w\-\@?^=%&amp;\/~\+#])?)/
  
  belongs_to :topic, :counter_cache => true
  belongs_to :user
  has_many :votes, :dependent => :destroy
  has_many :embeds, :dependent => :destroy
  acts_as_nested_set :scope => :topic
  acts_as_taggable
  acts_as_taggable_on :machinetags
  before_create :scan_for_machinetags
  before_create :scan_for_hashtags
  before_create :strip_original_body
  after_create :scan_for_urls
  
  # Aggregated/other scopes
  scope :newest, order("updated_at DESC")
  scope :hottest, order("votes_count DESC")
  scope :new_since, proc {|time| where("created_at >= ?", time) }
  
  def hotness
    ((votes.size.to_f / (topic.members.count+1).to_f)*100).round
  end
  
  def owner? user
    self.user == user
  end

  def new_since_last_visit? user
    if user.last_login_at.nil?
      return self.created_at >= user.current_login_at
    end
    self.created_at >= user.last_login_at
  end
  
  def reply_to_post_id
    m=original_body.match(REPLY_REGEX)
    m ? m[1] : nil
  end
  
  def hashtags
    original_body.scan(HASHTAG_REGEX).flatten.compact.uniq
  end
  
  def machinetags
    original_body.scan(MACHINETAG_REGEX).flatten.compact.uniq
  end
  
  def urls
    original_body.scan(URL_REGEX).map {|u| u[0] }
  end
  
  def embed_type
    return 'plain' if self.embeds.empty?
    types = self.embeds.map {|e| e.embed_type }.compact.uniq
    if types.size == 1
      return types[0] # can be [photo | video | rich | link | error]
    else
      return 'mixed'
    end
  end
  
  def rebuild_body
    strip_original_body
  end
  
  private
  def scan_for_urls
    self.urls.each do |url|
      if url.match(EMBEDLY_REGEX)
        embed = Embed.new({:post_id => self.id, :original_url => url})
        embed.save
      end
    end
  end
    
  def scan_for_hashtags
    logger.debug '#############'
    self.tag_list = hashtags.join(',') 
    logger.debug tag_list
  end
  
  def scan_for_machinetags
    self.machinetag_list = machinetags.join(',') if machinetags
  end
  
  def strip_original_body
    stripped = original_body.gsub(REPLY_REGEX,'').gsub(MACHINETAG_REGEX,'')
    urls.each do |url|
      if url.match(EMBEDLY_REGEX)
        stripped = stripped.gsub(url, '')
      end
    end
    
    self.body = stripped
  end
end
