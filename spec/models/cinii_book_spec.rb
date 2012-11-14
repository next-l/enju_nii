# -*- encoding: utf-8 -*-
require 'spec_helper'

describe CiniiBook do
  fixtures :all

  Manifestation.enju_nii_cinii_book

  use_vcr_cassette "enju_nii/cinii_books", :record => :new_episodes

  it "should import a bibliographic record" do
    CiniiBook.search("library system")[:total_entries].should eq 3088
  end
end
