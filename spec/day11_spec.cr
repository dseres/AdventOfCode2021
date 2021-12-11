require "./spec_helper"

describe AdventOfCode2021 do
  it "day11 should work" do
    str = <<-INPUT
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
INPUT
    AdventOfCode2021::Day11.solution1(str).should eq(1656)
    AdventOfCode2021::Day11.solution2(str).should eq(195)
  end

  it "two steps os small example of day11 should work" do
    step0 = <<-INPUT
11111
19991
19191
19991
11111
INPUT
    step1 = <<-INPUT
34543
40004
50005
40004
34543
INPUT
    step2 = <<-INPUT
45654
51115
61116
51115
45654
INPUT
    co0 = AdventOfCode2021::Day11::CavernOfOctopuses.new(step0)
    co1 = AdventOfCode2021::Day11::CavernOfOctopuses.new(step1)
    co2 = AdventOfCode2021::Day11::CavernOfOctopuses.new(step2)
    co0.step.should eq(co1)
    co0.step.should eq(co2)
  end
end
