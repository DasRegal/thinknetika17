require 'rails_helper'

RSpec.describe User do 
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  context 'author_of methods work correct' do 
    before do 
      @user = create :user
      @question = create :question
    end

    it 'returt true if user is author_of object' do 
      @question.user = @user
      expect(@user).to be_author_of(@question)
    end

    it 'returt false if user is not author_of object' do 
      expect(@user).to_not be_author_of(@question)
    end
  end
end