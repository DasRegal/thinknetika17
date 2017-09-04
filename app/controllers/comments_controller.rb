class CommentsController < ApplicationController
  before_action :set_commentable
  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.new(commentable_params)
    @comment.user = current_user
    if @comment.save
      flash.now[:notice] = 'Your comment created'
    else
      flash.now[:alert] = 'Error while creating comment'
    end
  end

  private

  def commentable_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    @commentable = commentable_name.classify.constantize.find(params[commentable_id])
  end

  def commentable_name
    params[:commentable]
  end

  def commentable_id
    (commentable_name.classify.downcase + '_id').to_sym
  end

  def publish_comment
    return if @comment.errors.any?
    model = @comment.commentable.class.name.downcase
    id = @comment.commentable.id

    ActionCable.server.broadcast(
      "comments/#{model}_#{id}",
       {comment: { id: @comment.id,
                  body: @comment.body,
                  commentable_id: @comment.commentable_id,
                  commentable_type: @comment.commentable_type,
                  user_id: @comment.user_id } }.to_json
      )        
  end
end
