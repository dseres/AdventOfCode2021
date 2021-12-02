require "./spec_helper"

describe AdventOfCode2021 do

  it "day3 works" do
    str = ""
    input = AdventOfCode2021::Day3.parse_input(str)
    AdventOfCode2021::Day3.solution1(input).should eq(0)
    AdventOfCode2021::Day3.solution2(input).should eq(0)
  end
end
