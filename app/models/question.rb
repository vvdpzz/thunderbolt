class Question < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  
  has_many :answers, :dependent => :destroy
  
  has_many :followers, :class_name => "FollowedQuestion", :foreign_key => "question_id",
           :conditions => ['followed = ?', true]
  
  scope :free, lambda { where(["credit = 0 AND money = 0.00"]) }
  scope :paid, lambda { where(["credit <> 0 OR money <> 0.00"])}
  scope :latest, order("created_at DESC")
  
  
  # validations
  validates_numericality_of :money, :message => "is not a number", :greater_than_or_equal_to => 0
  validates_numericality_of :credit, :message => "is not a number", :greater_than_or_equal_to => 0
  validates_presence_of :title, :message => "can't be blank"
  
  validate :enough_credit_to_pay
  validate :enough_money_to_pay
  
  def followed_by?(user_id)
    records = FollowedQuestion.where(:user_id => user_id, :question_id => self.id)
    if records.empty?
      return false
    else
      return records.first.followed
    end
  end
  
  def favorited_by?(user_id)
    records = FavoriteQuestion.where(:user_id => user_id, :question_id => self.id)
    if records.empty?
      return false
    else
      return records.first.favorited
    end
  end

  def enough_credit_to_pay
    errors.add(:credit, "you do not have enough credit to pay.") if self.user.credit < self.credit
  end
  
  def enough_money_to_pay
    errors.add(:money, "you do not have enough money to pay.") if self.user.money < self.money
  end
  
  def not_free?
    self.credit != 0 or self.money != 0
  end
  
  def deduct_credit
    self.user.update_attribute(:credit, self.user.credit - self.credit)
  end
  
  def deduct_money
    self.user.update_attribute(:money, self.user.money - self.money)
  end
  
  def order_credit
    if self.credit > 0
      order = CreditTransaction.new(
        :user_id => self.user.id,
        :question_id => self.id,
        :value => self.credit,
        :trade_type => TradeType::ASK,
        :trade_status => TradeStatus::NORMAL
      )
      return order.save
    end
  end
  
  def order_money
    if self.money > 0
      order = MoneyTransaction.new(
        :user_id => self.user.id,
        :question_id => self.id,
        :value => self.money,
        :trade_type => TradeType::ASK,
        :trade_status => TradeStatus::NORMAL
      )
      return order.save
    end
  end
  
  def follow_user_ids
    FollowedQuestion.select('user_id').where(:question_id => self.id, :followed => 1).collect{ |item| item.user_id }
  end
  
  def was_not_answered_by?(user_id)
    self.answers.select('user_id').where(:user_id => user_id).empty?
  end
  
  def async_new_answer(answer_id)
    Resque.enqueue(NewAnswer, self.id, answer_id)
  end
  
  def async_accept_answer(answer_id)
    Resque.enqueue(AcceptAnswer, self.id, answer_id)
  end

end
