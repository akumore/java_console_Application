class Cms::User
  include Mongoid::Document
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

  #def is_admin?
  #  #TODO implementation of roles required!
  #  %w(admin@screenconcept.ch staging@alfred-mueller.ch).include? email
  #end

  def role
    :admin
  end

  def editor?
    role == :editor
  end

  def admin?
    role == :admin
  end

end
