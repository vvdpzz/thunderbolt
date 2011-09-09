class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  attr_accessible :login, :realname, :username, :credit, :money
  
  attr_accessor :login
  
  include Gravtastic
  gravtastic
  
  has_many :questions
  has_many :answers
  
  has_many :money_transactions
  has_many :credit_transactions  
  has_many :credit_prizes, :class_name => "CreditTransaction", :foreign_key => "winner_id"
  has_many :money_prizes, :class_name => "MoneyTransaction", :foreign_key => "winner_id"
  
  has_many :favorite_questions
  has_many :followed_questions
  
  has_many :followers, :class_name => "FollowedUser", :foreign_key => "user_id"
  has_many :following, :class_name => "FollowedUser", :foreign_key => "follower_id"
  has_many :mails
  
  before_create :create_login
  
  def update_by_sql(user_id,follower_id)
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=0";
    sql.begin_db_transaction 
    sql.update "update followed_users set followed = false where user_id = #{user_id} and follower_id = #{follower_id}";
    sql.commit_db_transaction
  end
      
  def async_follow_user(user_id)
    Resque.enqueue(FollowUser, user_id, self.id, self.realname)
  end
  
  def correct_answers_count
    Answer.where(:user_id => self.id, :is_correct => true).count
  end
  
  def has_relationship_redis(user_id)
    $redis.sismember("user:#{user_id}.follows", self.id)
  end
  
  def has_relationship_db(user_id,follower_id)
    FollowedUser.where(:user_id => user_id, :follower_id => follower_id, :followed => true)
  end
  
  protected

  def create_login
    email = self.email.split(/@/)
    login_taken = User.where(:username => email[0]).first
    self.username = email[0] unless login_taken
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  end
end
