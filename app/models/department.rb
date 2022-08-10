class Department < ApplicationRecord
  UPDATEABLE_ATTRS = %i(name description avatar).freeze
  has_many :reports, dependent: :destroy
  has_many :relationships, dependent: :destroy
  has_many :users, through: :relationships
  has_one_attached :avatar

  validates :name, presence: true,
            length: {maximum: Settings.digits.length_50},
            uniqueness: {case_sensitive: true}

  validates :description, presence: true,
            length: {maximum: Settings.digits.length_255}

  validates :avatar,
            content_type: {in: Settings.image.accept_format,
                           message: I18n.t(".invalid_img_type")},
            size: {less_than: Settings.image.max_size.megabytes,
                   message: I18n.t(".invalid_img_size")}

  scope :sort_created_at, ->{order :created_at}

  def display_avatar width = Settings.gravatar.width_default,
    height = Settings.gravatar.height_default
    avatar.variant resize_to_limit: [width, height]
  end

  def add_user user
    users << user
  end

  def unreported_users_now
    users - User.joins(:report_sends).where("reports.department_id = #{id}
              and reports.report_date = #{Time.zone.now.strftime('%Y-%m-%d')}")
  end
end
