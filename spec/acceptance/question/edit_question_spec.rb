require_relative '../acceptance_helper'

feature 'question editing', %q{
  In orderto fix mistake
  as an author of question
  i'd like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unathenticate user try to edit' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario 'unauthor try to edit question' do
    sign_in user
    user2 =  create(:user)
    question.update(user: user2)

    visit question_path(question)
    expect(page).to_not have_content 'Edit'
  end

  describe 'Authenticate user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees the link edit' do
      expect(page).to have_link 'Edit'
    end

    scenario 'try to edit his question with valid attributes', js: true do
      click_on 'Edit'
      fill_in 'new body', with: 'edited question body'
      fill_in 'new title', with: 'edited question title'
      click_on 'Save'
      expect(page).to_not have_content question.body
      expect(page).to_not have_content question.title

      expect(page).to have_content 'edited question body'
      expect(page).to have_content 'edited question title'
      expect(page).to_not have_selector 'form#question[body]'
      expect(page).to have_content 'Your question was succesfully updated'
    end

    scenario 'author try to update with invalid attributes', js: true do

      click_on 'Edit'
      fill_in 'new body', with: nil
      fill_in 'new title', with: nil
      click_on 'Save'
      expect(page).to have_content question.body
      expect(page).to have_content 'Error while creating question'
      expect(page).to have_content 'Body can\'t be blank'
      expect(page).to have_content 'Title can\'t be blank'
    end
  end
end
