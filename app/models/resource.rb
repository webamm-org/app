class Resource < ApplicationRecord
  belongs_to :model, class_name: "DatabaseSchemaModel", foreign_key: "database_schema_model_id"
  belongs_to :plan
end
