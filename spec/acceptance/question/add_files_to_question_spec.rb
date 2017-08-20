require_relative '../acceptance_helper'

feature 'Add files to question', %q{ 
  in order to illustrate my question
  as an question author
  i'd like to beable to attach files
} do 

  given(:user) { create(:user) }
  background do 
    sign_in(user)
    visit new_question_path
  end

  scenario 'User add file when asks question' do 
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_content 'spec_helper.rb'
  end
end