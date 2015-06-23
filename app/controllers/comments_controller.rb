class CommentsController < ApplicationController
  load_and_authorize_resource
  def create
  	@post = Post.find(params[:post_id])
  	@comment = @post.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html {redirect_to @post , notice: "El comentario fue creado correctamente"}
        format.js
      else
        format.html {redirect_to @post , alert: "El comentario no ha podido ser creado creado"}
        format.js
      end
    end
  	#@comment.save
  	#if @comment.save
  	#	redirect_to @post , notice: "El comentario fue creado correctamente"
  	#else
  	#	redirect_to @post , alert: "El comentario no ha podido ser creado creado"
  	#end
  end

  #Creacòn del Voto DUDAAAAAAAA
  def upvote
    #@vote = Vote.find_or_initialize_by(user: current_user, post: @post)
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:comment_id])
    @vote = @comment.votes.build(user:@current_user)
    
    respond_to do |format|
      if @comment.users_who_voted.include? current_user
        @increment = -1
        @comment.votes.where(user:current_user).first.delete
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
  end

  private
  def comment_params
  	params.require(:comment).permit(:comment)
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
