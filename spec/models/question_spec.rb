require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  context 'setting answer to be best' do 
    before do 
      @question = create :question_with_answers
    end

    it 'have only 1 best answer' do 
      @question.answers.each do |a|
        @question.set_best_answer(a)
      end

      expect(@question.answers.bests.count).to eq 1
    end

    it 'set best answer' do 
      answer = @question.answers.first
      @question.set_best_answer(answer)
      expect(answer.best_answer?).to eq true
    end

    it 'set best only if answer is child of question' do 
      answer = create(:answer)
      @question.set_best_answer(answer)
      expect(@question.answers.bests.count).to eq 0
      expect(answer.best_answer?).to eq false
    end

    it 'dont change best answer if not child' do 
      answer = create(:answer)
      @question.set_best_answer(@question.answers.first)
      old_best_answer = @question.answers.best
      @question.set_best_answer(answer)
      expect(@question.answers.best).to eq old_best_answer
    end
  end
end
