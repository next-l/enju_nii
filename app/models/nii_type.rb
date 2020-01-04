class NiiType < ActiveRecord::Base
  include MasterModel
  has_many :manifestations
end

# == Schema Information
#
# Table name: nii_types
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
