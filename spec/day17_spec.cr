require "./spec_helper"

describe AdventOfCode2021 do
  it "day17 should work", focus: true do
    str = "target area: x=20..30, y=-10..-5"
    AdventOfCode2021::Day17.solutions(str).should eq({45, 112})
  end
end
