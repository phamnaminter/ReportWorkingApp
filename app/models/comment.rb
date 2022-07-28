class Comment < ApplicationRecord
  UPDATEABLE_ATTRS = %i(report_id description).freeze
  belongs_to :user
  belongs_to :report

  validates :description, presence: true,
            length: {maximum: Settings.digits.length_255}

  scope :sort_created_at, ->{order :created_at}

  scope :by_report_id, (lambda do |id|
    where(report_id: id) if id.present?
  end)
end
