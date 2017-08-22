require_relative '../acceptance_helper'

feature 'Add files to answer', %q{ 
  in order to illustrate my answer
  as an answer author
  i'd like to be able to attach files
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do 
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User add file when answer', js: true do 
    fill_in 'Your answer', with: 'answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Add answer'
    within '.answers_container' do 
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User can add multiply files when answering', js: true do 
    fill_in 'Your answer', with: 'answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'add file'
    within all('.nested-fields').last do 
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Add answer'
    sleep(3)
    within '.answers_container' do 
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
    expect(page).to have_content 'Your answer was successfully created'
    expect(page).to_not have_css '.nested-fields'
  end
end