# -*- encoding: utf-8 -*-
module EnjuNii
  module NiiSearch
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
    end

    class AlreadyImported < StandardError
    end
  end
end
