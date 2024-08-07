# frozen_string_literal: true

class Plan < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }

  has_many :db_models, dependent: :destroy, class_name: 'DatabaseSchema::Model'
end
