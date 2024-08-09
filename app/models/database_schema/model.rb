class DatabaseSchema::Model < ApplicationRecord
  self.table_name = 'database_schema_models'

  belongs_to :plan

  has_many :columns, class_name: 'DatabaseSchema::Column', foreign_key: 'database_schema_model_id', dependent: :destroy
  has_many :indices, class_name: 'DatabaseSchema::Index', foreign_key: 'database_schema_model_id', dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :plan_id }

  normalizes :name, with: -> name { name.to_s.titleize.delete(' ').camelize }
end
