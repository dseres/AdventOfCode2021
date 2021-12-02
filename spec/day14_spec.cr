require "./spec_helper"

describe AdventOfCode2021 do

  it "day14 should work" do
    str = ""
    input = AdventOfCode2021::Day14.parse_input(str)
    AdventOfCode2021::Day14.solution1(input).should eq(0)
    AdventOfCode2021::Day14.solution2(input).should eq(0)
  end
end
