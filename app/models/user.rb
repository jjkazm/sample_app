class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :followees, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id",
                                  dependent: :destroy
  has_many :followers, through: :passive_relationships
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true


  class << self
    # Returns hash digest for the given password
    def digest(password)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(password, cost: cost)
    end

    # Returns a random token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end


  # Associates a remember token with the user and saves the corresponding remember
  # digest to the database
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest) == token
  end

  # Forgets user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Creates and asigns activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_link
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_token
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                  reset_sent_at: Time.zone.now)
  end

  def send_reset_token
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired
    reset_sent_at < 2.hours.ago
  end

  def delete_reset_digest
    update_attribute(:reset_digest, nil)
  end


  # Defines a proto-feed
  def feed
    ids_of_followees = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{ids_of_followees}) OR user_id = :user_id", user_id: id)
  end

  def following?(someone)
    self.followees.include?(someone)
  end

  def follow(someone)
    self.followees << someone
  end

  def unfollow(someone)
    self.followees.delete(someone)
  end

  private
    # Converts email to all lower-case
    def downcase_email
      self.email.downcase!
    end

end
