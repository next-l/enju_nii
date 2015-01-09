# -*- encoding: utf-8 -*-
require "enju_nii/engine"
require 'open-uri'
require 'enju_nii/cinii_book'

module EnjuNii
  module ActsAsMethods
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def enju_nii_cinii_books
        include EnjuNii::CiNiiBook
        belongs_to :nii_type
      end

      def import_isbn(isbn)
        manifestation = Manifestation.import_from_cinii_books(isbn: isbn)
        manifestation
      end
    end
  end

  class RecordNotFound < StandardError
  end

  class InvalidIsbn < StandardError
  end
end

ActiveRecord::Base.send :include, EnjuNii::ActsAsMethods
