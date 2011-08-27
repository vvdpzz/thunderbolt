class FollowUser
  @queue = :follow_user

  # a follow b
  def self.perform(a_id, b_id, a_realname)
    html = "<a href=\"/users/#{a_id}\">#{a_realname}</a> 关注了你。"
    Notification.create(
      :user_id => b_id,
      :content => html
    )
  end
end