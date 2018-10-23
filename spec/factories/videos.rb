FactoryBot.define do
  factory :video do
    initialize_with { new(youtube_url: 'https://www.youtube.com/watch?v=51WdH_IFTfE') }
  end
end
