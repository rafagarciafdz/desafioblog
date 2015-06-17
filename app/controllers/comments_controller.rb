class CommentsController < ApplicationController
  load_and_authorize_resource
  def create
  	@post = Post.find(params[:post_id])
  	@comment = @post.comments.build(comment_params)
    @comment.user = current_user
  	@comment.save
  	if @comment.save
  		redirect_to @post , notice: "El comentario fue creado correctamente"
  	else
  		redirect_to @post , alert: "El comentario no ha podido ser creado creado"
  	end
  end

  private
  def comment_params
  	params.require(:comment).permit(:comment)
  end
end
