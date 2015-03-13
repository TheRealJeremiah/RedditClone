class UsersController < ApplicationController
  before_action only: [:show] do
    redirect_to new_user_path unless logged_in?
  end

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login_user!(@user)
      flash[:notice] = 'Successfully signed up!'
      redirect_to user_path(@user)
    else
      flash[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = User.find_by_id(params[:id])
    if @user
      render :show
    else
      flash[:errors] = ["Couldn't find user with that id"]
      redirect_to new_user_path
    end
  end

  private

  def user_params
    params[:user].permit(:username, :password)
  end
end
