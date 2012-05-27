FactoryGirl.define do
  factory :nii_type do |f|
    f.sequence(:name){|n| "nii_type_#{n}"}
  end
end
