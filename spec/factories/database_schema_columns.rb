FactoryBot.define do
  factory :database_schema_column do
    database_schema_model { nil }
    name { "MyString" }
    field_type { 1 }
    can_be_null { false }
    default_value { "MyString" }
    options { "" }
  end
end
