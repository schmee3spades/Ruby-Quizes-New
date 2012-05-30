module RubyQuiz
  class Crosswords
    attr_reader :crossword, :cell_height, :cell_width, :clue_number, :row_separators, :column_separators, :output_string;

    def initialize( filename )
      @crossword = Array.new()
      @row_separators = Array.new()
      @column_separators = Array.new()
      load_file( filename )
      @cell_height = 2
      @cell_width = 4
      @clue_number = 1
      @output_string = String.new()
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
      make_stars_for_blanks
      define_separators
    end

    def make_stars_for_blanks()
        0.upto(@crossword.length() - 1) do |row|
          line = @crossword[row]
          if(row == 0 || row == (@crossword.length() - 1)) then
            0.upto(line.length() - 1) do |column|
              should_be_star(row, column)
            end
          else
            should_be_star(row, 0)
            should_be_star(row, line.length() - 1)
          end
        end
    end

    def should_be_star(row, column)
        if( (row < 0) || (column < 0) || (row > @crossword.length() - 1) || (column > @crossword[@crossword.length() - 1].length - 1)) then
          return 0
        end

        if((@crossword[row][column] == '_') || (@crossword[row][column] == '*')) then
          return 0
        end

        if( (row == 0) || (column == 0) || (row == @crossword.length() - 1) || (column == @crossword[@crossword.length() - 1].length - 1) ) then
          @crossword[row][column] = '*'
          -1.upto(1) do |row_offset|
            -1.upto(1) do |column_offset|
              should_be_star(row + row_offset, column + column_offset)
            end
          end
        end

        -1.upto(1) do |row_offset|
          -1.upto(1) do |column_offset|
            if(!(row_offset == 0) && !(column_offset == 0)) then
              next
            end
            if(defined? @crossword[row+row_offset][column+column_offset]) then
              if(@crossword[row+row_offset][column+column_offset] == '*') then
                @crossword[row][column] = '*'
                -1.upto(1) do |row_offset_inner|
                  -1.upto(1) do |column_offset_inner|
                    if((defined? @crossword[row+row_offset_inner][column+column_offset_inner]) && (@crossword[row+row_offset_inner][column+column_offset_inner] == 'X')) then
                      should_be_star(row + row_offset_inner, column + column_offset_inner)
                    end
                  end
                end
              end
            end
          end
        end
    end

    def define_separators
      line = Array.new()
      0.upto(@crossword.length() - 1) do |row|
        line = @crossword[row]
        @row_separators[row] = Array.new()
        @column_separators[row] = Array.new()
        0.upto(line.length() - 1) do |column|
          (is_star(row-1,column) && is_star(row,column)) ?
            @row_separators[row].push(0) : @row_separators[row].push(1)
          (is_star(row,column - 1) && is_star(row,column)) ?
            @column_separators[row].push(0) : @column_separators[row].push(1)
        end
        is_star(row,line.length() - 1) ? 
          @column_separators[row].push(0) : @column_separators[row].push(1)
      end
      @row_separators[@crossword.length()] = Array.new()
      0.upto(@crossword[@crossword.length() - 1].length - 1) do |column|
        is_entry(@crossword.length() - 1,column) ? 
          @row_separators[@crossword.length()].push(1) : @row_separators[@crossword.length()].push(0)
      end
    end

    def is_entry(row, column)
      if((row < 0) || (column < 0)) then return false end
      if(row > @crossword.length - 1) then return false end
      if(column > @crossword[row].length - 1) then return false end
      if(@crossword[row][column].eql?('_')) then return true end
      return false
    end

    def is_star(row, column)
      if((row < 0) || (column < 0)) then return true end
      if(row > @crossword.length - 1) then return true end
      if(column > @crossword[row].length - 1) then return true end
      if(@crossword[row][column].eql?('*')) then return true end
      return false
    end

    def print_crossword()
      0.upto(@row_separators.length - 2) do |row|
        column_seps = @column_separators[row]

        0.upto(@row_separators[row].length - 1) do |column|
          #@output_string += ( @row_separators[row][column] == 1 || column_seps[column] == 1) ? '#' : ' '
          @output_string += (( @row_separators[row][column] == 1 || column_seps[column] == 1) ||
                             ( (row > 0) && (@row_separators[row-1][column] == 1))) ? '#' : ' '
          @output_string += ( @row_separators[row][column] == 1 ) ? '#' * @cell_width : ' ' * @cell_width
        end

        @output_string += (@row_separators[row][@row_separators[row].length-1] == 1 || column_seps[column_seps.length-1] == 1) ? '#' : ' '
        @output_string += "\n"

        number_string = ''
        body_string = ''

        0.upto(@row_separators[row].length - 1) do |column|
          body_string += column_seps[column] == 1 ? '#' : ' '
          number_string += column_seps[column] == 1 ? '#' : ' '
          if(((!is_entry(row - 1, column) && is_entry(row + 1, column)) ||
              (!is_entry(row, column - 1) && is_entry(row, column + 1))) &&
              (@crossword[row][column] == '_')) then
            body_string += ' ' * @cell_width
            number_string += sprintf("%-#{@cell_width}d", @clue_number);
            @clue_number += 1
          else
            body_string += @crossword[row][column] == 'X' ? '#' * @cell_width : ' ' * @cell_width
            number_string += @crossword[row][column] == 'X' ? '#' * @cell_width : ' ' * @cell_width
          end
        end
        body_string += column_seps[column_seps.length-1] == 1 ? "#\n" : " \n"
        number_string += column_seps[column_seps.length-1] == 1 ? "#\n" : " \n"

        1.upto(cell_height) do |print_iter|
          print_iter == 1 ? @output_string += number_string : @output_string += body_string
        end
      end
      0.upto(@row_separators[@row_separators.length - 1].length - 1) do |column|
        @output_string += ( @row_separators[@row_separators.length - 1][column] == 1 ) ? '#' : ' '
        @output_string += ( @row_separators[@row_separators.length - 1][column] == 1 ) ? '#' * @cell_width : ' ' * @cell_width
      end
      @output_string += @row_separators[@row_separators.length - 1][@row_separators[@row_separators.length - 1].length-1] == 1 ? '#' : ' '
      @output_string += "\n"
      print @output_string
    end
  end
end


