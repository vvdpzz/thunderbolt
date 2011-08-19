class Question < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  
  has_many :answers, :dependent => :destroy
  
  scope :free, lambda { where(["credit = 0 AND money = 0.00"]) }
  scope :paid, lambda { where(["credit <> 0 OR money <> 0.00"])}
  scope :latest, order("created_at DESC")
end
