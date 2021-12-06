require "./spec_helper"

describe AdventOfCode2021 do
  it "day6 should work" do
    str = "3,4,3,1,2"
    fishes = AdventOfCode2021::Day6.parse_input(str)
    AdventOfCode2021::Day6.solution1(fishes).should eq(5934)
    AdventOfCode2021::Day6.solution2(fishes).should eq(26984457539)
  end
end
