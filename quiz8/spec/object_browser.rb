require '/home/bstarr/Ruby-Quizzes-New/quiz8/ObjectBrowser.rb'

describe "Browser" do
  before :each do
    object_browser = RubyQuiz::ObjectBrowser.new("RubyQuiz::ObjectBrowser")
  end
  it 'It should create a base object explorer' do
    object_browser.print_tree.should == '
>  root: an ObjectBrowser
'
    object_browser.selector_position.should == 1
  end
  it 'It should expand a tree' do
    object_browser.click
    object_browser.print_tree.should == '
V  root: an ObjectBrowser
>  1: a Number
'
    object_browser.selector_position.should == 1
  end
end
