class NcidRecord < ApplicationRecord
  belongs_to :manifestation
end

# == Schema Information
#
# Table name: ncid_records
#
#  id               :bigint(8)        not null, primary key
#  body             :string           not null
#  manifestation_id :bigint(8)        not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
