module RubyQuiz
  class Crosswords
    attr_reader :crossword, :cell_height, :cell_width, :clue_number, :row, :column, :output_string;

    def initialize( filename )
      @crossword = Array.new()
      load_file( filename )
      @output_string = ''
      @cell_height = 2
      @cell_width = 4
      @clue_number = 1
    end

    def load_file( filename )
      file = File.open(filename, "rb");
      contents = file.read
      lines = contents.split(/\n/)
      lines.each { |line|
        line.gsub!(/\r/, '')
        line.gsub!(/\s+/, '')
        @crossword.push(line.split(//))
      }
    end

    def print_crossword()
      @row = 0
      0.upto(@crossword.length() - 1) do
        @column = 0
        if @row == 0 then
          print_line_divider(@crossword[@row])
        end
        create_cell(@crossword[@row])
        print_line_divider(@crossword[@row])
        @row += 1
      end
      puts(@output_string)
    end

    def print_line_divider(line)
        @output_string += '#'
        0.upto(line.length() - 1) do
          @output_string += '#' * (@cell_width + 1)
        end
        @output_string += "\n"
    end

    def clean_up_string
        # TODO
    end

    def output_sting
      return @output_string
    end

    def create_cell( line )
      (1..@cell_height).each { |iteration|
        @column = 0
        cells_string = ''
        0.upto(line.length() - 1) do
          cells_string += '#'
          if is_entry(0, 0) then
           if(((!is_entry(-1, 0) && is_entry(1, 0)) ||
              (!is_entry(0, -1) && is_entry(0, 1))) &&
              (iteration == 1)) then
            cells_string += sprintf("%-#{@cell_width}d", @clue_number);
            @clue_number += 1
            else
              cells_string += ' ' * @cell_width;
            end
          else
             cells_string += '#' * @cell_width
          end
          @column += 1
        end
        cells_string += '#'

        @output_string += "#{cells_string}\n"
      }
    end

    def is_entry(row_offset, column_offset)
      if((@row + row_offset < 0) || (@column + column_offset < 0)) then return false end
      if(@row + row_offset > @crossword.length - 1) then return false end
      if(@column + column_offset > @crossword[@row + row_offset].length - 1) then return false end
      if(@crossword[@row + row_offset][@column + column_offset].eql?('X')) then return false end
      return true
    end

  end
end


