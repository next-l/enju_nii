class NiiType < ActiveRecord::Base
  include MasterModel
  has_many :manifestations
end
