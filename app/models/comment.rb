class Comment < ActiveRecord::Base
  belongs_to :post, counter_cache: true
  belongs_to :user

  has_many :votes, as: :votable, dependent: :destroy
  has_many :users_who_voted, through: :votes, source: :user

  validates :comment, presence:true
end
