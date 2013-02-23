# -*- encoding: utf-8 -*-
require 'spec_helper'

describe CiniiBook do
  fixtures :all

  Manifestation.enju_nii_cinii_books

  VCR.use_cassette "enju_nii/search", :record => :new_episodes do

    it "should search bibliographic records" do
      CiniiBook.search("library system")[:total_entries].should eq 3132
    end

    it "should import a bibliographic record" do
      CiniiBook.import_ncid("BA85746967").should be_nil
    end
  end
end
