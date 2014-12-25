class NiiType < ActiveRecord::Base
  include MasterModel
  default_scope { order('nii_types.position') }
  has_many :manifestations
end

# == Schema Information
#
# Table name: nii_types
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime
#  updated_at   :datetime
#
