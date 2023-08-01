class User < ApplicationRecord
    validates :name, presence: true
    validates :email, presence: true, uniqueness: { case_sensitive: false }
    validates :password, length: { minimum: 6 }, if: :password_required?
    has_secure_password
  
    private
  
    def password_required?
      new_record? || password.present?
    end
  
    def self.authenticate_with_credentials(email, password)
        user = self.find_by('lower(email) = ?', email.strip.downcase)
        return nil unless user&.authenticate(password)
        user
    end      
end
  