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

  it 'Should solve large email example' do
    filter = RubyQuiz::LanguageFilter.new "sixish", "aeromancer"

    file = File.open("/home/bstarr/Ruby-Quizzes-New/quiz9/spec/english-words.95", "rb")
    contents = file.read
    words_in_email = contents.split("\r\n")

    banned = RubyQuiz::BannedWords.new( words_in_email, filter )
    banned.banned_words.sort.should == [ "aeromancer", "sixish" ]
  end

  it 'Should solve large banned example' do
    file = File.open("/home/bstarr/Ruby-Quizzes-New/quiz9/spec/english-words.95", "rb")
    contents = file.read
    words_to_ban = contents.split("\r\n")

    filter = RubyQuiz::LanguageFilter.new words_to_ban

    banned = RubyQuiz::BannedWords.new( ["aeromancer"], filter )
    banned.banned_words.sort.should == [ "aeromancer" ]
  end

end
