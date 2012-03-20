require '/home/bstarr/Ruby-Quizzes-New/quiz6/Gedcom.rb'

describe "Gedcom" do
  it 'should read in a file' do
    gedcom = RubyQuiz::Gedcom.new("/home/bstarr/Ruby-Quizzes-New/quiz6/1")

    givn = RubyQuiz::GedcomTreeItem.new(2, 'GIVN', 'Jamis Gordon')
    surn = RubyQuiz::GedcomTreeItem.new(2, 'SURN', 'Buck')
    name = RubyQuiz::GedcomTreeItem.new(1, 'NAME', 'Jamis Gordon /Buck/')
    name.add_child(surn)
    name.add_child(name)
    sex = RubyQuiz::GedcomTreeItem.new(1, 'SEX', 'M');
    indi = RubyQuiz::GedcomTreeItem.new(0, 'INDI', '@I1')
    indi.add_child(name)
    indi.add_child(sex)

    gedcom.tree().should == [ indi ]
  end

  it 'should print XML' do
    gedcom = RubyQuiz::Gedcom.new("/home/bstarr/Ruby-Quizzes-New/quiz6/1")
    gedcom.print_xml().should == << HERE
<gedcom>
  <indi id="@I1@">
    <name value="Jamis Gordon /Buck/">
      <surn>Buck</surn>
      <givn>Jamis Gordon</givn>
    </name>
    <sex>M</sex>
  </indi>
</gedcom>
HERE
  end
end
