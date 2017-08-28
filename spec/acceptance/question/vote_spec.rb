require_relative '../acceptance_helper'

feature 'voting question', %q{
  As authenticated user 
  I want to able vote to question
} do 
  given!(:user) { create(:user) }
  given!(:question) { create(:question) } 


  scenario 'unauthenticate user try to vote ' do 
    visit question_path(question)

    expect(page).to_not have_content 'vote_up'
    expect(page).to_not have_content 'vote_down'
    expect(page).to_not have_content 'vote_delete'
  end

  scenario 'user try to vote up for not his question', js: true do 
    sign_in user
    visit question_path(question)
    
    old_votes = find('.total_votes').text.to_i  
    click_on 'vote_up'
    sleep(2)
    expect(find('.total_votes').text.to_i).to eq old_votes+1
  end

  scenario 'user try to vote down for not his question', js: true do 
    sign_in user
    visit question_path(question)
    old_votes = find('.total_votes').text.to_i  
    click_on 'vote_down'
    sleep(2)
    expect(find('.total_votes').text.to_i).to eq old_votes-1
  end


  scenario 'user try to vote for his own question' do 
    sign_in user
    question.update(user: user)
    visit question_path(question)

    expect(page).to_not have_content 'vote_up'
    expect(page).to_not have_content 'vote_down'
    expect(page).to_not have_content 'vote_delete'
  end

  describe 'user can revote' do 
    before do 
      sign_in user
    end
    scenario 'from up to down', js: true do 
      vote_up =  create(:vote_up, user: user, voteable: question) 
      visit question_path(question)
      old_votes = find(".total_votes").text.to_i  
      click_on 'vote_down'
      sleep(2)
      expect(find('.total_votes').text.to_i).to eq old_votes-2
    end

    scenario 'from down to up', js: true do 
      vote_down =  create(:vote_down, user: user, voteable: question) 
      visit question_path(question)
      old_votes = find(".total_votes").text.to_i  
      click_on 'vote_up'
      sleep(2)
      expect(find('.total_votes').text.to_i).to eq old_votes+2
    end
  end

  describe 'user already voted' do 
    before do 
      sign_in user
    end

    scenario 'voted up', js: true do 
      vote_up =  create(:vote_up, user: user, voteable: question) 
      visit question_path(question)
      old_votes = find(".total_votes").text.to_i  
      click_on 'vote_up'
      sleep(2)

      expect(find('.total_votes').text.to_i).to eq old_votes
      expect(page).to have_content 'You are already voted up'
    end

    scenario 'voted down', js: true do 
      vote_down =  create(:vote_down, user: user, voteable: question)       
      visit question_path(question)
      old_votes = find(".total_votes").text.to_i  
      click_on 'vote_down'
      sleep(2)
      expect(find('.total_votes').text.to_i).to eq old_votes
      expect(page).to have_content 'You are already voted down'
    end
  end
end