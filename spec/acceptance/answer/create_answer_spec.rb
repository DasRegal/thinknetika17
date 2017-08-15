require 'rails_helper'

feature 'Answer for question', %q{
  In order to answering
  As an authenticate user
  Users can answer for question from question page
} do 
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'authenticated user creates valid answer', js: true do 
    sign_in(user)

    visit question_path(question)
    fill_in 'Your answer', with: 'My test answer'
    click_on 'Add answer'

    expect(page).to have_content 'Your answer was successfully created'
    within '.answers_container' do 
      expect(page).to have_content 'My test answer'
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'authenticated user tries to creates invalid answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Add answer'

    expect(page).to have_content 'Error while creating answer'
    expect(page).to have_content 'Body can\'t be blank'
    expect(current_path).to eq question_path(question)    
  end

  scenario 'non-authenticated user try to creates answer', js: true do 
    visit question_path(question)

    expect(page).to_not have_content 'Your answer'
  end
end