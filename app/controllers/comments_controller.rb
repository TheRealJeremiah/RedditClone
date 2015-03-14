class CommentsController < ApplicationController
  before_action do
    redirect_to subs_path unless logged_in?
  end

  def new
    @post = Post.find_by_id(params[:post_id])
    if @post
      @comment = Comment.new
      render :new
    else
      flash[:errors] = ['Cannot find post with that id']
      redirect_to subs_path
    end
  end

  def create
    @post = Post.find_by_id(params[:post_id]) ||
            Comment.find_by_id(params[:parent_id]).post
    # fail
    if @post
      @comment = current_user.comments.new(comment_params)
      @comment.post_id = @post.id
      @comment.parent_comment_id = params[:parent_id]
      unless @comment.save
        flash[:errors] = @comment.errors.full_messages
      end
      redirect_to post_path(@post)
    else
      flash[:errors] = ['Cannot find post with that id']
      redirect_to subs_path
    end
  end

  def show
    @comment = Comment.find_by_id(params[:id])
    if @comment
      @comments_by_parent_id = @comment.post.comments_by_parent_id
      render :show
    else
      flash[:errors] = ["Cannot find comment with that id"]
      redirect_to subs_path
    end
  end

  private

  def comment_params
    params[:comment].permit(:content, :parent_id)
  end
end
