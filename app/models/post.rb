class Post < ActiveRecord::Base
	has_many :comments, dependent: :destroy

	belongs_to :user

	validates :title, presence: true

	mount_uploader :picture, PictureUploader
end
