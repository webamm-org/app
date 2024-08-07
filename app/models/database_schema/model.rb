class DatabaseSchema::Model < ApplicationRecord
  self.table_name = 'database_schema_models'

  belongs_to :plan

  validates :name, presence: true, uniqueness: { scope: :plan_id }

  normalizes :name, with: -> name { name.to_s.titleize.delete(' ').camelize }
end
