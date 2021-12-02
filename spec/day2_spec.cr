require "./spec_helper"

describe AdventOfCode2021 do

  it "day2 should work" do
    str =
      "forward 5
down 5
forward 8
up 3
down 8
forward 2"
    input = AdventOfCode2021::Day2.parse_input(str)
    AdventOfCode2021::Day2.solution1(input).should eq(150)
    AdventOfCode2021::Day2.solution2(input).should eq(900)
  end
end
