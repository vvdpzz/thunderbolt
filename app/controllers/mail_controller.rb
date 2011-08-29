class MailController < ApplicationController
  
  def new
    @user = User.find params[:id]
  end
  
  def create
    batchid = $redis.incr(batch_id) 
    $redis.zadd("mail:between.#{current_user.id}.#{params[:id]}", batchid, "{title:#{params[:title]},content:#{params[:content]}")
    # current_user.mails.create(params[:mail])
    # 这 个 地 方 是 没 有 params[:mail]的
  end

end
