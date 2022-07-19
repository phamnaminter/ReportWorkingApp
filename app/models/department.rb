class Department < ApplicationRecord
  has_many :reports, dependent: :destroy
  has_many :relationships, dependent: :destroy
  has_many :users, through: :relationships
end
