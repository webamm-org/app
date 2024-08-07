# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    name { FFaker::Lorem.sentence(4) }
    user
  end
end
