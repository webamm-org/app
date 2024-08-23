# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :validatable, :trackable, :recoverable, :rememberable, :registerable, :confirmable

  has_many :plans, dependent: :destroy
end
