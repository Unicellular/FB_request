class CreateFbposts < ActiveRecord::Migration
  def change
    create_table :fbposts do |t|
      t.string :fb_id
      t.string :message
      t.string :link
      t.string :created_time
      t.string :fb_object_id
      t.string :status_type
      t.string :fb_type
      t.string :picture
      t.string :from_name
      t.string :from_id
      t.integer :likes_count
      t.integer :shares_count
      t.integer :comments_count
      t.integer :hotscore

      t.timestamps
    end
  end
end
