#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Governors'
  end

  # TODO: make this easier to override
  def holder_entries
    noko.xpath("//h2[.//span[contains(.,'#{header_column}')]][1]//following-sibling::ul[1]//li[a]")
  end

  class Officeholder < OfficeholderBase
    def combo_date?
      true
    end

    def raw_combo_dates
      noko.text[/\((.*?)\)/, 1].split(/[-–]/).map(&:tidy)
    end

    def name_cell
      noko.xpath('a')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
