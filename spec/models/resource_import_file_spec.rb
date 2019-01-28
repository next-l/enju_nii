require 'rails_helper'
  
describe ResourceImportFile do
  fixtures :all
  
  describe "when its mode is 'create'" do
    describe "when it is written in utf-8" do
      before(:each) do
        @file = ResourceImportFile.create(
          resource_import: File.new("#{Rails.root}/../../examples/resource_import_file_sample1.tsv"),
          default_shelf_id: 3,
          user: users(:admin)
        )
      end

      it "should be imported", vcr: true do
        old_manifestations_count = Manifestation.count
        old_items_count = Item.count
        old_agents_count = Agent.count
        old_import_results_count = ResourceImportResult.count
        @file.import_start.should eq({manifestation_imported: 10, item_imported: 10, manifestation_found: 6, item_found: 3, failed: 7})
        manifestation = Item.find_by(item_identifier: '11111').manifestation
        manifestation.publishers.order(:created_at).first.full_name.should eq 'test4'
        manifestation.publishers.order(:created_at).first.full_name_transcription.should eq 'てすと4'
        manifestation.publishers.order(:created_at).second.full_name_transcription.should eq 'てすと5'
        manifestation.produces.order(:created_at).first.produce_type.name.should eq 'publisher'
        manifestation.creates.order(:created_at).first.create_type.name.should eq 'author'
        manifestation.issn_records.pluck(:body).should eq ['03875806']
        Manifestation.count.should eq old_manifestations_count + 9
        Item.count.should eq old_items_count + 10
        Agent.count.should eq old_agents_count + 6
        @file.resource_import_results.order(:created_at).first.body.split("\t").first.should eq 'manifestation_identifier'
        ResourceImportResult.count.should eq old_import_results_count + 23

        manifestation_101 = Manifestation.find_by(manifestation_identifier: '101')
        manifestation_101.series_statements.count.should eq 1
        manifestation_101.series_statements.first.original_title.should eq '主シリーズ'
        manifestation_101.series_statements.first.title_transcription.should eq 'しゅしりーず'
        manifestation_101.series_statements.first.title_subseries.should eq '副シリーズ'
        manifestation_101.series_statements.first.title_subseries_transcription.should eq 'ふくしりーず'
        manifestation_101.items.order(:created_at).last.call_number.should eq '007|A'
        manifestation_101.serial.should be_falsy

        item_10101 = Item.find_by(item_identifier: '10101')
        item_10101.manifestation.creators.size.should eq 2
        item_10101.manifestation.creates.order(:created_at).first.create_type.name.should eq 'author'
        item_10101.manifestation.creates.order(:created_at).second.agent.full_name.should eq 'test1'
        item_10101.manifestation.creates.order(:created_at).second.create_type.name.should eq 'illustrator'
        item_10101.manifestation.date_of_publication.should eq Time.zone.parse('2001-01-01')
        item_10101.budget_type.name.should eq 'Public fund'
        item_10101.bookstore.name.should eq 'Example store'
        item_10101.manifestation.classifications.count.should eq 1
        item_10101.manifestation.classifications.first.classification_type.name.should eq 'ndc9'
        item_10101.manifestation.classifications.first.category.should eq '007'
        item_10101.manifestation.language.name.should eq 'Japanese'
        item_10101.manifestation.statement_of_responsibility.should eq '著者A; 著者B'
        item_10101.binding_item_identifier.should eq '9001'
        item_10101.binding_call_number.should eq '330|A'
        item_10101.binded_at.should eq Time.zone.parse('2014-08-16')
        item_10101.manifestation.publication_place.should eq '東京'
        item_10101.include_supplements.should eq true
        item_10101.note.should eq 'カバーなし'
        item_10101.url.should eq 'http://example.jp/item/1'
        item_10101.manifestation.carrier_type.name.should eq 'volume'
        item_10101.manifestation.manifestation_content_type.name.should eq 'text'
        item_10101.manifestation.frequency.name.should eq 'monthly'
        item_10101.manifestation.extent.should eq 'xv, 213 pages'
        item_10101.manifestation.dimensions.should eq '20cm'

        item_10102 = Item.find_by(item_identifier: '10102')
        item_10102.manifestation.date_of_publication.should eq Time.zone.parse('2001-01-01')
        item_10102.manifestation.language.name.should eq 'Japanese'
        item_10102.manifestation.height.should eq 257
        item_10102.manifestation.width.should eq 182
        item_10102.manifestation.depth.should eq 12
        item_10102.manifestation.start_page.should eq 1
        item_10102.manifestation.end_page.should eq 200
        item_10102.manifestation.series_statements.first.creator_string.should eq 'シリーズの著者'
        item_10102.manifestation.series_statements.first.volume_number_string.should eq 'シリーズ1号'

        Manifestation.find_by(manifestation_identifier: '103').original_title.should eq 'ダブル"クォート"を含む資料'
        item = Item.find_by(item_identifier: '11111')
        item.shelf.name.should eq shelves(:shelf_00001).name
        item.manifestation.price.should eq 1000
        item.price.should eq 0
        item.manifestation.publishers.size.should eq 2

        item_10103 = Item.find_by(item_identifier: '10103')
        item_10103.budget_type.should be_nil
        item_10103.bookstore.name.should eq 'Example store'

        item_10104 = Item.find_by(item_identifier: '10104')
        item_10104.manifestation.date_of_publication.should eq Time.zone.parse('2001-01-01')
        item_10104.budget_type.name.should eq 'Public fund'
        item_10104.bookstore.should be_nil
        item_10104.call_number.should eq '007|A'
        item_10104.manifestation.carrier_type.name.should eq 'online_resource'
        item_10104.manifestation.manifestation_content_type.name.should eq 'still_image'
        item_10104.manifestation.frequency.name.should eq 'unknown'
        item_10104.manifestation.volume_number_string.should eq '第3巻'
        item_10104.manifestation.volume_number.should eq 3
        item_10104.manifestation.issue_number_string.should eq '第10号'
        item_10104.manifestation.issue_number.should eq 10
        item_10104.manifestation.edition_string.should eq '初版'
        item_10104.manifestation.edition.should eq 1
        item_10104.manifestation.serial_number.should eq 120
        item_10104.manifestation.doi_record.body.should eq 'example/2014.08.18'
        item_10104.manifestation.height.should be_nil
        item_10104.manifestation.width.should be_nil
        item_10104.manifestation.depth.should be_nil
        item_10104.manifestation.subjects.order(:created_at).map{|s| {s.subject_heading_type.name => s.term}}.should eq [{"ndlsh" => "コンピュータ"}, {"ndlsh" => "図書館"}]
        item_10104.manifestation.classifications.order(:created_at).map{|c| {c.classification_type.name => c.category}}.should eq [{"ndc9" => "007"}, {"ddc" => "003"}, {"ddc" => "004"}]

        manifestation_104 = Manifestation.find_by(manifestation_identifier: '104')
        manifestation_104.isbn_records.pluck(:body).should eq ['9784797327038']
        manifestation_104.original_title.should eq 'test10'
        manifestation_104.creators.collect(&:full_name).should eq ['test3']
        manifestation_104.publishers.collect(&:full_name).should eq ['test4']
        manifestation_105 = Manifestation.find_by(manifestation_identifier: '105')
        manifestation_105.serial.should be_truthy

        ResourceImportResult.where(manifestation_id: manifestation_101.id).order(:created_at).last.error_message.should eq "line 22: #{I18n.t('import.manifestation_found')}"
        ResourceImportResult.where(item_id: item_10101.id).order(:created_at).last.error_message.should eq "line 9: #{I18n.t('import.item_found')}"

        Item.find_by(item_identifier: '11113').manifestation.original_title.should eq 'test10'
        Item.find_by(item_identifier: '11114').manifestation.id.should eq manifestations(:manifestation_00001).id

        @file.resource_import_fingerprint.should be_truthy
        @file.executed_at.should be_truthy

        @file.reload
        @file.error_message.should eq "The following column(s) were ignored: invalid"
      end

      it "should send message when import is completed", vcr: true do
        old_message_count = Message.count
        @file.import_start
        Message.count.should eq old_message_count + 1
        Message.order(:created_at).last.subject.should eq 'インポートが完了しました'
      end

      it "should be searchable right after the import", solr: true, vcr: true do
        @file.import_start
        Manifestation.search{ keywords "10101" }.total.should > 0
        Manifestation.search{ keywords "10101", fields: [:item_identifier] }.total.should > 0
        Manifestation.search{ keywords "item_identifier_sm:10101" }.total.should > 0
      end
    end

    describe "ISBN import" do
      it "should import multiple ISBNs", vcr: true do
        file = ResourceImportFile.create resource_import: StringIO.new("original_title\tisbn\noriginal_title_multiple_isbns\t978-4840239219//978-4043898039\n"), user: users(:admin)
        result = file.import_start
        expect(result[:manifestation_imported]).to eq 1
        resource_import_result = file.resource_import_results.last
        expect(resource_import_result.manifestation).not_to be_blank
        manifestation = resource_import_result.manifestation
        expect(manifestation.isbn_records.pluck(:body)).to include("9784840239219")
        expect(manifestation.isbn_records.pluck(:body)).to include("9784043898039")
      end

      context "with record not found" do
        it "should record an error message", vcr: true do
          file = ResourceImportFile.create resource_import: StringIO.new("isbn\n9780007264551"), user: users(:admin)
          result = file.import_start
          expect(result[:failed]).to eq 1
          resource_import_result = file.resource_import_results.last
          expect(resource_import_result.error_message).not_to be_empty
        end
      end

      context "with ISBN invalid" do
        it "should record an error message", vcr: true do
          file = ResourceImportFile.create resource_import: StringIO.new("isbn\n978000726455x"), user: users(:admin)
          result = file.import_start
          expect(result[:failed]).to eq 1
          resource_import_result = file.resource_import_results.last
          expect(resource_import_result.error_message).not_to be_empty
        end
      end
    end

    describe "NCID import" do
      it "should import ncid value" do
        file = ResourceImportFile.create resource_import: StringIO.new("original_title\tncid\noriginal_title_ncid\tBA67656964\n"), user: users(:admin)
        result = file.import_start
        expect(result[:manifestation_imported]).to eq 1
        resource_import_result = file.resource_import_results.last
        expect(resource_import_result.error_message).to be_blank
        expect(resource_import_result.manifestation).not_to be_blank
        manifestation = resource_import_result.manifestation
        expect(manifestation.ncid_record.body).to eq 'BA67656964'
      end
    end

    describe "when it has only isbn" do
      before(:each) do
        @file = ResourceImportFile.create!(
          resource_import: File.new("#{Rails.root}/../../examples/isbn_sample.txt"),
          user: users(:admin)
        )
      end

      it "should be imported", vcr: true do
        old_manifestations_count = Manifestation.count
        old_agents_count = Agent.count
        @file.import_start
        Manifestation.count.should eq old_manifestations_count + 1
        Agent.count.should eq old_agents_count + 5
      end
    end

    describe "when it contains edition fields" do
      it "should be imported" do
        import_file = <<-EOF
original_title	edition	edition_string
resource_import_file_test_edition	2	Revised Ed.
        EOF
        file = ResourceImportFile.create(
          resource_import: StringIO.new(import_file),
          user: users(:admin)
        )
        old_manifestations_count = Manifestation.count
        result = file.import_start
        expect(Manifestation.count).to eq old_manifestations_count + 1
        manifestation = Manifestation.all.find{|m| m.original_title == "resource_import_file_test_edition" }
        expect(manifestation.edition).to eq 2
        expect(manifestation.edition_string).to eq "Revised Ed."
      end
    end
  end

  describe "when its mode is 'update'" do
    describe "NCID import" do
      it "should import ncid value" do
        file = ResourceImportFile.create resource_import: StringIO.new("manifestation_id\tncid\n#{manifestations(:manifestation_00001).id}\tBA67656964\n"), user: users(:admin), edit_mode: 'update'
        result = file.import_start
        # expect(result[:manifestation_found]).to eq 1
        expect(file.error_message).to be_nil
        resource_import_result = file.resource_import_results.order(:created_at).last
        expect(resource_import_result.error_message).to be_blank
        manifestation = resource_import_result.manifestation
        expect(manifestation).not_to be_blank
        expect(manifestation.ncid_record.body).to eq "BA67656964"
      end
    end
  end
end

# == Schema Information
#
# Table name: resource_import_files
#
#  id                           :bigint(8)        not null, primary key
#  content_type                 :string
#  size                         :integer
#  user_id                      :bigint(8)
#  note                         :text
#  executed_at                  :datetime
#  resource_import_file_name    :string
#  resource_import_content_type :string
#  resource_import_file_size    :integer
#  resource_import_updated_at   :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  edit_mode                    :string
#  resource_import_fingerprint  :string
#  error_message                :text
#  user_encoding                :string
#  default_shelf_id             :bigint(8)
#
