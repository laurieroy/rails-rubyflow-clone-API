FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "Sample article #{n}"} 
    content { "Sample Content" }
    sequence(:slug) { |n| "sample-article-#{n}"}
  end
end
