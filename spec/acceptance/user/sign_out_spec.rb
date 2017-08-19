require_relative '../acceptance_helper'

feature 'User sign out', %q{
  After sign in 
  I want to be able to sign out
} do
  given (:user) { create(:user) }

  before { visit root_path }
  scenario 'Authenticated user try to sign out' do 
    sign_in(user)

    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-authenticated user try to sign in' do 
    expect(page).to_not have_content 'Sign out'
  end
end