class Report < ApplicationRecord
  belongs_to :from_user, class_name: User.name
  belongs_to :to_user, class_name: User.name
  has_many :comments, dependent: :destroy
end
