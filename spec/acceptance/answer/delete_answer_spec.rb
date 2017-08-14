require 'rails_helper'

feature 'delete answer', %q{
  In order to be able to delete answer
  As authenticated user
  I want to be able to delete my own answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers) }

  scenario 'authenticated user tries to delete his own answer' do 
    sign_in(user)
    question.answers.update_all(user_id: user.id)
    old_answer_body = question.answers.first.body
    
    visit question_path(question)
    first('.delete_answer').click_link 'delete answer'
    expect(page).to_not have_content old_answer_body
    expect(page).to have_content('Your answer was succesfully deleted')
    expect(current_path).to eq question_path(question)
  end

  scenario 'authenticated user tries to delete not his question' do 
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_content('delete answer')
  end
  
  scenario 'non-authenticated user tries to delete question' do 
    visit question_path(question)
    expect(page).to_not have_content('delete answer')
  end
end