require_relative '../acceptance_helper'

feature 'Comment for answer and question', %q{
  In order to commening answers and questions
  As an authenticate user
  I want to be able to commenting from question page
} do 

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'authenticate user' do 
    before do 
      sign_in user 
      visit question_path(question) 
    end
    context 'creates comment for question' do 
      scenario 'with valid attributes', js: true do 
        within '.question_comments' do 
          fill_in 'Your comment', with: 'My new comment'
          click_on 'Add comment'
          sleep(1)
          expect(page).to have_content 'My new comment'
        end
        expect(page).to have_content 'Your comment created'
      end

      scenario 'with invalid attributes', js: true do 
        within '.question_comments' do 
          click_on 'Add comment'
          sleep(1)
        end
        expect(page).to have_content 'Body can\'t be blank'
        expect(page).to have_content 'Error while creating comment'
      end
    end

    context 'creates comment for answer' do 
      before { visit question_path(question) }

      scenario 'with valid attributes', js: true do 
        within '.answers_container .answer_comments' do 
          fill_in 'Your comment', with: 'My new comment'
          click_on 'Add comment'
          sleep(1)
          expect(page).to have_content 'My new comment'
        end   
        expect(page).to have_content 'Your comment created'      
      end

      scenario 'with invalid attributes', js: true do 
        within '.answers_container .answer_comments' do 
          click_on 'Add comment'
          sleep(1)
        end  
        expect(page).to have_content 'Body can\'t be blank'
        expect(page).to have_content 'Error while creating comment'       
      end
    end
  end

  describe 'non-authenticate user' do 
    context 'answer' do 
      scenario 'try to create comment' do 
        visit question_path(question)
        
        within '.answers_container .answer_comments' do 
          expect(page).to_not have_content 'Your comment'
        end        
      end
    end

    context 'question' do 
      scenario 'try to create comment' do 
        visit question_path(question)

        within '.question_comments' do 
          expect(page).to_not have_content 'Your comment'
        end        
      end
    end
  end

  describe 'it appears in another user page' do 
    scenario 'question', js: true do 
      Capybara.using_session('user') do 
        sign_in user
        visit question_path(question)
      end

      Capybara.using_session('guest') do 
        visit question_path(question)
      end

      Capybara.using_session('user') do 
        within '.question_comments' do 
          fill_in 'Your comment', with: 'My new comment'
          click_on 'Add comment'
          sleep(1)
          expect(page).to have_content 'My new comment'
        end        
      end

      Capybara.using_session('guest') do 
        expect(page).to have_content 'My new comment'
      end
    end

    scenario 'answer', js: true do 
      Capybara.using_session('user') do 
        sign_in user
        visit question_path(question)
      end

      Capybara.using_session('guest') do 
        visit question_path(question)
      end

      Capybara.using_session('user') do 
        within '.answers_container .answer_comments' do 
          fill_in 'Your comment', with: 'My new comment'
          click_on 'Add comment'
          sleep(1)
          expect(page).to have_content 'My new comment'
        end          
      end

      Capybara.using_session('guest') do 
        expect(page).to have_content 'My new comment'
      end      
    end
  end
end