# -*- encoding: utf-8 -*-
class CiniiBook
  attr_reader :title, :creator, :publisher, :issued, :isbn

  def initialize(node)
    @node = node
  end

  def title
    @node.at('./title').try(:content).to_s
  end

  def creator
    @node.xpath('./dc:creator').collect(&:content).join(' ')
  end

  def publisher
    @node.xpath('./dc:publisher').collect(&:content).join(' ')
  end

  def issued
    @node.at('./dcterms:issued[@xsi:type="dcterms:W3CDTF"]').try(:content).to_s
  end

  def isbn
    @node.at('./dc:identifier[@xsi:type="dcndl:ISBN"]').try(:content).to_s
  end

  def self.per_page
    10
  end

  def self.search(query, page = 1, per_page = self.per_page)
    if query
      cnt = self.per_page
      page = 1 if page.to_i < 1
      idx = (page.to_i - 1) * cnt + 1
      doc = Nokogiri::XML(Manifestation.search_ndl(query, {:cnt => cnt, :page => page, :idx => idx, :raw => true}).to_s)
      items = doc.xpath('//channel/item').collect{|node| self.new node }
      total_entries = doc.at('//channel/openSearch:totalResults').content.to_i

      {:items => items, :total_entries => total_entries}
    else
      {:items => [], :total_entries => 0}
    end
  end

  def self.import_ncid(ncid)
  end

  attr_accessor :url

  class AlreadyImported < StandardError
  end
end
