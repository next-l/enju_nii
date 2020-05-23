FactoryBot.define do
  factory :identifier do
    sequence(:body){|n| "identifier_body_#{n}"}
    identifier_type_id{FactoryBot.create(:identifier_type).id}
    association(:manifestation)
  end
end
