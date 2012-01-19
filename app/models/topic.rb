class Topic < ActiveRecord::Base
  has_many :posts, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  belongs_to :user
  validates_presence_of :title
  
  def member_or_owner? user
    owner?(user) || member?(user)
  end
  
  def member? user
    !members.empty? && members.include?(user)
  end

  def owner? user
    self.user_id == user.id
  end
  
  def photo_embeds
    Embed.joins({:post => :topic}).where("topics.id = ? AND embeds.embed_type = 'photo'", self.id).order("updated_at DESC").limit(5)
  end
  
  def embeds_count
    Embed.joins({:post => :topic}).where("topics.id = ?", self.id).count
  end
end
