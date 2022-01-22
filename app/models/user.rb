class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Relations
  has_many :contacts
  has_many :contact_files
end
