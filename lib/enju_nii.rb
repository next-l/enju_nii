require "enju_nii/engine"
require 'open-uri'

module EnjuNii
  class RecordNotFound < StandardError
  end

  class InvalidIsbn < StandardError
  end
end
