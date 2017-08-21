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
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User can add multiply files when asks question', js: true do 
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'add file'
    within all('.nested-fields').last do 
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Create'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/3/rails_helper.rb'
    expect(page).to have_content 'Your question successfully created.'
  end
end