# Create some users
User.create(:realname => '陈政宇', :email => 'vvdpzz@gmail.com', :password => 'vvdpzz', :aboutme => '机器人爱好者，自然语言处理和机器翻译爱好者，Web开发者，JSOIer, ACMer')
User.create(:realname => '喻柏程', :email => 'tzzzoz@gmail.com', :password => 'tzzzoz', :aboutme => 'AI,软件工程，Web应用开发,Ruby On Rails')
User.create(:realname => '杨政权', :email => 'yangzhengquan@gmail.com', :password => 'yangkit', :aboutme => '徘徊在80与90间的宅男、伪技术控')
User.create(:realname => '薛晓东', :email => 'xxd@gmail.com', :password => 'xxdxxd', :aboutme => 'DBA/喜欢Python/喜欢/关注效率工具/喜欢手机看杂书/前两年反感小资目前反感文艺腔/下班健身周末游泳很久没巴柔/╭∩╮GFW╭∩╮')

User.all.each {|u| u.update_attributes(:credit => 1000, :money => 1000)}

