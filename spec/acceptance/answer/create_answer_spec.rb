require 'rails_helper'

feature 'Answer for question', %q{
  In order to answering
  As an authenticate user
  Users can answer for question from question page
} do 
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'authenticated user creates answer' do 
    sign_in(user)

    visit question_path(question)
    fill_in 'Your answer', with: 'My test answer'
    click_on 'Add answer'

    expect(page).to have_content 'Your answer was successfully created'
    expect(page).to have_content 'My test answer'
    expect(current_path).to eq question_path(question)
  end

  scenario 'non-authenticated user try to creates answer' do 
    visit question_path(question)
    fill_in 'Your answer', with: 'My test answer'
    click_on 'Add answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end