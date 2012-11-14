# -*- encoding: utf-8 -*-
require 'spec_helper'

describe CiniiBook do
  fixtures :all

  Manifestation.enju_nii_cinii_book

  use_vcr_cassette "enju_nii/cinii_books", :record => :new_episodes

  it "should search bibliographic records" do
    CiniiBook.search("library system")[:total_entries].should eq 3088
  end

  it "should import a bibliographic record" do
    CiniiBook.import_ncid("BA85746967").should be_true
  end
end
