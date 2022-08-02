class User < ApplicationRecord
  include CreateNotify

  UPDATEABLE_ATTRS = %i(full_name email password
    password_confirmation avatar).freeze
  has_many :relationships, dependent: :destroy
  has_many :departments, through: :relationships
  has_many :report_sends, class_name: :Report, foreign_key: :from_user,
            dependent: :destroy
  has_many :report_receives, class_name: :Report, foreign_key: :to_user,
            dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifies, dependent: :destroy

  before_save :downcase_email
  after_create :notify_create
  after_update :notify_update

  enum role: {normal: 0, admin: 1}

  VALID_EMAIL_REGEX = Settings.regex.email

  validates :full_name, presence: true,
            length: {maximum: Settings.digits.length_50}

  validates :email, presence: true,
            length: {maximum: Settings.digits.length_255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: true}

  validates :password, presence: true,
            length: {minimum: Settings.digits.length_6},
            allow_nil: true

  validates :avatar,
            content_type: {in: Settings.image.accept_format,
                           message: I18n.t(".invalid_img_type")},
            size: {less_than: Settings.image.max_size.megabytes,
                   message: I18n.t(".invalid_img_size")}

  has_secure_password

  has_one_attached :avatar

  scope :sort_created_at, ->{order :created_at}

  scope :by_email, (lambda do |email|
    where(["email LIKE (?)", "%#{email}%"]) if email.present?
  end)

  scope :by_full_name, (lambda do |name|
    where(["full_name LIKE (?)", "%#{name}%"]) if name.present?
  end)

  scope :not_in_department, (lambda do |department_id|
    User.where("NOT EXISTS( SELECT user_id from `relationships` as re where
      re.user_id = users.id and department_id = '#{department_id}' )")
  end)

  def display_avatar width = Settings.gravatar.width_default,
    height = Settings.gravatar.height_default
    avatar.variant resize_to_limit: [width, height]
  end

  def join_department department
    departments << department
  end

  def leave_department department
    departments.delete department
  end

  private

  def downcase_email
    email.downcase!
  end

  def notify_create
    create_notify id, I18n.t("welecome_create"),
                  routes.user_path(id: id)
  end

  def notify_update
    create_notify id, I18n.t("update_profile"),
                  routes.user_path(id: id)
  end
end
