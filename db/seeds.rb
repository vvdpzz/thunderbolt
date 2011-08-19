# Create some users
User.create(:realname => '陈政宇', :email => 'vvdpzz@gmail.com', :password => 'vvdpzz')
User.create(:realname => '喻柏程', :email => 'tzzzoz@gmail.com', :password => 'tzzzoz')
User.create(:realname => '杨政权', :email => 'yangzhengquan@gmail.com', :password => 'yangkit')
User.create(:realname => '薛晓东', :email => 'xuexiaodong79@gmail.com', :password => 'xxdxxd')

User.all.each {|u| u.update_attributes(:credit => 1000, :money => 1000)}

