# -*- encoding: utf-8 -*-
class CiniiBook
  attr_reader :title, :creator, :publisher, :link

  def initialize(node)
    @node = node
  end

  def title
    @node.at('./xmlns:title').try(:content)
  end

  def creator
    @node.at('./dc:creator').try(:content)
  end

  def publisher
    @node.at('./dc:publisher').try(:content)
  end

  def link
    @node.at('./xmlns:link').try(:content)
  end

  def self.per_page
    10
  end

  def self.search(query, page = 1, per_page = self.per_page)
    if query
      cnt = self.per_page
      page = 1 if page.to_i < 1
      doc = Nokogiri::XML(Manifestation.search_cinii_book(query, {:p => page, :count => cnt, :raw => true}).to_s)
      items = doc.xpath('//xmlns:item').collect{|node| self.new node }
      total_entries = doc.at('//opensearch:totalResults').content.to_i

      {:items => items, :total_entries => total_entries}
    else
      {:items => [], :total_entries => 0}
    end
  end

  def self.import_ncid(ncid)
    manifestation = Manifestation.where(:ncid => ncid).first
    return if manifestation
    url = "http://ci.nii.ac.jp/ncid/#{ncid}.rdf"
    doc = Nokogiri::XML(open(url).read)
    Manifestation.import_record_from_cinii_books(doc)
  end

  attr_accessor :url

  class AlreadyImported < StandardError
  end
end
