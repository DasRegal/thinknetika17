require_relative '../acceptance_helper'

feature 'settig best answer', %q{
  In order to set best answer for question 
  As an authenticated user and question author 
  I want to able set best anser
} do 
  given!(:user) { create(:user) }
  given!(:question_with_answers) { create(:question_with_answers) }

  describe 'Authenticated user' do 
    scenario 'question author mark as best', js: true do 
      sign_in user 
      question_with_answers.update(user: user)

      visit question_path(question_with_answers)

      within all('.answer').last do 
        click_on 'Mark as best'
        sleep(3)
        save_and_open_page
      end
      expect(page).to have_css '.best_answer'
    end

    scenario 'non question author mark as best' do 
      sign_in user 
      visit question_path(question_with_answers)

      expect(page).to_not have_link 'Mark as best'     
    end
  end

  describe 'unauthenticate user' do 
    scenario 'dont see Mark as best link' do 
      visit question_path(question_with_answers)

      expect(page).to_not have_link 'Mark as best'
    end
  end
end