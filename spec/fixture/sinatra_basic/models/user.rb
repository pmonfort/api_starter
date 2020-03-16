# frozen_string_literal: true

class User < ActiveRecord::Base
  belongs_to :company
  validates :birthday, presence: true
  validates :company, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true
end
