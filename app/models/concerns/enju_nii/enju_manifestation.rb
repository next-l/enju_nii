module EnjuNii
  module EnjuManifestation
    extend ActiveSupport::Concern

    included do
      has_one :ncid_record
    end
  end
end
