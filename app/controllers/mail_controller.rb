class MailController < ApplicationController
  
  def new
    @user = User.find params[:id]
  end
  
  def send
    batchid = $redis.incr(batch_id) 
    $redis.zadd("mail:between.#{current_user.id}.#{params[:id]}", batchid, "{title:#{params[:title]},content:#{params[:content]}")
    current_user.mails.create(params[:mail])
  end

end
