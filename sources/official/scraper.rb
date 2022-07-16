#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      nodes.first
    end

    def position
      nodes.last.sub('Prime Minister, in charge of', 'Prime Minister and Minister of').split(/(?:and (?=Minister)|&)/).map(&:tidy)
    end

    def empty?
      nodes.empty?
    end

    private

    def nodes
      noko.xpath('.//text()').map(&:text).map(&:tidy).reject(&:empty?)
    end
  end

  class Members
    def member_items
      super.reject(&:empty?)
    end

    def members
      super.reject { |mem| mem[:position].start_with? 'State Secretary' } # TODO: include these later
    end

    def member_container
      noko.css('article table td')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
