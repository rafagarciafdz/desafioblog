class PostsController < ApplicationController
  #before_action :set_post, only: [:show, :edit, :update, :destroy]
  #before_action :authenticate_user!, except: [:new, :create]
  #before_action :check_moderator!, only: [:new, :create]
  load_and_authorize_resource

  # GET /posts
  # GET /posts.json
  def index
    #@posts = Post.all
    #render json: params
    @query = params[:q]
    if @query.nil?
      @posts = Post.all
    else
      @posts = Post.where("title ilike ? or content ilike ?", "%#{@query}%", "%#{@query}%")
    end

    @posts = @posts.page params[:page]
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    #@last_comments = @post.comments.last(5)
    @last_comments = @post.comments.all
    @comment = @post.comments.build
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #Creacòn del Voto
  def upvote
    #@vote = Vote.find_or_initialize_by(user: current_user, post: @post)
    @post = Post.find(params[:id])
    @vote = @post.votes.build(user:@current_user)

    respond_to do |format|
      if @post.users_who_voted.include? current_user
        @increment = -1
        @post.votes.where(user:current_user).first.delete
        format.html {redirect_to @post, notice: "Tu voto ha sido borrado"}
        format.js
      elsif @vote.save
        @increment = +1
        format.html {redirect_to @post, notice: "Tu voto ha sido guardado"}
        format.js
      else
        @increment = 0
        format.html {redirect_to @post, notice: "Tu voto no ha podido ser"}
        format.js
      end
    end
    #return destroy_and_redirect if @vote.persisted?
    #save_and_redirect
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #def set_post
    #  @post = Post.find(params[:id])
    #end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :picture, :picture_cache, :remote_picture_url)
    end

    def check_moderator!
      authenticate_user!
      unless current_user.moderator?
        redirect_to root_path, alert: "No tienes acceso"
      end
    end

    def destroy_and_redirect
      @vote.destroy
      redirect_to @post, notice: "Tu voto fue anulado"
    end

    def save_and_redirect
      if @vote.save
        redirect_to @post, notice: "Tu voto fue creado exitosamente"
      else
        redirect_to @post, notice: @vote.errors.full_messages.join(", ")
      end
    end
end
