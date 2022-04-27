#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Partij'
  end

  def table_number
    '1'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no img name _ _ start end].freeze
    end

    def raw_end
      super.gsub('heden', 'Incumbent')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
