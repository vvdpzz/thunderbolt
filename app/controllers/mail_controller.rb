class MailController < ApplicationController
  
  def new
    @user = User.find params[:id]
  end
  
  def create
    sender = User.select("id,realname,email").where(:id => current_user.id)
    receiver = User.select("id,realname,email").where(:id => params[:user_id])
    batch_id = $redis.incr('batch_id') 
    t = Time.now
    if sender != receiver
      hash = {}
      hash = {:sender_id      => sender.first.id,
              :sender_name    => sender.first.realname,
              :sender_image   => sender.first.gravatar_url(:size => 32),
              :receiver_id    => receiver.first.id, 
              :receiver_name  => receiver.first.realname, 
              :receiver_image => receiver.first.gravatar_url(:size => 32),
              :title          => params[:title],
              :content        => params[:content], 
              :time           => t}
      $redis.zadd("mail:between.#{current_user.id}.#{params[:user_id]}.#{batch_id}", batch_id, MultiJson.encode(hash))
      Mail.create(:batch_id       => batch_id,
                  :sender_id      => sender.first.id,
                  :sender_name    => sender.first.realname,
                  :sender_image   => sender.first.gravatar_url(:size => 32),
                  :receiver_id    => receiver.first.id,
                  :receiver_name  => receiver.first.realname,
                  :receiver_image => receiver.first.gravatar_url(:size => 32),
                  :title          => params[:title],
                  :content        => params[:content],
                  :created_at     => t)
    end
  end

  def renew
    mail = Mail.where(:id => params[:id])
    @sender_id = mail.first.sender_id
    @sender_image = mail.first.sender_image
    @mail_id = mail.first.id
  end
    
  def reply
    mail = Mail.where(:id => params[:mail_id])
    t = Time.now
    hash = {}
    hash = {:sender_id      => mail.first.receiver_id,
            :sender_name    => mail.first.receiver_name,
            :sender_image   => mail.first.receiver_image,
            :receiver_id    => mail.first.sender_id,
            :receiver_name  => mail.first.sender_name,
            :receiver_image => mail.first.sender_image,
            :title          => mail.first.title,
            :content        => params[:content],
            :time           => t}
    $redis.zadd("mail:between.#{mail.first.sender_id}.#{current_user.id}.#{mail.first.batch_id}", mail.first.batch_id, MultiJson.encode(hash))
    Mail.create(:batch_id       => mail.first.batch_id,
                :sender_id      => mail.first.receiver_id,
                :sender_name    => mail.first.receiver_name,
                :sender_image   => mail.first.receiver_image,
                :receiver_id    => mail.first.sender_id,
                :receiver_name  => mail.first.sender_name,
                :receiver_image => mail.first.sender_image,
                :title          => mail.first.title,
                :content        => params[:content],
                :created_at     => t)
  end
  
  def view
    @mail = Mail.select("id,title").find_by_batch_id params[:batch_id]
    mails = $redis.KEYS("mail:between.*.#{current_user.id}.#{params[:batch_id]}")
    @mails = mails.collect{|mail| $redis.ZRANGE("#{mails}",0,-1)} 
  end
  
  def inbox
    @mails = $redis.KEYS("mail:between.*.#{current_user.id}.*")
    if @mails
      @batch_id = @mails.first.split(".")[3]
    end
    respond_to do |format|
      format.html
      format.json {render :json => {:mails => @mails}}
    end
  end
end
