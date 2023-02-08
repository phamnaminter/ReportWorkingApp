class Notify < ApplicationRecord
  belongs_to :user

  enum read: {unread: 0, read: 1}

  scope :recent, ->{order(created_at: :desc)}
end
