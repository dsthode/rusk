# -*- coding: utf-8 -*-
#require 'zip/zip'

module Rusk
  class Book
    attr_reader :sheets

    def initialize(file, &block)
      @files = Zip::ZipFile.open(file)
      @content = Nokogiri::XML(@files.read("content.xml"))
      @sheets = @content.xpath("//table:table")

      if block
        begin
          yield self
        ensure
          @files.close
        end
      end
    end

    def [](name_or_index)
      if name_or_index.is_a? Numeric
        sheet = @sheets[name_or_index]
      else
        sheet = @sheets.detect{ |i| i["table:name"] == name_or_index }
      end
      sheet && Rusk::Sheet.new(sheet)
    end

    def save
      @files.get_output_stream("content.xml") { |f| f.puts @content }
    end

    def self.open(file, &block)
      new(file, &block)
    end

  end
end
