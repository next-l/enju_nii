module EnjuNii
  module EnjuManifestation
    extend ActiveSupport::Concern

    included do
      belongs_to :nii_type
      has_one :ncid_record
      string :ncid do
        ncid_record.try(:body)
      end
    end
  end
end
