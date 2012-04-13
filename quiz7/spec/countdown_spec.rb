require '/home/bstarr/Ruby-Quizzes-New/quiz7/CountDown.rb'

describe "Countdown" do
  before :each do
  end
  it 'Should solve easy example' do
    countdown = RubyQuiz::CountDown.new("1,2,4", "7")
    countdown.find_solution()
    eval(countdown.closest_solution).should == 7
  end
  it 'Should solve easy example 2' do
    countdown = RubyQuiz::CountDown.new("1,2,3", "7")
    countdown.find_solution()
    eval(countdown.closest_solution).should == 7
  end
#  it 'Should solve example given in quiz' do
#    countdown = RubyQuiz::CountDown.new("100,5,5,2,6,8", "522")
#    countdown.find_solution()
#    eval(countdown.closest_solution).should == 522
#  end
  it 'Should get closest solution' do
    countdown = RubyQuiz::CountDown.new("1,2,8", "22")
    countdown.find_solution()
    eval(countdown.closest_solution).should == 24
  end
end
