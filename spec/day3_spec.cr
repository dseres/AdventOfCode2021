require "./spec_helper"

describe AdventOfCode2021 do
  it "day3 works" do
    str = "00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"
    input = AdventOfCode2021::Day3.parse_input(str)
    AdventOfCode2021::Day3.solution1(input).should eq(198)
    AdventOfCode2021::Day3.solution2(input).should eq(230)
  end
end
