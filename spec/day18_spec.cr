require "./spec_helper"

alias SailfishNumber=AdventOfCode2021::Day18::SailfishNumber

describe AdventOfCode2021 do


  it "parsing of sailfish numbers as a tree structure should give the input", focus: true do
    input1 = "[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]"
    sn1 = SailfishNumber.new input1
    sn1.to_s.should eq(input1)

    input2 = "[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]"
    sn2 = SailfishNumber.new input2
    sn2.to_s.should eq(input2)
  end

  it "adding sailfish numbers should give the reduced result", focus: true do
    sn1 = SailfishNumber.new "[1, 2]"
    sn2 = SailfishNumber.new "[[3, 4], 5]"
    sn3 = SailfishNumber.new "[[1, 2], [[3, 4], 5]]"
    (sn1 + sn2).should eq(sn3)
  end

  it "day18 should work" do
    # alias SailfishNumber = SailfishNumber
    # SailfishNumber.new("[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]").should eq SailfishNumber.new([[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]])
    # (SailfishNumber.new([1,2]) + SailfishNumber.new([[3,4],5])).should eq  SailfishNumber.new([[1,2],[[3,4],5]])

    str = <<-INPUT
INPUT
    input = AdventOfCode2021::Day18.parse_input(str)
    AdventOfCode2021::Day18.solution1(input).should eq(0)
    AdventOfCode2021::Day18.solution2(input).should eq(0)
  end
end
