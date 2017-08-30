require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community 
  As an authenticated user
  I want to able ask question
} do 
  given(:user) { create(:user) }

  scenario 'Authinticated user creates question' do 

    sign_in(user)   

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Test body'

  end

  scenario 'Authinticated user try to create invalid question' do 

    sign_in(user)   

    visit questions_path
    click_on 'Ask question'
    click_on 'Create'

    expect(page).to have_content 'Error while creating question'
    expect(page).to have_content 'Title can\'t be blank'
    expect(page).to have_content 'Body can\'t be blank'
  end


  scenario 'Non-authenticated user try to create question' do 
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'    
  end


  scenario 'question appears on anohen user\'s page', js: true do 
    Capybara.using_session('user') do 
      sign_in(user)
      visit questions_path
    end

    Capybara.using_session('guest') do 
      visit questions_path
    end

    Capybara.using_session('user') do 
      click_on 'Ask question'
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test body'
      click_on 'Create'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Test body'
    end

    Capybara.using_session('guest') do 
      expect(page).to have_content 'Test question'
    end


  end
end