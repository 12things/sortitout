class User < ActiveRecord::Base
  acts_as_authentic
  #before_validation :generate_password
  has_many :memberships, :dependent => :destroy
  has_many :assigned_topics, :through => :memberships, :source => :topic
  has_many :topics, :dependent => :destroy
  has_many :posts, :dependent => :nullify
  has_many :votes, :dependent => :destroy
  
  attr_accessible :email, :password, :password_confirmation
  
  def generate_password
    if self.new_record?
      size=6
      chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
      self.password = self.password_confirmation = (1..size).collect{|a| chars[rand(chars.size)] }.join
      self.password = self.password_confirmation = 'test' if RAILS_ENV=='development'
    end
  end
  
  def member_or_owner? topic
    owner?(topic) || member?(topic)
  end
  
  def member? topic
    !assigned_topics.empty? && assigned_topics.include?(topic)
  end

  def owner? topic
    self.id == topic.user_id
  end
    
  def activate!
    self.active = true
    save
  end
end
