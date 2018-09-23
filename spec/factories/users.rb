# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password }
    provider { 'email' }
    nickname { Faker::Internet.username }

    trait :confirmed do
      after(:create, &:confirm)
    end

    factory :user_with_admin do
      after(:create) { |user| user.add_role('admin') }
    end
  end
end
