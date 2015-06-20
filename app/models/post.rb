class Post < ActiveRecord::Base
	has_many :comments, dependent: :destroy
	has_many :votes, as: :votable, dependent: :destroy
	has_many :users_who_voted, through: :votes, source: :user

	belongs_to :user

	validates :title, presence: true

	mount_uploader :picture, PictureUploader
end
