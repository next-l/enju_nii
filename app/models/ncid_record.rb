class NcidRecord < ApplicationRecord
  belongs_to :manifestation
  validates :body, presence: true, uniqueness: true
end

# == Schema Information
#
# Table name: ncid_records
#
#  id               :bigint(8)        not null, primary key
#  body             :string           not null
#  manifestation_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
