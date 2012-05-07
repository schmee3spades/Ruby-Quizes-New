require '/home/bstarr/Ruby-Quizzes-New/quiz9/BannedWords.rb'
require '/home/bstarr/Ruby-Quizzes-New/quiz9/LanguageFilter.rb'

describe "BannedWords" do
  before :each do
  end
  it 'Should solve example' do
    filter = RubyQuiz::LanguageFilter.new "six"
    banned = RubyQuiz::BannedWords.new( ["foo", "bar", "six", "baz"], filter )
    banned.banned_words.should == ["six"]
  end

  it 'Should solve example' do
    filter = RubyQuiz::LanguageFilter.new "sixish", "aeromancer"

    file = File.open("/home/bstarr/Ruby-Quizzes-New/quiz9/spec/english-words.95", "rb")
    contents = file.read
    words_in_email = contents.split("\r\n")

    banned = RubyQuiz::BannedWords.new( words_in_email, filter )
    banned.banned_words.sort.should == [ "aeromancer", "sixish" ]
  end

end
