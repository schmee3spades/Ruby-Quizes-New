require 'matrix'
module RubyQuiz
  class Sokoban
    attr_reader :puzzle_matrix, :man_row, :man_column, :error_message, :defined_mazes

    def initialize(string)
      @puzzle_matrix = Array.new()
      if string == '' then
        self.select_maze
      else
        self.parse_string_into_puzzle_matrix(string)
        self.validate()
      end
    end

    def select_maze()
      self.load_saved_mazes()
      puts "Select maze: (1 - #{@defined_mazes.size})"
      maze_number = gets.chomp
      return select_maze unless maze_number.match(/^(\d+)$/)
      if (maze_number.to_i < 1) or maze_number.to_i > @defined_mazes.size then
        return self.select_maze()
      end
      parse_string_into_puzzle_matrix(@defined_mazes[maze_number.to_i-1])
      run_interactive_mode()
      return select_maze
    end

    def validate()
      if self.person_position() == nil
        @error_message = 'Maze does not have person';
      end
      if count_character('o') != (count_character('.') + count_character('+')) then
        @error_message = 'Maze does not have equal number of crates and storage';
      end
    end

    def count_character(string)
      count = 0
      @puzzle_matrix.each do |row|
        row.each do |value|
          if value.to_s == string then
            count += 1
          end
        end
      end
      return count
    end

    def parse_string_into_puzzle_matrix(string)
      string.split("\n").each do |line|
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
      @error_message = '';
      self.move_piece(@man_row, @man_column, string)
      if count_character('o') == 0 then
        @error_message = 'You Win!';
      end
      self.print_maze()
    end

    def destination_from_direction(row, column, direction)
      if direction == 'right' then
        column = column.to_i + 1
      elsif direction == 'left' then
        column = column.to_i - 1
      elsif direction == 'up' then
        row = row.to_i - 1
      elsif direction == 'down' then
        row = row.to_i + 1
      end
      return row, column
    end

    def run_interactive_mode()
      print_maze()
      while true
        input = gets.chomp
        if input != nil
          if input == 'q'
            return
          elsif input == '8' or input == 'k' then
            self.move('up')
          elsif input == '4' or input == 'h' then
            self.move('left')
          elsif input == '2' or input == 'j' then
            self.move('down')
          elsif input == '6' or input == 'l' then
            self.move('right')
          end
        end
      end
    end

    def print_maze
      print "\e[2J"
      @puzzle_matrix.each do |row|
        puts row.join('')
      end
      puts @error_message
    end

    def move_piece(from_row, from_column, direction)
      to_row, to_column = destination_from_direction(from_row, from_column, direction)

      int_to_row = to_row.to_i
      int_to_column = to_column.to_i
      int_from_row = from_row.to_i
      int_from_column = from_column.to_i

      to_icon = @puzzle_matrix[int_to_row][int_to_column];
      from_icon = @puzzle_matrix[int_from_row][int_from_column];

      if to_icon == '#' then
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

    def load_saved_mazes()
       @defined_mazes = [
"    #####
    #   #
    #o  #
  ###  o##
  #  o o #
### # ## #   ######
#   # ## #####  ..#
# o  o          ..#
##### ### #\@##  ..#
    #     #########
    #######",

"############
#..  #     ###
#..  # o  o  #
#..  #o####  #
#..    \@ ##  #
#..  # #  o ##
###### ##o o #
  # o  o o o #
  #    #     #
  ############",

"        ########
        #     \@#
        # o#o ##
        # o  o#
        ##o o #
######### o # ###
#....  ## o  o  #
##...    o  o   #
#....  ##########
########",

"           ########
           #  ....#
############  ....#
#    #  o o   ....#
# ooo#o  o #  ....#
#  o     o #  ....#
# oo #o o o########
#  o #     #
## #########
#    #    ##
#     o   ##
#  oo#oo  \@#
#    #    ##
###########",

"        #####
        #   #####
        # #o##  #
        #     o #
######### ###   #
#....  ## o  o###
#....    o oo ##
#....  ##o  o \@#
#########  o  ##
        # o o  #
        ### ## #
          #    #
          ######",

"######  ###
#..  # ##\@##
#..  ###   #
#..     oo #
#..  # # o #
#..### # o #
#### o #o  #
   #  o# o #
   # o  o  #
   #  ##   #
   #########",

"       #####
 #######   ##
## # \@## oo #
#    o      #
#  o  ###   #
### #####o###
# o  ### ..#
# o o o ...#
#    ###...#
# oo # #...#
#  ### #####
####",

"  ####
  #  ###########
  #    o   o o #
  # o# o #  o  #
  #  o o  #    #
### o# #  #### #
#\@#o o o  ##   #
#    o #o#   # #
#   o    o o o #
#####  #########
  #      #
  #      #
  #......#
  #......#
  #......#
  ########",

"          #######
          #  ...#
      #####  ...#
      #      . .#
      #  ##  ...#
      ## ##  ...#
     ### ########
     # ooo ##
 #####  o o #####
##   #o o   #   #
#\@ o  o    o  o #
###### oo o #####
     #      #
     ########",

" ###  #############
##\@####       #   #
# oo   oo  o o ...#
#  ooo#    o  #...#
# o   # oo oo #...#
###   #  o    #...#
#     # o o o #...#
#    ###### ###...#
## #  #  o o  #...#
#  ## # oo o o##..#
# ..# #  o      #.#
# ..# # ooo ooo #.#
##### #       # #.#
    # ######### #.#
    #           #.#
    ###############",

"          ####
     #### #  #
   ### \@###o #
  ##      o  #
 ##  o oo## ##
 #  #o##     #
 # # o oo # ###
 #   o #  # o #####
####    #  oo #   #
#### ## o         #
#.    ###  ########
#.. ..# ####
#...#.#
#.....#
#######",

"################
#              #
# # ######     #
# #  o o o o#  #
# #   o\@o   ## ##
# #  o o o###...#
# #   o o  ##...#
# ###ooo o ##...#
#     # ## ##...#
#####   ## ##...#
    #####     ###
        #     #
        #######",

"   #########
  ##   ##  #####
###     #  #    ###
#  o #o #  #  ... #
# # o#\@o## # #.#. #
#  # #o  #    . . #
# o    o # # #.#. #
#   ##  ##o o . . #
# o #   #  #o#.#. #
## o  o   o  o... #
 #o ######    ##  #
 #  #    ##########
 ####",

"       #######
 #######     #
 #     # o\@o #
 #oo #   #########
 # ###......##   #
 #   o......## # #
 # ###......     #
##   #### ### #o##
#  #o   #  o  # #
#  o ooo  # o## #
#   o o ###oo # #
#####     o   # #
    ### ###   # #
      #     #   #
      ########  #
             ####",

"   ########
   #   #  #
   #  o   #
 ### #o   ####
 #  o  ##o   #
 #  # \@ o # o#
 #  #      o ####
 ## ####o##     #
 # o#.....# #   #
 #  o..**. o# ###
##  #.....#   #
#   ### #######
# oo  #  #
#  #     #
######   #
     #####",

"#####
#   ##
#    #  ####
# o  ####  #
#  oo o   o#
###\@ #o    ##
 #  ##  o o ##
 # o  ## ## .#
 #  #o##o  #.#
 ###   o..##.#
  #    #.*...#
  # oo #.....#
  #  #########
  #  #
  ####",

"   ##########
   #..  #   #
   #..      #
   #..  #  ####
  #######  #  ##
  #            #
  #  #  ##  #  #
#### ##  #### ##
#  o  ##### #  #
# # o  o  # o  #
# \@o  o   #   ##
#### ## #######
   #    #
   ######",

"     ###########
     #  .  #   #
     # #.    \@ #
 ##### ##..# ####
##  # ..###     ###
# o #...   o #  o #
#    .. ##  ## ## #
####o##o# o #   # #
  ## #    #o oo # #
  #  o # #  # o## #
  #               #
  #  ###########  #
  ####         ####",

"  ######
  #   \@####
##### o   #
#   ##    ####
# o #  ##    #
# o #  ##### #
## o  o    # #
## o o ### # #
## #  o  # # #
## # #o#   # #
## ###   # # ######
#  o  #### # #....#
#    o    o   ..#.#
####o  o# o   ....#
#       #  ## ....#
###################",

"    ##########
#####        ####
#     #   o  #\@ #
# #######o####  ###
# #    ## #  #o ..#
# # o     #  #  #.#
# # o  #     #o ..#
# #  ### ##     #.#
# ###  #  #  #o ..#
# #    #  ####  #.#
# #o   o  o  #o ..#
#    o # o o #  #.#
#### o###    #o ..#
   #    oo ###....#
   #      ## ######
   ########",

"#########
#       #
#       ####
## #### #  #
## #\@##    #
# ooo o  oo#
#  # ## o  #
#  # ##  o ####
####  ooo o#  #
 #   ##   ....#
 # #   # #.. .#
 #   # # ##...#
 ##### o  #...#
     ##   #####
      #####",

"######     ####
#    #######  #####
#   o#  #  o  #   #
#  o  o  o # o o  #
##o o   # \@# o    #
#  o ########### ##
# #   #.......# o#
# ##  # ......#  #
# #   o........o #
# # o #.... ..#  #
#  o o####o#### o#
# o   ### o   o  ##
# o     o o  o    #
## ###### o ##### #
#         #       #
###################",

"    #######
    #  #  ####
##### o#o #  ##
#.. #  #  #   #
#.. # o#o #  o####
#.  #     #o  #  #
#..   o#  # o    #
#..\@#  #o #o  #  #
#.. # o#     o#  #
#.. #  #oo#o  #  ##
#.. # o#  #  o#o  #
#.. #  #  #   #   #
##. ####  #####   #
 ####  ####   #####",

"###############
#..........  .####
#..........oo.#  #
###########o #   ##
#      o  o     o #
## ####   #  o #  #
#      #   ##  # ##
#  o#  # ##  ### ##
# o #o###    ### ##
###  o #  #  ### ##
###    o ## #  # ##
 # o  #  o  o o   #
 #  o  o#ooo  #   #
 #  #  o      #####
 # \@##  #  #  #
 ##############",

"####
#  ##############
#  #   ..#......#
#  # # ##### ...#
##o#    ........#
#   ##o######  ####
# o #     ######\@ #
##o # o   ######  #
#  o #ooo##       #
#      #    #o#o###
# #### #ooooo    #
# #    o     #   #
# #   ##        ###
# ######o###### o #
#        #    #   #
##########    #####",

" #######
 #  #  #####
##  #  #...###
#  o#  #...  #
# o #oo ...  #
#  o#  #... .#
#   # o########
##o       o o #
##  #  oo #   #
 ######  ##oo\@#
      #      ##
      ########",

" #################
 #...   #    #   ##
##.....  o## # #o #
#......#  o  #    #
#......#  #  # #  #
######### o  o o  #
  #     #o##o ##o##
 ##   o    # o    #
 #  ## ### #  ##o #
 # o oo     o  o  #
 # o    o##o ######
 #######  \@ ##
       ######",

"         #####
     #####   #
    ## o  o  ####
##### o  o o ##.#
#       oo  ##..#
#  ###### ###.. #
## #  #    #... #
# o   #    #... #
#\@ #o ## ####...#
####  o oo  ##..#
   ##  o o  o...#
    # oo  o #  .#
    #   o o  ####
    ######   #
         #####",

"#####
#   ##
# o  #########
## # #       ######
## #   o#o#\@  #   #
#  #      o #   o #
#  ### ######### ##
#  ## ..*..... # ##
## ## *.*..*.* # ##
# o########## ##o #
#  o   o  o    o  #
#  #   #   #   #  #
###################",

"       ###########
       #   #     #
#####  #     o o #
#   ##### o## # ##
# o ##   # ## o  #
# o  \@oo # ##ooo #
## ###   # ##    #
## #   ### #####o#
## #     o  #....#
#  ### ## o #....##
# o   o #   #..o. #
#  ## o #  ##.... #
#####   ######...##
    #####    #####",

"  ####
  #  #########
 ##  ##  #   #
 #  o# o\@o   ####
 #o  o  # o o#  ##
##  o## #o o     #
#  #  # #   ooo  #
# o    o  o## ####
# o o #o#  #  #
##  ###  ###o #
 #  #....     #
 ####......####
   #....####
   #...##
   #...#
   #####",

"      ####
  #####  #
 ##     o#
## o  ## ###
#\@o o # o  #
#### ##   o#
 #....#o o #
 #....#   o#
 #....  oo ##
 #... # o   #
 ######o o  #
      #   ###
      #o ###
      #  #
      ####",

" ###########
 #     ##  #
 #   o   o #
#### ## oo #
#   o #    #
# ooo # ####
#   # # o ##
#  #  #  o #
# o# o#    #
#   ..# ####
####.. o #\@#
#.....# o# #
##....#  o #
 ##..##    #
  ##########",

" #########
 #....   ##
 #.#.#  o ##
##....# # \@##
# ....#  #  ##
#     #o ##o #
## ###  o    #
 #o  o o o#  #
 # #  o o ## #
 #  ###  ##  #
 #    ## ## ##
 #  o #  o  #
 ###o o   ###
   #  #####
   ####",

"############ ######
#   #    # ###....#
#   oo#   \@  .....#
#   # ###   # ....#
## ## ###  #  ....#
 # o o     # # ####
 #  o o##  #      #
#### #  #### # ## #
#  # #o   ## #    #
# o  o  # ## #   ##
# # o o    # #   #
#  o ## ## # #####
# oo     oo  #
## ## ### o  #
 #    # #    #
 ###### ######",

"            #####
#####  ######   #
#   ####  o o o #
# o   ## ## ##  ##
#   o o     o  o #
### o  ## ##     ##
  # ##### #####oo #
 ##o##### \@##     #
 # o  ###o### o  ##
 # o  #   ###  ###
 # oo o #   oo #
 #     #   ##  #
 #######.. .###
    #.........#
    #.........#
    ###########",

"###########
#......   #########
#......   #  ##   #
#..### o    o     #
#... o o #   ##   #
#...#o#####    #  #
###    #   #o  #o #
  #  oo o o  o##  #
  #  o   #o#o ##o #
  ### ## #    ##  #
   #  o o ## ######
   #    o  o  #
   ##   # #   #
    #####\@#####
        ###",

"      ####
####### \@#
#     o  #
#   o## o#
##o#...# #
 # o...  #
 # #. .# ##
 #   # #o #
 #o  o    #
 #  #######
 ####",

"             ######
 #############....#
##   ##     ##....#
#  oo##  o \@##....#
#      oo o#  ....#
#  o ## oo # # ...#
#  o ## o  #  ....#
## ##### ### ##.###
##   o  o ##   .  #
# o###  # ##### ###
#   o   #       #
#  o #o o o###  #
# ooo# o   # ####
#    #  oo #
######   ###
     #####",

"    ############
    #          ##
    #  # #oo o  #
    #o #o#  ## \@#
   ## ## # o # ##
   #   o #o  # #
   #   # o   # #
   ## o o   ## #
   #  #  ##  o #
   #    ## oo# #
######oo   #   #
#....#  ########
#.#... ##
#....   #
#....   #
#########",

"           #####
          ##   ##
         ##     #
        ##  oo  #
       ## oo  o #
       # o    o #
####   #   oo #####
#  ######## ##    #
#.            ooo\@#
#.# ####### ##   ##
#.# #######. #o o##
#........... #    #
##############  o #
             ##  ##
              ####",

"     ########
  ####      ######
  #    ## o o   \@#
  # ## ##o#o o o##
### ......#  oo ##
#   ......#  #   #
# # ......#o  o  #
# #o...... oo# o #
#   ### ###o  o ##
###  o  o  o  o #
  #  o  o  o  o #
  ######   ######
       #####",

"        #######
    #####  #  ####
    #   #   o    #
 #### #oo ## ##  #
##      # #  ## ###
#  ### o#o  o  o  #
#...    # ##  #   #
#...#    \@ # ### ##
#...#  ###  o  o  #
######## ##   #   #
          #########",

" #####
 #   #
 # # #######
 #      o\@######
 # o ##o ###   #
 # #### o    o #
 # ##### #  #o ####
##  #### ##o      #
#  o#  o  # ## ## #
#         # #...# #
######  ###  ...  #
     #### # #...# #
          # ### # #
          #       #
          #########",

"##### ####
#...# #  ####
#...###  o  #
#....## o  o###
##....##   o  #
###... ## o o #
# ##    #  o  #
#  ## # ### ####
# o # #o  o    #
#  o \@ o    o  #
#   # o oo o ###
#  ######  ###
# ##    ####
###",

"##########
#        ####
# ###### #  ##
# # o o o  o #
#       #o   #
###o  oo#  ###
  #  ## # o##
  ##o#   o \@#
   #  o o ###
   # #   o  #
   # ##   # #
  ##  ##### #
  #         #
  #.......###
  #.......#
  #########",

"         ####
 #########  ##
##  o      o #####
#   ## ##   ##...#
# #oo o oo#o##...#
# #   \@   #   ...#
#  o# ###oo   ...#
# o  oo  o ##....#
###o       #######
  #  #######
  ####",

"  #########
  #*.*#*.*#
  #.*.*.*.#
  #*.*.*.*#
  #.*.*.*.#
  #*.*.*.*#
  ###   ###
    #   #
###### ######
#           #
# o o o o o #
## o o o o ##
 #o o o o o#
 #   o\@o   #
 #  #####  #
 ####   ####",

"       ####
       #  ##
       #   ##
       # oo ##
     ###o  o ##
  ####    o   #
###  # #####  #
#    # #....o #
# #   o ....# #
#  o # #.*..# #
###  #### ### #
  #### \@o  ##o##
     ### o     #
       #  ##   #
       #########",

"      ############
     ##..    #   #
    ##..* o    o #
   ##..*.# # # o##
   #..*.# # # o  #
####...#  #    # #
#  ## #          #
# \@o o ###  #   ##
# o   o   # #   #
###oo   # # # # #
  #   o   # # #####
  # o# #####      #
  #o   #   #    # #
  #  ###   ##     #
  #  #      #    ##
  ####      ######",

"########
#  .   #
#  o   #
#. o \@ #
#  o   #
#  .   #
########"
       ]
    end
  end
end

