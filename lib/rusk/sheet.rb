# -*- coding: utf-8 -*-

module Rusk
  class Sheet
    include Enumerable

    def initialize(content)
      @content = content
      @cells = []
    end

    def name
      @content["table:name"]
    end

    def name= name
      @content["table:name"] = name
    end

    def [](row, column)
      return nil if row > @cells.size || column > @cells[0].size
      @cells[row][column]
    end

    def each
      each_row do |row_range|
        row_range.each do |cell|
          yield cell
        end
      end
    end

    def each_row(options = {force: false})
      row_index = 0
      @content.xpath('.//table:table-row').each_with_index do |row_range, index|
        if @cells[row_index]
          yield @cells[row_index]
          row_index += 1
          next
        end
        rows_repeated = row_range["table:number-rows-repeated"].to_i
        break if rows_repeated + row_index + 1 >= 1048576 && options[:force] == false

        cells = row_cells(row_range)
        yield cells
        @cells << cells
        row_index += 1

        if rows_repeated > 1
          base_row_range = row_range
          (rows_repeated - 1).times do |i|
            base_row_range.remove_attribute("number-rows-repeated")
            base_row_range = base_row_range.add_next_sibling(row_range.dup)
            base_row_range["table:number-rows-repeated"] = (rows_repeated - i)
            cells = row_cells(base_row_range)
            yield cells
            @cells << cells
            row_index += 1
          end
        end
      end
    end

    def each_column
      @cells.transpose.each do |columns|
        yield columns
      end
    end

    private
    def row_cells(row_range)
      row_cells = []
      row_range.xpath(".//table:table-cell|.//table:covered-table-cell").each do |cell|
        row_cells << Rusk::Cell.new(cell)

        number_repeated = cell["table:number-columns-repeated"].to_i
        if number_repeated > 1
          cell.remove_attribute("number-columns-repeated")
          base_cell = cell
          (number_repeated - 1).times do
            base_cell = base_cell.add_next_sibling(cell.dup)
            row_cells << Rusk::Cell.new(base_cell)
          end
        end
      end

      row_cells
    end

  end
end
