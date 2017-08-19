require_relative '../acceptance_helper'

feature 'Answerediting', %q{
  In orderto six mistake
  as an author of Answerediting
  i'd like to be able to edit my answer
} do 
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unathenticate user try to edit' do 
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario 'unauthor try to edit answer' do 
    sign_in user
    user2 =  create(:user) 
    answer.update(user: user2)

    visit question_path(question)    
    within '.answer' do 
      expect(page).to_not have_content 'Edit'
    end
  end

  describe 'Authenticate user' do 
    before do 
      sign_in user
      visit question_path(question)
    end

    scenario 'sees the link edit' do 
      expect(page).to have_link 'Edit'
    end

    scenario 'try to edit his answer with valid attributes', js: true do 
      within '.answer' do 
        click_on 'Edit'  
        fill_in 'answer[body]', with: 'edited answer'
        click_on 'Save'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
      expect(page).to have_content 'Your answer was succesfully updated'
    end

    scenario 'author try to update with invalid attributes', js: true do 
      
      within '.answer' do 
        click_on 'Edit'
        fill_in 'answer[body]', with: nil
        click_on 'Save'
        expect(page).to have_content answer.body
      end
      expect(page).to have_content 'Error while creating answer'            
      expect(page).to have_content 'Body can\'t be blank'
    end

    scenario 'edit barely created answer', js: true do 
      #Проверяем возможность редактирования только что созданного ответа
      fill_in 'Your answer', with: 'My new answer'
      click_on 'Add answer'
      #Ждем пока в ДОМ прилетит новый ответ, без этого не работает.
      sleep(3)

      #Пробуем его редактировать
      within all('.answer').last do 
        click_on 'Edit'
        fill_in 'answer[body]', with: 'new edited answer'
        click_on 'Save'
       
        expect(page).to have_content 'new edited answer'
        expect(page).to_not have_selector 'textarea'        
      end
      expect(page).to_not have_content 'My new answer'
      expect(page).to have_content 'Your answer was succesfully updated'
    end
  end
end