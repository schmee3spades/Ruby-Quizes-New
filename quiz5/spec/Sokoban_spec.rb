require '/home/bstarr/Ruby-Quizzes-New/quiz5/Sokoban.rb'

describe "Sokoban" do
  it 'should read in a puzzle into a matrix' do
    game = RubyQuiz::Sokoban.new(
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
    #######
"    )
    game.puzzle_matrix().should ==
    [
        [ ' ', ' ', ' ', ' ', '#', '#', '#', '#', '#', ],
        [ ' ', ' ', ' ', ' ', '#', ' ', ' ', ' ', '#', ],
        [ ' ', ' ', ' ', ' ', '#', 'o', ' ', ' ', '#', ],
        [ ' ', ' ', '#', '#', '#', ' ', ' ', 'o', '#', '#', ],
        [ ' ', ' ', '#', ' ', ' ', 'o', ' ', 'o', ' ', '#', ],
        [ '#', '#', '#', ' ', '#', ' ', '#', '#', ' ', '#', ' ', ' ', ' ', '#', '#', '#', '#', '#', '#', ],
        [ '#', ' ', ' ', ' ', '#', ' ', '#', '#', ' ', '#', '#', '#', '#', '#', ' ', ' ', '.', '.', '#', ],
        [ '#', ' ', 'o', ' ', ' ', 'o', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '.', '.', '#', ],
        [ '#', '#', '#', '#', '#', ' ', '#', '#', '#', ' ', '#', '@', '#', '#', ' ', ' ', '.', '.', '#', ],
        [ ' ', ' ', ' ', ' ', '#', ' ', ' ', ' ', ' ', ' ', '#', '#', '#', '#', '#', '#', '#', '#', '#', ],
        [ ' ', ' ', ' ', ' ', '#', '#', '#', '#', '#', '#', '#', ],
    ]
    game.person_position().should == [8,11]
  end

  it 'should error if no person' do
    maze = RubyQuiz::Sokoban.new(
"#####
#   #
# o.#
#####"
    )
    maze.error_message.should == 'Maze does not have person';
    maze = RubyQuiz::Sokoban.new(
"#####
#   #
#o\@+#
#####")
    maze.puzzle_matrix().should ==
    [
        [ '#', '#', '#', '#', '#', ],
        [ '#', ' ', ' ', ' ', '#', ],
        [ '#', 'o', '@', '+', '#', ],
        [ '#', '#', '#', '#', '#', ],
    ]
    maze.person_position().should == [2,2]
  end

  it 'should error if not equal number of crates and storage' do
    maze = RubyQuiz::Sokoban.new(
"#####
#*o #
#+ .#
#####")
    maze.error_message.should == 'Maze does not have equal number of crates and storage';
  end

  it 'should not allow move into stuck crate or wall' do
    maze = RubyQuiz::Sokoban.new(
"######
#*   #
#\@oo.#
######")
    maze.move('up')
    maze.error_message.should == 'can not move crate';
    maze.person_position().should == [2,1]
    maze.move('right')
    maze.error_message.should == 'can not move crate';
    maze.person_position().should == [2,1]
    maze.move('down')
    maze.error_message.should == 'can not move into wall';
    maze.person_position().should == [2,1]
  end

  it 'should move a crate' do
    maze = RubyQuiz::Sokoban.new(
"######
#\@o .#
######")
    maze.puzzle_matrix().should ==
    [
        [ '#', '#', '#', '#', '#', '#', ],
        [ '#', '@', 'o', ' ', '.', '#', ],
        [ '#', '#', '#', '#', '#', '#', ],
    ]
    maze.person_position().should == [1,1]
    maze.move('right')
    maze.puzzle_matrix().should ==
    [
        [ '#', '#', '#', '#', '#', '#', ],
        [ '#', ' ', '@', 'o', '.', '#', ],
        [ '#', '#', '#', '#', '#', '#', ],
    ]
    maze.person_position().should == [1,2]
    maze.move('right')
    maze.puzzle_matrix().should ==
    [
        [ '#', '#', '#', '#', '#', '#', ],
        [ '#', ' ', ' ', '@', '*', '#', ],
        [ '#', '#', '#', '#', '#', '#', ],
    ]
    maze.person_position().should == [1,3]
  end

  it 'should represent man on storage' do
    maze = RubyQuiz::Sokoban.new(
"######
#.\@o #
######")
    maze.move('left')
    maze.puzzle_matrix().should ==
    [
        [ '#', '#', '#', '#', '#', '#', ],
        [ '#', '+', ' ', 'o', ' ', '#', ],
        [ '#', '#', '#', '#', '#', '#', ],
    ]
    maze.person_position().should == [1,1]
  end

  it 'should say that user wins' do
    maze = RubyQuiz::Sokoban.new(
"######
# \@o.#
######")
    maze.move('right')
    maze.puzzle_matrix().should ==
    [
        [ '#', '#', '#', '#', '#', '#', ],
        [ '#', ' ', ' ', '@', '*', '#', ],
        [ '#', '#', '#', '#', '#', '#', ],
    ]
    maze.person_position().should == [1,3]
    maze.error_message.should == 'You Win!';
  end
end
