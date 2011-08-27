class FollowUser
  @queue = :follow_user

  def self.perform(user_id, follower_id, follower_realname)
    html = "<a href=\"/users/#{follower_id}\">#{follower_realname}</a> 关注了你。"
    Notification.create(:user_id => user_id, :content => html)
  end
end