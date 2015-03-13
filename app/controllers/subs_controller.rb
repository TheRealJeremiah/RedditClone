class SubsController < ApplicationController
  before_action only: [:new, :create, :edit, :update] do
    redirect_to new_session_path unless logged_in?
  end

  def index
    @subs = Sub.all
    render :index
  end

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.user_id = current_user.id
    if @sub.save
      flash[:notice] = "Successfully created sub"
      redirect_to sub_path(@sub)
    else
      flash[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def show
    @sub = Sub.find_by_id(params[:id])
    if @sub
      render :show
    else
      flash[:errors] = ["Cannot find sub with that id"]
      redirect_to subs_path
    end
  end

  def edit
    @sub = Sub.find_by_id(params[:id])
    if @sub
      if @sub.user_id == current_user.id
        render :edit
      else
        flash[:errors] = ["You can't edit a sub you don't moderate"]
        redirect_to subs_path
      end
    else
      flash[:errors] = ["The sub with that id does not exist"]
      redirect_to subs_path
    end
  end

  def update
    @sub = Sub.find_by_id(params[:id])
    if @sub
      if @sub.user_id == current_user.id
        if @sub.update(sub_params)
          flash[:notice] = "Successfully updated sub #{@sub.title}"
        else
          flash[:errors] = @sub.errors.full_messages
        end
        redirect_to sub_path(@sub)
      else
        flash[:errors] = ["You can't edit a sub you don't moderate"]
        redirect_to subs_path
      end
    else
      flash[:errors] = ["The sub with that id does not exist"]
      redirect_to subs_path
    end
  end

  private

  def sub_params
    params[:sub].permit(:title, :description)
  end
end
