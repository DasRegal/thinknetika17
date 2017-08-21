require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:question) { create(:question) }
  let!(:user) { create(:user) }

  before(:each) do 
    @question = question
    @attach = create(:question_attach)
    @attach.update(attachmentable_id: @question.id, attachmentable_type: "Question")
  end
    
  sign_in_user
  it 'delete attach if user = author' do 
    @question.update(user: @user)
    expect { delete :destroy, params: { id: @attach }, format: :js }.to change(Attachment, :count).by(-1)
  end

  it 'dont delete attach if user <> author' do 
    @question.user = user
    expect { delete :destroy, params: { id: @attach }, format: :js }.to_not change(Attachment, :count)
  end

end
