class CreateFollowedUsers < ActiveRecord::Migration
  def change
    create_table :followed_users do |t|
      t.references :user
      t.references :follower
      t.boolean :followed, :default => true

      t.timestamps
    end
    add_index :followed_users, :user_id
    add_index :followed_users, :follower_id
  end
end
