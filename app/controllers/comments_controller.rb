class CommentsController < ApplicationController
  def create
  	@post = Post.find(params[:post_id])
  	@comment = @post.comments.build(comments_params)
  	@comment.save
  	if @comment.save
  		redirect_to @post , notice: "El comentario fue creado correctamente"
  	else
  		redirect_to @post , alert: "El comentario no ha podido ser creado creado"
  	end
  end

  private
  def comments_params
  	params.require(:comment).permit(:comment)
  end
end
