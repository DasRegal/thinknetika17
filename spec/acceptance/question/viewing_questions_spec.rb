require 'rails_helper'

feature 'viewing question', %q{
  All users can view list of questions
} do 
  given!(:questions) { create_list(:question, 10) }
  given(:user){ create(:user) }

  after do 
    questions.each do |q|
      expect(page).to have_content(q.title)
      expect(page).to have_content(q.body)  
    end
  end

  scenario 'Non-authenticate user tries to view list of questions' do 
    visit questions_path
  end

  scenario 'Authenticate user tries to view list of questions' do 
    sign_in(user)
    visit questions_path
  end
end