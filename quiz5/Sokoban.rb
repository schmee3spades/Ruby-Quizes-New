require 'matrix'
module RubyQuiz
  class Sokoban
    attr_reader :puzzle_matrix, :man_row, :man_column, :error_message

    def initialize()
      @puzzle_matrix = Array.new()
      self.parse_string_into_puzzle_matrix(self.get_maze_string())
    end
    def initialize(string)
      @puzzle_matrix = Array.new()
      self.parse_string_into_puzzle_matrix(string)
    end

    def validate()
      if self.person_position() == nil
        @error_message = 'Maze does not have person';
      end
    end

    def get_maze_string()
      puts "Input maze, blank line to end input"
      maze_string = String.new()
      while((line = gets) != "\n")
        maze_string += line
      end
    end

    def parse_string_into_puzzle_matrix(string)
      lines = string.split("\n")
      lines.each do |line|
        @puzzle_matrix << line.split(//)
        if index = line.split(//).index("+") then
          @man_row = (@puzzle_matrix.size - 1).to_s;
          @man_column = index.to_s;
        end
        if index = line.split(//).index("@") then
          @man_row = (@puzzle_matrix.size - 1).to_s;
          @man_column = index.to_s;
        end
      end
    end

    def move(string)
      self.move_piece(@man_row, @man_column, string)
    end

    def destination_from_direction(row, column, direction)
      if direction == 'right' then
        column = column.to_i + 1
      end
      if direction == 'left' then
        column = column.to_i - 1
      end
      if direction == 'up' then
        row = row.to_i - 1
      end
      if direction == 'down' then
        row = row.to_i + 1
      end
      return row, column
    end

    def print_maze
      @puzzle_matrix.each do |row|
        puts row.join('')
      end
      puts @error_message
    end

    def move_piece(from_row, from_column, direction)
self.print_maze()
      to_row, to_column = destination_from_direction(from_row, from_column, direction)

      int_to_row = to_row.to_i
      int_to_column = to_column.to_i
      int_from_row = from_row.to_i
      int_from_column = from_column.to_i

      to_icon = @puzzle_matrix[int_to_row][int_to_column];
      from_icon = @puzzle_matrix[int_from_row][int_from_column];

      @error_message = '';
      if to_icon == '#' then
puts "wall"
        if @puzzle_matrix[int_from_row][int_from_column] == '@' or
           @puzzle_matrix[int_from_row][int_from_column] == '+' then
          @error_message = 'can not move into wall';
        else
          @error_message = 'can not move crate';
        end
        return 0
      end

      if to_icon == ' ' or to_icon == '.' then
        @puzzle_matrix[int_to_row][int_to_column] =
          self.entering_changed_symbol_to(to_icon, from_icon)
        @puzzle_matrix[int_from_row][int_from_column] =
          self.leaving_changes_symbol_to(from_icon)
        if from_icon == '@' or from_icon == '+' then
          @man_row = int_to_row
          @man_column = int_to_column
        end
self.print_maze()
        return 1
      end

      if to_icon == 'o' or to_icon == '*' then
        if from_icon == 'o' or from_icon == '*' then
          @error_message = 'can not move crate';
          return 0
        else
          if self.move_piece(int_to_row, int_to_column, direction) == 1 then
            to_icon = @puzzle_matrix[int_to_row][int_to_column];
            from_icon = @puzzle_matrix[int_from_row][int_from_column];

            @puzzle_matrix[int_to_row][int_to_column] =
              self.entering_changed_symbol_to(to_icon, from_icon)
            @puzzle_matrix[int_from_row][int_from_column] =
              self.leaving_changes_symbol_to(from_icon)
            @man_row = int_to_row
            @man_column = int_to_column
self.print_maze()
            return 1
          else
            @error_message = 'can not move crate';
            return 0
          end
        end
      end
    end

    def leaving_changes_symbol_to(icon)
      move_away_hash = Hash[
        'o' => ' ',
        '@' => ' ',
        '+' => '.',
        '*' => '.',
      ]
      return move_away_hash[icon]
    end

    def entering_changed_symbol_to(current_icon,entering_icon)
      if entering_icon == '@' or entering_icon == '+' then
        move_into_hash = Hash[
          " " => "@",
          "." => "+",
        ]
        return move_into_hash[current_icon]
      else
        move_into_hash = Hash[
          " " => "o",
          "." => "*",
        ]
        return move_into_hash[current_icon]
      end
    end

    def person_position()
      if(@man_row && @man_column) then
        return [ @man_row.to_i, @man_column.to_i ]
      end
    end

  end
end

#     def encrypt
#       self.process :add_keystreams
#     end
# 
#     def decrypt
#       self.process :subtract_keystreams
#     end
# 
#     def process(process_method)
#       msg = self.massage_message @message
#       keystream = self.find_keystream_letters(msg.length)
# 
#       keystream, msg = [keystream, msg].map do |m|
#         self.to_numbers self.groups_of_five(m).join(' ').chars.to_a
#       end
#       processed = self.send process_method, msg, keystream
# 
#       self.to_letters(processed).join
#     end
# 
#     def massage_message(string)
#       string.upcase.gsub(/[^A-Z]/, '')
#     end
# 
#     def groups_of_five(string)
#       string.scan(/.{1,5}/).map { |g| g }
#     end
# 
#     def to_numbers(arr)
#       arr.map { |c| map_char c }
#     end
# 
#     def to_letters(arr)
#       arr.map { |c| map_char c }
#     end
# 
#     def add_keystreams(m, k)
#       [].tap do |result|
#         0.upto(m.size-1) do |n|
#           result << case
#             when m[n] == ' ' || k[n] == ' '
#               ' '
#             when (sum = m[n] + k[n]) > 26
#               sum - 26
#            else
#               sum
#           end
#         end
#       end
#     end
# 
#     def subtract_keystreams(m, k)
#       [].tap do |result|
#         0.upto(m.size-1) do |n|
#           result << case
#             when m[n] == ' ' || k[n] == ' '
#               ' '
#             when m[n] <= k[n]
#               m[n].to_i + 26 - k[n].to_i
#             else
#               m[n].to_i - k[n].to_i
#           end
#         end
#       end
#     end
# 
#     def move_jokers
#       [1, 2].each do |offset|
#         from = @cards.index { |c| c.suit.nil? && c.face == offset }
#         to = case @cards[from]
#           when @cards[-1]
#             offset
#           when @cards[-2]
#             offset == 1 ? from + offset : 1
#           else
#             from + offset
#         end
#         @cards.insert(to, @cards.delete_at(from))
#       end
#     end
# 
#     def triple_cut
#       left, right = @cards.select { |c| c.suit.nil? }.map { |c| @cards.index(c) }
# 
#       @cards = @cards[right+1...@cards.size] + @cards[left..right] + @cards[0...left]
#     end
# 
#     def count_cut
#       @cards.insert(-2, *@cards.slice!(0, @cards.last.value))
#     end
# 
#     def find_keystream_letters(n=1)
#       [].tap do |result|
#         until result.size == n
#           %W[ move_jokers triple_cut count_cut ].each { |m| self.send(m) }
#           output = @cards.take(@cards.first.value + 1).last.to_letter
#           result << output unless output == ' '
#         end
#       end.join
#     end
# 
#     def prettify
#       @cards.map(&:print_value)
#     end
# 
#     private
#       def map_char(char)
#         case char
#           when 1..26
# puts "char %{char}  result: %{(char + 64).chr}"
#             (char + 64).chr
#           when ?A..?Z
#             char.ord % 64
#           else
#             char
#         end
#       end
#   end
# 
#   class Card
#     attr_reader :face, :suit
# 
#     def initialize(face, suit)
#       @face, @suit = face, suit
#     end
# 
#     def print_value
#       @print_value ||= (@suit.nil? ? (@face + 64).chr : @face + (@suit * 13))
#     end
# 
#     def value
#       @value ||= (@suit.nil? ? 53 : @face + (@suit * 13))
#     end
# 
#     def to_letter
#       @letter ||= self.suit.nil? ? ' ' : (self.value - (@suit > 1 ? 26 : 0) + 64).chr
#     end
#   end
# end

