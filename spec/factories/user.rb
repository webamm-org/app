# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { 123_123_123 }
    password_confirmation { 123_123_123 }
    reset_password_token { FFaker::Lorem.sentence(4) }
    reset_password_sent_at { FFaker::Time.datetime }
    remember_created_at { FFaker::Time.datetime }
    sign_in_count { FFaker::Number.number }
    current_sign_in_at { FFaker::Time.datetime }
    last_sign_in_at { FFaker::Time.datetime }
    current_sign_in_ip { FFaker::Lorem.sentence(4) }
    last_sign_in_ip { FFaker::Lorem.sentence(4) }
    invitation_token { FFaker::Lorem.sentence(4) }
    invitation_created_at { FFaker::Time.datetime }
    invitation_sent_at { FFaker::Time.datetime }
    invitation_accepted_at { FFaker::Time.datetime }
    invitation_limit { FFaker::Number.number }
    invited_by_id { FFaker::Number.number }
    invited_by_type { FFaker::Lorem.sentence(4) }
  end
end
