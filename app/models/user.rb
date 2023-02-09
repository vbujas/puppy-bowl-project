# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  username               :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  name                   :string(255)
#  oauth_token            :string(255)
#  oauth_expires_at       :datetime
#

class User < ActiveRecord::Base
   has_one :team

  validates :first_name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :twitter]

  # validates :first_name, :email, :password, :password_confirmation, presence: true, if: Proc.new { self.provider.nil? }
  # validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }, if: Proc.new { self.provider.nil? }
  # validates :email, uniqueness: true, if: Proc.new { self.provider.nil? }
  validates :password, :password_confirmation, length: { minimum: 8 }, if: Proc.new { self.provider.nil? }

  # has_attached_file :avatar, :styles => { :thumb => "48x48>" }, :default_url => "missing.jpg", :use_timestamp => false
  # validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # validates :username, presence: true
  # validates :username,
  #   :uniqueness => {
  #     :case_sensitive => false
  #   }

  before_save :add_user_role, unless: Proc.new { self.admin? }

  def admin?
   self.role == "admin"
  end

  def user?
   self.role == "user"
  end

  def email_required?
    if provider == :facebook || provider.blank?
      true
    else
      false
    end
  end

  # def email_changed?
  #   false
  # end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email if auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.image_url = auth.info.image
      if auth.provider == "facebook"
        user.first_name = auth.info.first_name.split(' ')[0] if auth.info.first_name
        user.last_name = auth.info.first_name.split(' ')[1] if auth.info.first_name
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      else
        user.first_name = auth.info.name.split(' ')[0] if auth.info.name
        user.last_name = auth.info.name.split(' ')[1] if auth.info.name
      end
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def add_user_role
    self.role = "user"
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(self.oauth_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil
  end

  # https://graph.facebook.com/userID/links?access_token=AT

  def get_friends_ids
    facebook { |fb| fb.get_connection("me", "friends").map{|i| i["id"]} }
  end
end
