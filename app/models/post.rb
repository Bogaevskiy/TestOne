class Post < ApplicationRecord
	belongs_to :user
	has_one :grade
	validates :name, :content, presence: true
	accepts_nested_attributes_for :user, :grade
end
