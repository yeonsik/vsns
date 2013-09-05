class CommentsController < ApplicationController
  
  def create
    @commentable = comment_params[:commentable_type].classify.constantize.send('find',comment_params[:commentable_id])
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    flash[:now] = "A comment was successfully save."
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
        format.js
      else
        format.html { render action: 'new' }
        format.json
      end
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    @commentable = comment.commentable_type.classify.constantize.send('find', comment.commentable_id)
    @comment = @commentable.comments.find(params[:id])
    authorize_action_for(@comment) 
    @comment.destroy
    flash[:alert] = 'A comment was successfully deleted.'
    respond_to do |format|
      format.html { redirect_to items_url, alert: 'Comment was successfully deleted.' }
      format.json { head :ok }
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :commentable_id, :commentable_type)
  end
end
