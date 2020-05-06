require 'rails_helper'

RSpec.describe NcidRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: ncid_records
#
#  id               :bigint           not null, primary key
#  manifestation_id :bigint           not null
#  body             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
