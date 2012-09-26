class Cms::User
  include Mongoid::Document

  ROLES = %w(admin editor)

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :null => false
  field :encrypted_password, :type => String, :null => false

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  # First and last name
  field :first_name, :type => String
  field :last_name,  :type => String
  validates :first_name, :presence => true
  validates :last_name,  :presence => true

  # Role management
  field :role, :type => :String
  validates :role, :presence => true, :inclusion => ROLES

  field :wants_review_emails, :type => Boolean

  scope :admins, where(:role => :admin)
  scope :receiving_review_emails, where(:role => :admin).where(:wants_review_emails => true)

  def editor?
    role.to_sym == :editor
  end

  def admin?
    role.to_sym == :admin
  end

end
