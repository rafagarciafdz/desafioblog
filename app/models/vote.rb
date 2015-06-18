class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  belongs_to :votable, polymorphic: true

  validates :user_id, uniqueness: {scope: :user_id}
end
