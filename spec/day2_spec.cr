require "./spec_helper"

include AdventOfCode2021::Day2

describe AdventOfCode2021 do
  # TODO: Write tests

  it "day2 works" do
    str =
      "forward 5
down 5
forward 8
up 3
down 8
forward 2"
    input = parse_input(str)
    solution1(input).should eq(150)
    solution2(input).should eq(900)
  end
end
