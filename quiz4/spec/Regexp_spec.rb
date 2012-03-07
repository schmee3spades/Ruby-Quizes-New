require '/home/bstarr/Ruby-Quizzes-New/quiz4/Regexp.rb'

describe "Regexp" do
  it 'should accept lucky numbers' do
    lucky = Regexp.build( 3, 7 )
    ("7"  =~ lucky).should == 0
    ("13" =~ lucky).should == nil
    ("3"  =~ lucky).should == 0
  end

  it 'should accept valid months' do
    month = Regexp.build( 1..12 )
    ("0"  =~ month).should == nil
    ("13" =~ month).should == nil
    ("3"  =~ month).should == 0
  end

  it 'should accept valid days' do
    day = Regexp.build( 1..31 )
    ("6"    =~ day).should == 0
    ("16"   =~ day).should == 0
    ("Tues" =~ day).should == nil
  end

  it 'should accept certain years' do
    year = Regexp.build( 98, 99, 2000..2005 )
    ("04"   =~ year).should == nil
    ("2004" =~ year).should == 0
    ("99"   =~ year).should == 0
  end

  it 'should accept underscores' do
    pos_under_mil = Regexp.build( 0..1_000_000 )
    ("0"       =~ pos_under_mil).should == 0
    ("200400"  =~ pos_under_mil).should == 0
    ("-1"      =~ pos_under_mil).should == nil
    ("1100000" =~ pos_under_mil).should == nil
  end

  it 'should accept underscores' do
    pos_under_mil = Regexp.build( 486..32_345 )
  end

end
