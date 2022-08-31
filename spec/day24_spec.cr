require "./spec_helper"

describe AdventOfCode2021 do
  it "day24 should work" , focus: true do
    input = File.read "./src/day24/input.txt"
    AdventOfCode2021::Day24.solution1(input).should eq(92969593497992)
    AdventOfCode2021::Day24.solution2(input).should eq(0)
  end
end
