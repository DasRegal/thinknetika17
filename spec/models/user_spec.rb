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

  describe '.create_without_email' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456') }
    it 'returns user' do
      expect(User.create_without_email(auth)).to be_a(User)
    end

    it 'creates new user' do
      expect{ User.create_without_email(auth) }.to change(User, :count).by(1)
    end

    it 'creates new authorization' do
      user = User.create_without_email(auth)
      expect(user.authorizations).to_not be_empty
    end

    it 'creates new authorization with uid and provider' do
      authorization = User.create_without_email(auth).authorizations.first
      expect(authorization.provider).to eq auth.provider
      expect(authorization.uid).to eq auth.uid
    end

    it 'fill email with some value' do
      user = User.create_without_email(auth)
      expect(user.email).to_not be_empty
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user doest exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        it 'return new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end
        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end
        it 'creates authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
