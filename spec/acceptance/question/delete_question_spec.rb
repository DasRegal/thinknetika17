require_relative '../acceptance_helper'

feature 'delete question', %q{
  Inorder to be able to delete question
  As authenticated user
  I want to be able to delete my own question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'authenticated user tries to delete his own question' do
    sign_in(question.user)
    visit question_path(question)
    click_on 'delete question'
    expect(page).to have_content('Question was successfully destroyed')

    visit questions_path
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'authenticated user tries to delete not his question' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_content('delete question')
  end

  scenario 'non-authenticated user tries to delete question' do
    visit question_path(question)
    expect(page).to_not have_content('delete question')
  end
end
