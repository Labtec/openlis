class UsersController < ApplicationController
  before_filter :require_no_user, only: [:new, :create]
  before_filter :require_user, only: [:edit]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to root_url
    else
      render action: 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:notice] = "Successfully updated profile."
      redirect_to root_url
    else
      render action: 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :initials, :language, :first_name, :last_name, :prefix, :suffix, :register)
  end
end
