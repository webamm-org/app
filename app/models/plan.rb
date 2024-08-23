# frozen_string_literal: true

class Plan < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }

  has_many :db_models, dependent: :destroy, class_name: 'DatabaseSchema::Model'
  has_many :authentications
  has_many :prompts_histories, dependent: :destroy
  has_many :resources

  def to_webamm
    ::Plans::WebammExporter.call(self)
  end
end
