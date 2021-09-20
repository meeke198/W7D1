class User < ApplicationRecord
    after_initialize :ensure_session_token

    validates :session_token, presence: true, uniqueness: true
    validates :user_name, :password_digest, presence: true

    def self.find_by_credentials(user_name, password)
        user = User.find_by(user_name: user_name)

        if user && user.is_password?(password)
            user
        else    
            nil
        end
    end

    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64
        self.save!
        self.session_token
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password
    end

    def is_password?(password)
        password_object = BCrypt::Password.new(self.password_digest)
        password_object.is_password?(password)
    end

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end

end
