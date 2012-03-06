class Cms::UsersController < Cms::SecuredController

  def index
    @users = Cms::User.all.order([:email, :asc])
    respond_with @users
  end

  def new
    @user = Cms::User.new
    respond_with @user
  end

  def create
    @user = Cms::User.new(params[:cms_user])
    if @user.save
      redirect_to edit_cms_user_path(@user)
    else
      render 'new'
    end
  end

  def edit
    @user = Cms::User.find(params[:id])
    respond_with @user
  end

  def update
    @user = Cms::User.find(params[:id])

    # update differently depending if a new password was provided
    any_passwords = %w(password password_confirmation).any? do |field|
      params[:cms_user][field].present?
    end

    unless any_passwords
      params[:cms_user].delete(:password)
      params[:cms_user].delete(:password_confirmation)
    end

    if @user.update_attributes(params[:cms_user])
      redirect_to edit_cms_user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    user = Cms::User.find(params[:id])
    user.destroy
    redirect_to cms_users_path
  end
end