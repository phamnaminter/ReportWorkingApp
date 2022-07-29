class Comment < ApplicationRecord
  include CreateNotify

  UPDATEABLE_ATTRS = %i(report_id description).freeze
  belongs_to :user
  belongs_to :report

  before_create :notify

  validates :description, presence: true,
            length: {maximum: Settings.digits.length_255}

  scope :sort_created_at, ->{order :created_at}

  scope :by_report_id, (lambda do |id|
    where(report_id: id) if id.present?
  end)

  private

  def notify
    create_notify report.from_user.id, I18n.t("comment_notify"),
                  routes.report_path(id: report_id)
  end
end
