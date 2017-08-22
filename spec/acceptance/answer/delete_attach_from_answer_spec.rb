require_relative '../acceptance_helper'

feature 'delete files from answer', %q{ 
  as an answer author
  i'd like to be able to delete attach files
} do 

  given(:user) { create(:user) }
  given(:answer_attach) { create(:answer_attach) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }
  given(:user2) { create(:user) }

  background do 
    @user = user
    sign_in(@user)
    @question = question
    @answer = answer
    @answer.update(question: @question)
    @answer_attach = answer_attach
    @answer_attach.update(attachmentable_id: @answer.id, attachmentable_type: "Answer")
    @answer.update(user: @user)
  end

  scenario 'author can delete attach', js: true do 
    visit question_path(@question)
    click_on 'delete attach'
    expect(page).to_not have_content 'spec_helper.rb'
    sleep(2)
    expect(page).to have_content 'Attachment destroied'
  end

  scenario 'non author can\'t delete', js: true do 
    @answer.update(user: user2)
    visit question_path(@question)
    expect(page).to_not have_link 'delete attach'
  end
end