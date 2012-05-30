require '/home/bstarr/Ruby-Quizzes-New/quiz10/Crosswords.rb';

describe "Crosswords" do
  before :each do
  end

  it 'Should solve simple example' do
    crossword = RubyQuiz::Crosswords.new( 'simple_example' )
    crossword.print_crossword
    crossword.output_sting.should == 
"################\n" +
"#1   #    #2   #\n" +
"#    #    #    #\n" +
"################\n" +
"#    ######    #\n" +
"#    ######    #\n" +
"################\n" +
"#3   #    #    #\n" +
"#    #    #    #\n" +
"################\n";
  end

#  it 'Should solve large example' do
#    crossword = RubyQuiz::Crosswords.new( 'large_example' )
#    crossword.print_crossword
#    crossword.output_sting.should == 
#"     #####################          \n" +
#"     #1   #    #2   #3   #          \n" +
#"     #    #    #    #    #          \n" +
#"####################################\n" +
#"#4   #    ######5   #    #6   #7   #\n" +
#"#    #    ######    #    #    #    #\n" +
#"####################################\n" +
#"#8   #    #9   #    #    #10  #    #\n" +
#"#    #    #    #    #    #    #    #\n" +
#"#####################    ###########\n" +
#"#    ######11  #    #               \n" +
#"#    ######    #    #               \n" +
#"####################################\n" +
#"#12  #13  #    ######14  #15  #    #\n" +
#"#    #    #    ######    #    #    #\n" +
#"####################################\n" +
#"     #16  #    #    #    #    #     \n" +
#"     #    #    #    #    #    #     \n" +
#"     ##########################     \n";
#  end

end
