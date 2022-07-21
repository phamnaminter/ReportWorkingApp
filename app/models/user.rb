class User < ApplicationRecord
  has_many :relationships, dependent: :destroy
  has_many :departments, through: :relationships
  has_many :report_sends, class_name: :Report, foreign_key: :from_user,
            dependent: :destroy
  has_many :report_receives, class_name: :Report, foreign_key: :to_user,
            dependent: :destroy
  has_many :comments, dependent: :destroy

  VALID_EMAIL_REGEX = Settings.regex.email

  validates :full_name, presence: true,
            length: {maximum: Settings.digits.length_50}

  validates :email, presence: true,
            length: {maximum: Settings.digits.length_255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true

  validates :password, presence: true,
            length: {minimum: Settings.digits.length_6}

  has_secure_password

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
