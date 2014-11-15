# -*- encoding: utf-8 -*-
require 'spec_helper'

describe CiniiBook do
  fixtures :all

  Manifestation.enju_nii_cinii_books

  it "should search bibliographic records", vcr: true do
    CiniiBook.search("library system")[:total_entries].should eq 3397
  end

  it "should search with ncid", vcr: true do
    result = CiniiBook.search("BA85746967")
    result.should be_truthy
    result[:items].should be_truthy
    result[:items].first.ncid.should eq "BA85746967"
  end

  it "should import a bibliographic record", vcr: true do
    book = CiniiBook.import_ncid("BA85746967")
    book.should be_truthy
    book.original_title.should eq "固体高分子形燃料電池要素材料・水素貯蔵材料の知的設計"
    book.title_transcription.should include("コタイ コウブンシケイ ネンリョウ デンチ ヨウソ ザイリョウ スイソ チョゾウ ザイリョウ ノ チテキ セッケイ")
    book.title_alternative.should include("Computational materials design, case study I")
    book.statement_of_responsibility.should eq "笠井秀明, 津田宗幸著 = Intelligent/directed materials design for polymer electrolyte fuel cells and hydrogen storage applications / Hideaki Kasai, Muneyuki Tsuda"
    book.publishers.first.full_name.should eq "大阪大学出版会"
    book.language.iso_639_2.should eq "jpn"
    book.date_of_publication.year.should eq 2008
    book.identifier_contents("isbn").first.should eq "9784872592542"
    book.identifier_contents("ncid").first.should eq "BA85746967"
    book.creators.size.should eq 2
    book.creators[0].full_name.should eq "笠井, 秀明"
    book.creators[1].full_name.should eq "津田, 宗幸"
  end

  it "should import a bibliographic record with dual languages", vcr: true do
    book = CiniiBook.import_ncid("BB13942810")
    book.should be_truthy
    book.original_title.should eq "赤毛のアン = Anne of Green Gables"
    book.language.iso_639_2.should eq "jpn"
  end
end
