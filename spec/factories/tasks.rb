FactoryBot.define do
  factory :task do
    sequence(:content) { |n| "Sample task content #{n}" }
    user { nil }
  end
end
