require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it "is valid with valid attributes" do
      user = User.new(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).to be_valid
    end

    it 'must be created with password and password_confirmation fields that match' do
      user = User.new(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'different_password'
      )
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it 'requires password and password_confirmation fields when creating the model' do
      user = User.new(email: 'test@example.com', name: 'John Doe')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'requires email, name, and last name' do
      user = User.new
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'validates uniqueness of email (case-insensitive)' do
      User.create(name: 'John Doe', email: 'test@example.com', password: 'password', password_confirmation: 'password')
      user = User.new(name: 'Jane Smith', email: 'TEST@example.com', password: 'password', password_confirmation: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end
  end

  describe 'Password minimum length' do
    it 'requires a minimum password length of 6 characters' do
      user = User.new(
        name: 'John Doe',
        email: 'test@example.com',
        password: '12345', # Password length less than 6 characters
        password_confirmation: '12345'
      )
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end

    it 'allows a password with a minimum length of 6 characters' do
      user = User.new(
        name: 'John Doe',
        email: 'test@example.com',
        password: '123456', # Password length equal to 6 characters
        password_confirmation: '123456'
      )
      expect(user).to be_valid
    end
  end

  describe '.authenticate_with_credentials' do
    before do
        @user = User.create(
          email: 'test@example.com',
          name: 'John Doe',
          password: 'password',
          password_confirmation: 'password'
        )
    end
      

    it 'returns the user when authenticated with correct credentials' do
      authenticated_user = User.authenticate_with_credentials('test@example.com', 'password')
      expect(authenticated_user).to eq(@user)
    end

    it 'returns nil when authenticated with incorrect password' do
      authenticated_user = User.authenticate_with_credentials('test@example.com', 'wrong_password')
      expect(authenticated_user).to be_nil
    end

    it 'returns nil when user does not exist' do
      authenticated_user = User.authenticate_with_credentials('nonexistent@example.com', 'password')
      expect(authenticated_user).to be_nil
    end

    it 'ignores leading/trailing whitespaces in email' do
      authenticated_user = User.authenticate_with_credentials('  test@example.com  ', 'password')
      expect(authenticated_user).to eq(@user)
    end

    it 'ignores case sensitivity in email' do
      authenticated_user = User.authenticate_with_credentials('TEST@example.com', 'password')
      expect(authenticated_user).to eq(@user)
    end
  end
end