class User < ActiveRecord::Base
  has_secure_password
  validates :name,  presence: true, length: { maximum: 50 }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

end
