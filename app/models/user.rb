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
  
  before_create :create_login
  
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
