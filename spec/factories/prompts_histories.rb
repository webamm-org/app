FactoryBot.define do
  factory :prompts_history do
    plan { nil }
    invalid { false }
    prompt { "MyText" }
    llm_waml { "MyText" }
  end
end
