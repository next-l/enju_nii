# -*- encoding: utf-8 -*-
module EnjuNii
  module CiNiiBook
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def import_isbn(isbn)
        return nil unless isbn
        lisbn = Lisbn.new(isbn)
        raise EnjuNii::InvalidIsbn unless lisbn.valid?

        manifestation = Manifestation.find_by_isbn(lisbn.isbn)
        return manifestation if manifestation

        doc = return_xml(lisbn.isbn)
        raise EnjuNii::RecordNotFound unless doc
        #raise EnjuNii::RecordNotFound if doc.at('//openSearch:totalResults').content.to_i == 0
        import_record(doc)
      end

      def search_cinii_book(query, options = {})
        options = {:p => 1, :count => 10, :raw => false}.merge(options)
        doc = nil
        results = {}
        startrecord = options[:idx].to_i
        if startrecord == 0
          startrecord = 1
        end
        url = "http://ci.nii.ac.jp/books/opensearch/search?q=#{query}&p=#{options[:p]}&count=#{options[:count]}&format=rss"
        if options[:raw] == true
          open(url).read
        else
          RSS::RDF::Channel.install_text_element("opensearch:totalResults", "http://a9.com/-/spec/opensearch/1.1/", "?", "totalResults", :text, "opensearch:totalResults")
          RSS::BaseListener.install_get_text_element("http://a9.com/-/spec/opensearch/1.1/", "totalResults", "totalResults=")
          feed = RSS::Parser.parse(url, false)
        end
      end

      def return_xml(isbn)
        rss = self.search_cinii_book(isbn, {:dpid => 'iss-ndl-opac', :item => 'isbn'})
        if rss.channel.totalResults.to_i == 0
          isbn = normalize_isbn(isbn)
          rss = self.search_ndl(isbn, {:dpid => 'iss-ndl-opac', :item => 'isbn'})
        end
        if rss.items.first
          doc = Nokogiri::XML(open("#{rss.items.first.link}.rdf").read)
        end
      end

      private
      def normalize_isbn(isbn)
        if isbn.length == 10
          Lisbn.new(isbn).isbn13
        else
          Lisbn.new(isbn).isbn10
        end
      end
    end

    class AlreadyImported < StandardError
    end
  end
end
