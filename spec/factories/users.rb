# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password }
    name { Faker::Twitter.screen_name }

    trait :confirmed do
      after(:create, &:confirm)
    end

    factory :user_with_admin do
      after(:create, &:confirm)
      after(:create) { |user| user.add_role('admin') }
    end
  end
end
