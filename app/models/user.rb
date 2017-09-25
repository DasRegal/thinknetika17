class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable,
          :registerable,
          :recoverable,
          :rememberable,
          :trackable,
          :validatable,
          :omniauthable,
          omniauth_providers: [:facebook, :twitter]

  def author_of?(obj)
    self.id == obj.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization && authorization.user&.is_confirmed

    email = auth.info[:email]
    return nil unless email

    user = User.where(email: email).first
    if user
      user.create_authorization(auth) if user
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(auth)
    end
    user
  end

  def self.create_with_confirmation(auth)
    password = Devise.friendly_token[0, 20]
    fake_email = Devise.friendly_token[0, 10] + '@fake.fake'
    confirmation_token = Devise.friendly_token[0, 30]
    user = User.create!(
      email: fake_email,
      password: password,
      password_confirmation: password,
      confirmation_token: confirmation_token,
      is_confirmed: false)
    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
  end
end
