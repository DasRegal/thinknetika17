require_relative '../acceptance_helper'

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

    expect(page).to have_content 'Answer was successfully created'
    within '.answers_container' do
      expect(page).to have_content 'My test answer'
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'authenticated user tries to creates invalid answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Add answer'

    expect(page).to have_content 'Answer could not be created'
    expect(page).to have_content 'Body can\'t be blank'
    expect(current_path).to eq question_path(question)
  end

  scenario 'non-authenticated user try to creates answer', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Your answer'
  end

  scenario 'answer appears on another user page', js: true do
    Capybara.using_session('user') do
      sign_in user
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      fill_in 'Your answer', with: 'My test answer'
      click_on 'Add answer'
      expect(page).to have_content 'Answer was successfully created'
      within '.answers_container' do
        expect(page).to have_content 'My test answer'
      end
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'My test answer'
    end
  end
end
