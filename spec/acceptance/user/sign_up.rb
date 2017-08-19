require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to create questions and answers, 
  I want to able sign up
} do 
  given(:user) { create(:user) }

  scenario 'Non-authenticated user sign up' do 
    visit root_path
    click_on 'Sign up'
    fill_in 'Email', with: 'user_test@mail.ru'
    fill_in 'Password', with: '1234567'
    fill_in 'Password confirmation', with: '1234567'
    click_button 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Authenticated user tru to sign up' do 
    sign_in(user)
    visit root_path
    expect(page).to_not have_content('Sign up')

    visit new_user_registration_path
    expect(page).to have_content('You are already signed in.')
    expect(current_path).to eq root_path
  end

end