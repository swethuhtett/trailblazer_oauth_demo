class PostsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @form = Post::Contract::Form.new(Post.new)
  end

  def create
    result = Post::Operation::Create.call(params: { post: post_params })

    if result.success?
      redirect_to post_path(result[:model]), notice: "Post created."
    else
      puts result["contract.default"].errors.to_s.inspect
      @form = result["contract.default"]
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @form = Post::Contract::Form.new(@post)
  end

  def update
    result = Post::Operation::Update.call(params: { id: params[:id], post: post_params })

    if result.success?
      redirect_to post_path(result[:model]), notice: "Post updated."
    else
      @form = result["contract.default"]
      render :edit
    end
  end

  def destroy
    Post::Operation::Delete.call(params: { id: params[:id] })
    redirect_to posts_path, notice: "Post deleted."
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
