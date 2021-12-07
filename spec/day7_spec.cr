require "./spec_helper"

describe AdventOfCode2021 do
  it "day7 should work" do
    str = "16,1,2,0,4,2,7,1,2,14"
    positions = AdventOfCode2021::Day7.parse_input(str)
    AdventOfCode2021::Day7.solution1(positions).should eq(37)
    AdventOfCode2021::Day7.solution2(positions).should eq(168)
  end
end
