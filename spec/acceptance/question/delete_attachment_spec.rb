require_relative '../acceptance_helper'

feature 'delete files from question', %q{ 
  as an question author
  i'd like to be able to delete attach files
} do 

  given(:user) { create(:user) }
  given(:question_attach) { create(:question_attach) }
  given(:question) { create(:question) }
  given(:user2) { create(:user) }

  background do 
    @user = user
    sign_in(@user)
    @question = question
    @question_attach = question_attach
    @question_attach.update(attachmentable_id: @question.id, attachmentable_type: "Question")
    @question.update(user: @user)
  end

  scenario 'author can delete attach', js: true do 
    visit question_path(@question)
    click_on 'delete attach'
    expect(page).to_not have_content 'spec_helper.rb'
    sleep(2)
    expect(page).to have_content 'Attachment destroied'
  end

  scenario 'non author can\'t delete', js: true do 
    @question.update(user: user2)
    visit question_path(@question)
    expect(page).to_not have_link 'delete attach'
  end
end