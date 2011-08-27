$redis = Redis.new(:host => 'localhost', :port => 6379)

Resque.redis = $redis

# APP_CONFIG = YAML.load_file(File.join(Rails.root, "config", "settings.yml"))