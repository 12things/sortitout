class AddMembershipsCountToTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :memberships_count, :integer, :default => 0
    
    Topic.all.each do |topic|
      Topic.reset_counters(topic.id, :memberships)
    end
  end

  def self.down
    remove_column :topics, :memberships_count
  end
end

