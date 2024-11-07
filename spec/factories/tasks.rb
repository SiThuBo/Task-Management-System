FactoryBot.define do
  factory :task do
    title { "Sample Task" }
    description { "Sample Description" }
    status { :to_do }
    priority { "High" }
    due_date { "2024-12-31" }
    user
  end
end
