class UsersController < ApplicationController
  set_tab :profile
  
  set_tab :asked,  :segment, :only => %w(show asked)

  def show
    @user = User.find params[:id]
    @questions = @user.questions.page(params[:page]).per(5)
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
      current_user.async_follow_user(user.id) if followed
      render :json => {:followed => followed}
    else
      render :json => {:error => true}, :status => :unprocessable_entity
    end
  end
  
  def asked
    user = User.find params[:id]
    @questions = user.questions if user
  end
  
  def answered
    user = User.find params[:id]
    if user
      @questions = Question.find_by_sql("select * from questions where id in (select question_id from answers where user_id = #{user.id})")
    end
  end
end
