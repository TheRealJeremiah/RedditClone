class PostsController < ApplicationController
  helper_method :full_url

  def show
    @post = Post.find_by_id(params[:id])
    if @post
      render :show
    else
      flash[:errors] = ['Cannot find post with that id']
      redirect_to subs_path
    end
  end

  def new
    @post ||= Post.new
    @subs = Sub.all
    render :new
  end

  def create
    @post = current_user.authored_posts.new(post_params)
    create_postsubs
    # fail
    if @post.save
      flash[:notice] = 'Succesfully created post!'
      redirect_to post_path(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      @subs = Sub.all
      render :new
    end
  end

  def edit
    @post = Post.find_by_id(params[:id])
    @subs = Sub.all
    if @post
      if @post.user_id == current_user.id
        render :edit
      else
        flash[:errors] = ["You can't edit a post you don't moderate"]
        redirect_to sub_path(@post.sub)
      end
    else
      flash[:errors] = ["The post with that id does not exist"]
      redirect_to subs_path
    end
  end

  def update
    @post = Post.find_by_id(params[:id])
    @subs = Sub.all
    if @post
      if @post.user_id == current_user.id
        if @post.update(post_params)
          flash[:notice] = "Successfully updated post #{@post.title}"
        else
          flash[:errors] = @post.errors.full_messages
        end
      else
        flash[:errors] = ["You can't edit a post you didn't create"]
      end
      redirect_to post_path(@post)
    else
      flash[:errors] = ["The post with that id does not exist"]
      redirect_to subs_path
    end
  end

  def full_url(url)
    if url.start_with?("http://")
      url
    else
      "http://#{url}"
    end
  end

  private

  def post_params
    params[:post].permit(:title, :url, :content, :sub_ids)
  end

  def create_postsubs
    sub_ids = params[:post][:sub_ids].map(&:to_i)
    @post.sub_ids = sub_ids
  end
end
