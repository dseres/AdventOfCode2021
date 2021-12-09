require "./spec_helper"

describe AdventOfCode2021 do
  it "day9 should work" do
    str = "2199943210
3987894921
9856789892
8767896789
9899965678"
    input = AdventOfCode2021::Day9.parse_input(str)
    AdventOfCode2021::Day9.solution1(input).should eq(15)
    AdventOfCode2021::Day9.solution2(input).should eq(1134)
  end
end
