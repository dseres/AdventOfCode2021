require "./spec_helper"

describe AdventOfCode2021 do
  # TODO: Write tests

  it "day1 works" do
    input = "199
200
208
210
200
207
240
269
260
263"
    AdventOfCode2021::Day1.solution1(input).should eq(7)
    AdventOfCode2021::Day1.solution2(input).should eq(5)
  end
end
