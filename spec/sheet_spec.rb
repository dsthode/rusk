# -*- coding: utf-8 -*-
require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Goblin::Sheet do
  before do
    content = Nokogiri::XML(File.read("#{dir}/general_datas_content.xml"))
    @sheet = Goblin::Sheet.new(content.xpath("//table:table")[0])
  end

  describe "#name" do
    it { @sheet.name.should eq "Sheet1" }
  end

  describe "#[]" do
    context "with exist cell index" do
      it { @sheet[2, 1].should be_kind_of Goblin::Cell }
      it { @sheet[0, 0].value.should eq "string" }
      it { @sheet[0, 1].value.should eq "mruby" }
      it { @sheet[1, 1].value.should eq Date.new(2012,4,29) }
      it { @sheet[4, 2].value.should eq 'after merged column' }
      it { @sheet[5, 1].value.should eq 'merged first row cell' }
      it { @sheet[6, 1].value.should eq 'merged second row cell' }
      it { @sheet[11, 0].value.should eq 'hide the cell next to' }
      it { @sheet[11, 1].value.should eq 'hidden cell' }
    end

    context "with not exist cell index" do
      context "when row is existing, column is not existing" do
        it { @sheet[0, 1000].should be_nil }
      end

      context "when row and column is not existing" do
        it { @sheet[1000, 10000].should be_nil }
      end
    end

  end

  describe "#each" do
    it "access order by row and column" do
      xml_cells = Nokogiri::XML(File.read("#{dir}/general_datas_content.xml")).xpath("//table:table")[0].xpath(".//table:table-cell").map{ |i| Goblin::Cell.new(i) }
      index = 0
      @sheet.each do |cell|
        cell.value.should eq xml_cells[index].value
        index += 1
      end
    end
  end

  describe "#each_row" do
    it "access order by first row" do
      xml_cells = Nokogiri::XML(File.read("#{dir}/general_datas_content.xml")).xpath("//table:table")[0].xpath(".//table:table-row")
      index = 0
      @sheet.each_row do |rows|
        rows[0].should eq xml_cells[index].xpath(".//table-cell")[0]
      end
    end
  end

end
