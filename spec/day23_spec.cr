require "./spec_helper"

describe AdventOfCode2021 do
  it "day23 should work" do
    str = <<-INPUT
INPUT
    input = AdventOfCode2021::Day23.parse_input(str)
    AdventOfCode2021::Day23.solution1(input).should eq(0)
    AdventOfCode2021::Day23.solution2(input).should eq(0)
  end
end
