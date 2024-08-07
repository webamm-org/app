# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :validatable, :invitable, :trackable, :recoverable, :rememberable

  has_many :plans, dependent: :destroy
end
