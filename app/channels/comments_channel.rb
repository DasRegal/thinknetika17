class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comments/#{params['commentable']}_#{params['id']}"
  end
end