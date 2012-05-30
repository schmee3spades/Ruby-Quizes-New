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
        line = @crossword[@row]

        # row divider
        0.upto(line.length() - 1) do
          print_wall_character( (is_entry(-1, -1) || is_entry(-1, 0) || is_entry(0, -1) || is_entry(0, 0)), 1)
          print_wall_character( (is_entry(-1, 0) || is_entry(0, 0)), @cell_width)
          @column += 1
        end
        print_wall_character( (is_entry(0, -1) ||  is_entry(-1, 0)), 1)
        @output_string += "\n"

        @column = 0
        create_cell(line, true, 1)

        @column = 0
        create_cell(line, false, @cell_height - 1)

        @row += 1
      end

      @column = 0
      0.upto(@crossword[@crossword.length()-1].length() - 1) do
        print_wall_character( (is_entry(-1, -1) || is_entry(-1, 0)), 1)
        print_wall_character( is_entry(-1, 0), @cell_width)
        @column += 1
      end

      print_wall_character( is_entry(-1, -1), 1)
      @output_string += "\n"

      puts(@output_string)
    end

    def output_sting
      return @output_string
    end

    def print_wall_character(is_solid, number_of_characters)
      @output_string += is_solid ? ('#' * number_of_characters): (' ' * number_of_characters);
    end

    def create_cell( line, show_number, heigth )
      cells_string = ''
      0.upto(line.length() - 1) do
        cells_string += (is_entry(0, -1) || is_entry(0, 0)) ? '#': ' '

        if is_entry(0, 0) then
          if show_number then
             if((!is_entry(-1, 0) && is_entry(1, 0)) ||
                (!is_entry(0, -1) && is_entry(0, 1))) then
               cells_string += sprintf("%-#{@cell_width}d", @clue_number);
               @clue_number += 1
             else
               cells_string += ' ' * @cell_width;
             end
          else
             cells_string += ' ' * @cell_width;
          end
        else
           cells_string += '#' * @cell_width
        end
        @column += 1
      end
      cells_string += is_entry(0, 0)? ' ': '#'

      1.upto(heigth) do
         @output_string += "#{cells_string}\n"
      end
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


