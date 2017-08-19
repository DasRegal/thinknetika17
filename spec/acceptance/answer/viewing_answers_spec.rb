require_relative '../acceptance_helper'

feature 'viewing answers', %q{
  All users can view list of answers to question
} do 
  given!(:question) { create(:question_with_answers) }
  given(:user){ create(:user) }

  scenario 'Non-authenticate user tries to view list of questions' do 
    visit question_path(question)
  end

  scenario 'Authenticate user tries to view list of questions' do 
    sign_in(user)
    visit question_path(question)
  end
  
  after do 
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    question.answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end