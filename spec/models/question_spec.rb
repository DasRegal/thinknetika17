require 'rails_helper'

RSpec.describe Question, type: :model do
  let!(:question) { create(:question) }
  let!(:user) { create(:user) }
  let!(:vote_up) { create(:vote, :up, user: user, voteable: question) }
  let(:question2) { create(:question) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  it_behaves_like 'voteable'
end
