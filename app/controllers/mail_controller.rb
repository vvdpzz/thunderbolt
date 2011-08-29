class MailController < ApplicationController
  
  def new
    @user = User.find params[:id]
  end
  
  def create
    sender = User.select("id,realname").where(:id => current_user.id)
    receiver = User.select("id,realname").where(:id => params[:user_id])
    batch_id = $redis.incr('batch_id') 
    $redis.zadd("mail:between.#{current_user.id}.#{params[:user_id]}", batch_id, "{title:#{params[:title]},content:#{params[:content]}}")
    Mail.create(:batch_id      => batch_id,
                :sender_id     => sender.first.id,
                :sender_name   => sender.first.realname,
                :receiver_id   => receiver.first.id,
                :receiver_name => receiver.first.realname,
                :title         => params[:title],
                :content       => params[:content])
  end
  
  def reply
    
  end
  
  def show
    
  end

end
