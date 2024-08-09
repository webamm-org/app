FactoryBot.define do
  factory :database_schema_association do
    connection_type { 1 }
    connection_options { "" }
    source_database_schema_model { nil }
    destination_database_schema_model { nil }
  end
end
