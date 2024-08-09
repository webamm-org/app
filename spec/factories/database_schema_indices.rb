FactoryBot.define do
  factory :database_schema_index do
    database_schema_model { nil }
    is_unique { false }
  end
end
