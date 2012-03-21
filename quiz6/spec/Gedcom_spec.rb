require '/home/bstarr/Ruby-Quizzes-New/quiz6/Gedcom.rb'

describe "Gedcom" do
  before :each do
  end
  it 'should read in a file' do
    gedcom = RubyQuiz::Gedcom.new("/home/bstarr/Ruby-Quizzes-New/quiz6/files/1")
    gedcom.print_xml().should == %q{
<gedcom>
  <indi id="@I1@">
    <name value="Jamis Gordon /Buck/">
      <surn>Buck</surn>
      <givn>Jamis Gordon</givn>
    </name>
    <sex>M</sex>
  </indi>
</gedcom>}
  end
end
