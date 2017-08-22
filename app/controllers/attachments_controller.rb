class AttachmentsController < ApplicationController
  def destroy
    if current_user.author_of?(attachment.attachmentable)
      attachment.destroy
      flash.now[:notice] = 'Attachment destroied'
    else
      flash.now[:alert] = 'You dont have priveleges'
    end
  end

  private 

  def attachment
    @attachment ||=Attachment.find(params[:id])
  end
end
