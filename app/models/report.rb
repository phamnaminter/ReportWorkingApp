class Report < ApplicationRecord
  UPDATEABLE_ATTRS = %i(report_date today_plan today_work
    today_problem tomorow_plan to_user_id).freeze
  belongs_to :from_user, class_name: User.name
  belongs_to :to_user, class_name: User.name
  has_many :comments, dependent: :destroy

  validates :report_date, presence: true,
            length: {maximum: Settings.digits.length_50}

  validates :today_plan, presence: true,
            length: {maximum: Settings.digits.length_255}

  validates :today_work, presence: true,
            length: {maximum: Settings.digits.length_255}

  validates :today_problem, presence: true,
            length: {maximum: Settings.digits.length_255}

  validates :tomorow_plan, presence: true,
            length: {maximum: Settings.digits.length_255}
end
