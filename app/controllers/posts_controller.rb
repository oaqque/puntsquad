class PostsController < ApplicationController
  def index
    @posts = Post.all.order('created_at DESC')
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
        flash[:success] = 'Post Successfull Submitted.'
        redirect_to @post
    else
      flash[:danger] = 'Error, Post has not been logged. Try again mate.'
      redirect_to new_post_path
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to @post
      flash[:success] = 'Post Successfull Updated.'
    else
      render action :edit
      flash[:danger] = 'Post Unable to be Updated.'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to posts_path
    flash[:success] = 'Post Successfull Deleted.'
  end

  private
    def post_params
      params.require(:post).permit(:title, :text, :herobg)
    end

end
