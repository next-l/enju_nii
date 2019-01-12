module EnjuNii
  module EnjuManifestation
    extend ActiveSupport::Concern

    included do
      belongs_to :nii_type
      has_one :ncid_record
    end
  end
end
