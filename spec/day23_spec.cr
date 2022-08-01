require "./spec_helper"

alias Burrow=AdventOfCode2021::Day23::Burrow;

describe AdventOfCode2021, focus: true do
  it "day23 should work" do
  input = <<-INPUT
#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
INPUT
    burrow = Burrow.new(input)
    burrow.solve1.should eq(12521)
    burrow.solve2.should eq(0)
  end
end
