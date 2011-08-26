class UsersController < ApplicationController
  set_tab :profile

  def show
    @user = User.find params[:id]
  end

  def follow
    user = User.find params[:id]
    followed = true
    if user and user.id != current_user.id
      records = FollowedUser.where(:user_id => user.id, :follower_id => current_user.id)
      if records.empty?
        user.followers.create(:follower_id => current_user.id)
      else
        record = records.first
        followed = record.followed if record.update_attribute(:followed, !record.followed)
      end
      render :json => {:followed => followed}
    else
      render :json => {:error => true}, :status => :unprocessable_entity
    end
  end
end
