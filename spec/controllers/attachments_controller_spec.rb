require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:question) { create(:question) }
  let!(:user) { create(:user) }
  let!(:answer) { create(:answer) }

  sign_in_user
  describe 'DELETE #destroy' do
    context 'question' do 
      before(:each) do 
        @question = question
        @attach = create(:question_attach)
        @attach.update(attachmentable_id: @question.id, attachmentable_type: "Question")
      end
        

      it 'delete attach if user = author' do 
        @question.update(user: @user)
        expect { delete :destroy, params: { id: @attach }, format: :js }.to change(Attachment, :count).by(-1)
      end

      it 'dont delete attach if user <> author' do 
        expect { delete :destroy, params: { id: @attach }, format: :js }.to_not change(Attachment, :count)
      end
    end

    context 'answer' do 
      before(:each) do 
        @answer = answer
        @attach = create(:answer_attach)
        @attach.update(attachmentable_id: @answer.id, attachmentable_type: "Answer")
      end
        
      it 'delete attach if user = author' do 
        @answer.update(user: @user)
        expect { delete :destroy, params: { id: @attach }, format: :js }.to change(Attachment, :count).by(-1)
      end

      it 'dont delete attach if user <> author' do 
        expect { delete :destroy, params: { id: @attach }, format: :js }.to_not change(Attachment, :count)
      end
    end
  end
end
