class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.text :body
      t.text :original_body
      
      t.integer :user_id
      t.integer :topic_id
      
      # nested set
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      
      t.integer :votes_count, :default => 0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
