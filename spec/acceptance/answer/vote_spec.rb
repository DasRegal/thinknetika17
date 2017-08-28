require_relative '../acceptance_helper'

feature 'voting answers', %q{
  As authenticated user 
  I want to able vote to answers
} do 
  given!(:user) { create(:user) }
  given!(:question) { create(:question) } 
  given!(:answer) { create(:answer, question: question) }


  scenario 'unauthenticate user try to vote ' do 
    visit question_path(question)

    within '.answers_container' do 
      expect(page).to_not have_content 'vote_up'
      expect(page).to_not have_content 'vote_down'
      expect(page).to_not have_content 'vote_delete'
    end
  end

  scenario 'user try to vote up for not his answer', js: true do 
    sign_in user
    visit question_path(question)
    
    within '.answers_container' do 
      old_votes = find('.total_votes').text.to_i  
      click_on 'vote_up'
      sleep(2)
      expect(find('.total_votes').text.to_i).to eq old_votes+1
    end
  end

  scenario 'user try to vote down for not his answer', js: true do 
    sign_in user
    visit question_path(question)
    
    within '.answers_container' do 
      old_votes = find('.total_votes').text.to_i  
      click_on 'vote_down'
      sleep(2)
      expect(find('.total_votes').text.to_i).to eq old_votes-1
    end
  end


  scenario 'user try to vote for his own answer' do 
    sign_in user
    answer.update(user: user)
    visit question_path(question)

    within '.answers_container' do 
      expect(page).to_not have_content 'vote_up'
      expect(page).to_not have_content 'vote_down'
      expect(page).to_not have_content 'vote_delete'
    end
  end

  describe 'user can revote' do 
    before do 
      sign_in user
    end
    scenario 'from up to down', js: true do 
      vote_up =  create(:vote_up, user: user, voteable: answer) 
      visit question_path(question)
      within '.answers_container' do 
        old_votes = find(".total_votes").text.to_i  
        click_on 'vote_down'
        sleep(2)
        expect(find('.total_votes').text.to_i).to eq old_votes-2
      end
    end

    scenario 'from down to up', js: true do 
      vote_down =  create(:vote_down, user: user, voteable: answer) 
      visit question_path(question)
      within '.answers_container' do 
        old_votes = find(".total_votes").text.to_i  
        click_on 'vote_up'
        sleep(2)
        expect(find('.total_votes').text.to_i).to eq old_votes+2
      end
    end
  end

  describe 'user already voted' do 
    before do 
      sign_in user
    end

    scenario 'voted up', js: true do 
      vote_up =  create(:vote_up, user: user, voteable: answer)       
      visit question_path(question)
      within '.answers_container' do 
        old_votes = find(".total_votes").text.to_i  
        click_on 'vote_up'
        sleep(2)
        expect(find('.total_votes').text.to_i).to eq old_votes
      end
      expect(page).to have_content 'You are already voted up'
    end

    scenario 'voted down', js: true do 
      vote_down =  create(:vote_down, user: user, voteable: answer)       
      visit question_path(question)
      within '.answers_container' do 
        old_votes = find(".total_votes").text.to_i  
        click_on 'vote_down'
        sleep(2)
        expect(find('.total_votes').text.to_i).to eq old_votes
      end
      expect(page).to have_content 'You are already voted down'
    end
  end
end