class User < ApplicationRecord
  has_many :relationships, dependent: :destroy
  has_many :departments, through: :relationships
  has_many :report_sends, class_name: :Report, foreign_key: :from_user,
            dependent: :destroy
  has_many :report_receives, class_name: :Report, foreign_key: :to_user,
            dependent: :destroy
  has_many :comments, dependent: :destroy
end
