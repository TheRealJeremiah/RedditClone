class SessionsController < ApplicationController
  before_action only: [:new] do
    redirect_to user_path(current_user) if logged_in?
  end

  def new
  end

  def create
    @user = User.find_by_credentials(session_params)
    if @user
      login_user!(@user)
      flash[:notice] = "Welcome back, #{@user.username}"
      redirect_to user_path(@user)
    else
      flash[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def destroy
    logout
    redirect_to new_session_path
  end

  private

  def session_params
    params[:session].permit(:username, :password)
  end
end
