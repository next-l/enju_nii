class NiiType < ActiveRecord::Base
  attr_accessible :name, :display_name, :note
  include MasterModel
  default_scope :order => 'nii_types.position'
  has_many :manifestations
end
