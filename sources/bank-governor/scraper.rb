#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderNonTable < OfficeholderListBase::OfficeholderBase
  def empty?
    false
  end

  def combo_date?
    true
  end

  def raw_combo_date
    raise 'need to define a raw_combo_date'
  end

  def name_node
    raise 'need to define a name_node'
  end
end


class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  # TODO: make this easier to override
  def holder_entries
    noko.xpath("//h2[.//span[contains(.,'Governors')]][1]//following-sibling::ul[1]//li[a]")
  end

  class Officeholder < OfficeholderNonTable
    def raw_combo_dates
      noko.text[/\((.*?)\)/, 1].split(/[-–]/).map(&:tidy)
    end

    def name_node
      noko.css('a').first
    end

    def item
      noko.css('a/@wikidata').map(&:text).last
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
