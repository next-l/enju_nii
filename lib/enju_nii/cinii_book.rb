
module EnjuNii
  module CiNiiBook
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def import_from_cinii_books(options)
        # if options[:isbn]
        lisbn = Lisbn.new(options[:isbn])
        raise EnjuNii::InvalidIsbn unless lisbn.valid?
        # end

        manifestation = IsbnRecord.where(body: lisbn.isbn).first.try(:manifestation)
        return manifestation if manifestation

        doc = return_rdf(lisbn.isbn)
        raise EnjuNii::RecordNotFound unless doc
        # raise EnjuNii::RecordNotFound if doc.at('//openSearch:totalResults').content.to_i == 0
        import_record_from_cinii_books(doc)
      end

      def import_record_from_cinii_books(doc)
        # http://ci.nii.ac.jp/info/ja/api/api_outline.html#cib_od
        # return nil

        ncid = doc.at('//cinii:ncid').try(:content)
        if ncid
          ncid_record = NcidRecord.find_by(body: ncid)
          return ncid_recor.manifestation if ncid_record.try(:manifestation)
        end

        creators = get_cinii_creator(doc)
        publishers = get_cinii_publisher(doc)

        # title
        title = get_cinii_title(doc)
        manifestation = Manifestation.new(title)

        # date of publication
        pub_date = doc.at('//dc:date').try(:content)
        if pub_date
          date = pub_date.split('-')
          date = if date[0] && date[1]
                   format('%04d-%02d', date[0], date[1])
                 else
                   pub_date
                 end
        end
        manifestation.pub_date = pub_date

        manifestation.statement_of_responsibility = doc.at('//dc:creator').try(:content)
        manifestation.extent = doc.at('//dcterms:extent').try(:content)
        manifestation.dimensions = doc.at('//cinii:size').try(:content)

        language = Language.where(iso_639_3: get_cinii_language(doc)).first
        manifestation.language_id = if language
                                      language.id
                                    else
                                      1
                                    end

        isbn = nil
        urn = doc.at('//dcterms:hasPart[@rdf:resource]')
        if urn
          urn = urn.attributes['resource'].value
          if urn =~ /^urn:isbn/
            isbn = Lisbn.new(urn.gsub(/^urn:isbn:/, '')).isbn
          end
        end

        manifestation.carrier_type = CarrierType.where(name: 'volume').first
        manifestation.manifestation_content_type = ContentType.where(name: 'text').first

        if manifestation.valid?
          Agent.transaction do
            manifestation.save!
            create_cinii_series_statements(doc, manifestation)
            publisher_patrons = Agent.import_agents(publishers)
            creator_patrons = Agent.import_agents(creators)
            manifestation.publishers = publisher_patrons
            manifestation.creators = creator_patrons
            if defined?(EnjuSubject)
              subjects = get_cinii_subjects(doc)
              subject_heading_type = SubjectHeadingType.where(name: 'bsh').first
              subject_heading_type ||= SubjectHeadingType.create!(name: 'bsh')
              subjects.each do |term|
                subject = Subject.where(term: term[:term]).first
                unless subject
                  subject = Subject.new(term)
                  subject.subject_heading_type = subject_heading_type
                  subject_type = SubjectType.where(name: 'concept').first
                  subject_type ||= SubjectType.create(name: 'concept')
                  subject.subject_type = subject_type
                end
                manifestation.subjects << subject
              end
            end
          end
          ncid_record = NcidRecord.where(body: ncid).first_or_initialize
          ncid_record.manifestation = manifestation
          ncid_record.save
          isbn_record = IsbnRecord.where(body: isbn).first_or_initialize
          manifestation.isbn_records << isbn_record
        end

        manifestation
      end

      def search_cinii_book(query, options = {})
        options = { p: 1, count: 10, raw: false }.merge(options)
        doc = nil
        results = {}
        startrecord = options[:idx].to_i
        startrecord = 1 if startrecord == 0
        url = "http://ci.nii.ac.jp/books/opensearch/search?q=#{URI.escape(query)}&p=#{options[:p]}&count=#{options[:count]}&format=rss"
        if options[:raw] == true
          open(url).read
        else
          RSS::RDF::Channel.install_text_element('opensearch:totalResults', 'http://a9.com/-/spec/opensearch/1.1/', '?', 'totalResults', :text, 'opensearch:totalResults')
          RSS::BaseListener.install_get_text_element('http://a9.com/-/spec/opensearch/1.1/', 'totalResults', 'totalResults=')
          feed = RSS::Parser.parse(url, false)
        end
      end

      def return_rdf(isbn)
        rss = search_cinii_by_isbn(isbn)
        if rss.channel.totalResults.to_i == 0
          rss = search_cinii_by_isbn(cinii_normalize_isbn(isbn))
        end
        if rss.items.first
          Nokogiri::XML(Faraday.get("#{rss.items.first.link}.rdf").body)
        end
      end

      def search_cinii_by_isbn(isbn)
        url = "http://ci.nii.ac.jp/books/opensearch/search?isbn=#{isbn}&format=rss"
        RSS::RDF::Channel.install_text_element('opensearch:totalResults', 'http://a9.com/-/spec/opensearch/1.1/', '?', 'totalResults', :text, 'opensearch:totalResults')
        RSS::BaseListener.install_get_text_element('http://a9.com/-/spec/opensearch/1.1/', 'totalResults', 'totalResults=')
        rss = RSS::Parser.parse(url, false)
      end

      private

      def cinii_normalize_isbn(isbn)
        if isbn.length == 10
          Lisbn.new(isbn).isbn13
        else
          Lisbn.new(isbn).isbn10
        end
      end

      def get_cinii_creator(doc)
        doc.xpath('//foaf:maker/foaf:Person').map do |e|
          {
            full_name: e.at('./foaf:name').content,
            full_name_transcription: e.xpath('./foaf:name[@xml:lang]').map(&:content).join("\n"),
            patron_identifier: e.attributes['about'].try(:content)
          }
        end
      end

      def get_cinii_publisher(doc)
        doc.xpath('//dc:publisher').map { |e| { full_name: e.content } }
      end

      def get_cinii_title(doc)
        {
          original_title: doc.at('//dc:title[not(@xml:lang)]').content,
          title_transcription: doc.xpath('//dc:title[@xml:lang]').map { |e| e.try(:content) }.join("\n"),
          title_alternative: doc.xpath('//dcterms:alternative').map { |e| e.try(:content) }.join("\n")
        }
      end

      def get_cinii_language(doc)
        language = doc.at('//dc:language').try(:content)
        if language.size > 3
          language[0..2]
        else
          language
        end
      end

      def get_cinii_subjects(doc)
        subjects = []
        doc.xpath('//foaf:topic').each do |s|
          subjects << { term: s['dc:title'] }
        end
        subjects
      end

      def create_cinii_series_statements(doc, manifestation)
        series = doc.at('//dcterms:isPartOf')
        if series && (parent_url = series['rdf:resource'])
          ptbl = series['dc:title']
          parent_url = parent_url.gsub(/\#\w+\Z/, '')
          parent_doc = Nokogiri::XML(Faraday.get(parent_url + '.rdf').body)
          parent_titles = get_cinii_title(parent_doc)
          series_statement = SeriesStatement.new(parent_titles)
          series_statement.series_statement_identifier = parent_url
          manifestation.series_statements << series_statement
          if parts = ptbl.split(/ \. /)
            parts[1..-1].each do |part|
              title, volume_number, = part.split(/ ; /)
              original_title, title_transcription, = title.split(/\|\|/)
              series_statement = SeriesStatement.new(
                original_title: original_title,
                title_transcription: title_transcription,
                volume_number_string: volume_number
              )
              manifestation.series_statements << series_statement
            end
          end
        end
      end
    end

    class AlreadyImported < StandardError
    end
  end
end
