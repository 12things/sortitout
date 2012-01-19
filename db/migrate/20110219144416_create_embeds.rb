class CreateEmbeds < ActiveRecord::Migration
  def self.up
    create_table :embeds do |t|
      t.integer :post_id
      t.string :original_url
      
      t.string :provider_name
      t.string :provider_url
      t.string :embed_type
      t.string :description
      t.string :title
      t.string :url  # should be the image source if type=photo
      t.text :html # only video types      
      t.string :width
      t.string :height
      t.string :author_name
      t.string :author_url
      t.string :thumbnail_url
      t.string :thumbnail_width
      t.string :thumbnail_height
      t.string :version
      t.string :cache_age
      
      t.timestamps
    end
  end

  def self.down
    drop_table :embeds
  end
end
