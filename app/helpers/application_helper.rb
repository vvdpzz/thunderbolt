module ApplicationHelper
  def safe_html(text)
    sanitize text, :tags => %w(h1 h2 h3 h4 h5 h6 p a b strong em pre img br table th tr td ol ul li),
                   :attributes => %w(href src width height)
  end
  
  def up_voted(obj, uid)
    upclass = 'vote-up-off '
    obj_name = obj.class.name.downcase
    upclass += 'vote-up-on' if $redis.sismember("#{obj_name[0].chr}:#{obj.id}.up_voter", uid)
		link_to('vote up', "/#{obj_name}s/#{obj.id}/votes/up",
		  :remote => true,
		  :id => "#{obj_name}_#{obj.id}_up_class",
		  :class => upclass
		).html_safe
  end
  
  def down_voted(obj, uid)
    downclass = 'vote-down-off '
    obj_name = obj.class.name.downcase
    downclass += 'vote-down-on' if $redis.sismember("#{obj_name[0].chr}:#{obj.id}.down_voter", uid)
		link_to('vote down', "/#{obj_name}s/#{obj.id}/votes/down",
		  :remote => true,
		  :id => "#{obj_name}_#{obj.id}_down_class",
		  :class => downclass
		).html_safe
  end
end
