class Cms::UsersController < Cms::SecuredController
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cms_dashboards_path, :alert => exception.message
  end

  def index
    @users = Cms::User.all.order([:email, :asc])
    respond_with @users
  end

  def new
    @user = Cms::User.new
    authorize! :new, @user
    respond_with @user
  end

  def create
    @user = Cms::User.new(params[:cms_user])
    authorize! :create, @user
    if @user.save
      flash[:success] = t("cms.users.create.success", :email=>@user.email)
    end
    respond_with @user, :location => [:cms, :users]
  end

  def edit
    @user = Cms::User.find(params[:id])
    authorize! :edit, @user
    respond_with @user
  end

  def update
    @user = Cms::User.find(params[:id])
    authorize! :update, @user

    # update differently depending if a new password was provided
    any_passwords = %w(password password_confirmation).any? do |field|
      params[:cms_user][field].present?
    end

    unless any_passwords
      params[:cms_user].delete(:password)
      params[:cms_user].delete(:password_confirmation)
    end

    if @user.update_attributes(params[:cms_user])
      flash[:success] = t("cms.users.update.success", :email=>@user.email)
    end
    respond_with @user, :location => [:cms, :users]
  end

  def destroy
    @user = Cms::User.find(params[:id])
    authorize! :destroy, @user
    if @user.destroy
      flash[:success] = t("cms.users.destroy.success", :email=>@user.email)
    end
    redirect_to [:cms, :users]
  end
end