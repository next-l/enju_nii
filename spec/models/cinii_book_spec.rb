# -*- encoding: utf-8 -*-
require 'spec_helper'

describe CiniiBook do
  fixtures :all

  Manifestation.enju_nii_cinii_books

  it "should search bibliographic records", :vcr => true do
    CiniiBook.search("library system")[:total_entries].should eq 3141
  end

  it "should import a bibliographic record", :vcr => true do
    CiniiBook.import_ncid("BA85746967").should be_nil
  end
end
