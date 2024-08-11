class Authentication < ApplicationRecord
  belongs_to :model, class_name: 'DatabaseSchema::Model', foreign_key: :database_schema_model_id, optional: true
  belongs_to :plan

  attr_accessor :name

  validates :name, presence: true, on: :create
  normalizes :name, with: -> name { name.to_s.titleize.delete(' ').camelize.singularize }
  validate :name_is_unique, on: :create

  def features
    mappings = {
      "invitations"=>"Invitations",
      "allow_sign_up"=>"Sign up",
      "online_indication"=>"Online indication",
      "two_factor_authentication"=>"Two factor authentication"
    }

    options.keys.map { |key| mappings[key] }.join(", ")
  end

  private

  def name_is_unique
    if plan.authentications.includes(:model).where(database_schema_models: { name: name }).exists?
      errors.add(:name, "is already taken")
    end
  end
end
