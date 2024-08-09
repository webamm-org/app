class DatabaseSchema::Column < ApplicationRecord
  self.table_name = 'database_schema_columns'

  belongs_to :model, class_name: 'DatabaseSchema::Model', foreign_key: 'database_schema_model_id'
  has_and_belongs_to_many :indices, class_name: 'DatabaseSchema::Index', dependent: :destroy, foreign_key: 'database_schema_column_id', association_foreign_key: 'database_schema_index_id'

  validates :name, presence: true, uniqueness: { scope: :database_schema_model_id }

  normalizes :name, with: -> name { name.to_s.underscore }

  enum field_type: { string: 0, integer: 1, boolean: 2, text: 3, float: 4, datetime: 5, time: 6, date: 7, enum_column: 8 }
end
