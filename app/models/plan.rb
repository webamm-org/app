# frozen_string_literal: true

class Plan < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }

  has_many :db_models, dependent: :destroy, class_name: 'DatabaseSchema::Model'

  def estimated_savings
    minutes_of_development = 0

    db_models.find_each do |db_model|
      minutes_of_development += 5
      minutes_of_development += db_model.columns.count * 2
      minutes_of_development += db_model.indices.count * 2
      minutes_of_development += db_model.associations.count * 2
    end

    minutes_of_development += minutes_of_development * 0.2 # 20% for distractions

    hours = (minutes_of_development / 60.0).floor
    minutes = (minutes_of_development % 60).to_i
    
    summary = if hours > 0 && minutes > 0
      "#{hours} hours and #{minutes} minutes"
    elsif hours > 0
      "#{hours} hours"
    else
      "#{minutes} minutes"
    end

    return summary if usd_rate.zero?

    full_hours = (minutes_of_development / 60.0).ceil
    cost = full_hours * usd_rate

    "#{summary} (~#{cost} USD)"
  end
end
