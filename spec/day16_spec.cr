require "./spec_helper"

describe AdventOfCode2021 do
  it "day16 should work" do
    str = ""
    input = AdventOfCode2021::Day16.parse_input(str)
    AdventOfCode2021::Day16.solution1(input).should eq(0)
    AdventOfCode2021::Day16.solution2(input).should eq(0)
  end
end
