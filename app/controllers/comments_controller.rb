class CommentsController < ApplicationController
  filter_resource_access

  # instancia un nuevo comentario
  def new
    @widget = Widget.find(params[:widget_id])
    @comment = @widget.comments.build
  end

  # guarda el nuevo comentario
  def create
    @widget = Widget.find(params[:widget_id])
    @comment = @widget.comments.build(params[:comment])
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "Comentario agregado exitosamente."
      redirect_to widget_path(@widget)
    else
      render :action => 'new'
    end
  end

  # borra un comentario
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Comentario borrado exitosamente."
    redirect_to widget_path(@comment.widget_id)
  end
end
