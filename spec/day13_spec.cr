require "./spec_helper"

describe AdventOfCode2021 do
  it "day13 should work" do
    str = <<-INPUT
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
INPUT
    paper = AdventOfCode2021::Day13::ElvesCameraManual.new str
    paper.do_folding_one.should eq 17
    # AdventOfCode2021::Day13.solution1(input).should eq(17)
    # AdventOfCode2021::Day13.solution2(input).should eq(0)
  end
end
