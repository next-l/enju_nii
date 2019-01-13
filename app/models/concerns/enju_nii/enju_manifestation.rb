module EnjuNii
  module EnjuManifestation
    extend ActiveSupport::Concern

    included do
      belongs_to :nii_type, optional: true
      has_one :ncid_record
      searchable do
        string :ncid do
          ncid_record.try(:body)
        end
      end
    end
  end
end
