require "./spec_helper"

describe AdventOfCode2021 do
  it "day15 should work" do
    input = <<-INPUT
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
INPUT
    cave = AdventOfCode2021::Day15::Cave.new(input)
    cave.solution1.should eq(40)
    cave.solution2.should eq(315)
  end
end
