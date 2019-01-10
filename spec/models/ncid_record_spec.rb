require 'rails_helper'

RSpec.describe NcidRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
