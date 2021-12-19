require "./spec_helper"

alias SailfishNumber=AdventOfCode2021::Day18::SailfishNumber

describe AdventOfCode2021 do


  it "parsing of sailfish numbers as a tree structure should give the input" do
    input1 = "[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]"
    sn1 = SailfishNumber.new input1
    sn1.to_s.should eq(input1)

    input2 = "[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]"
    sn2 = SailfishNumber.new input2
    sn2.to_s.should eq(input2)
  end

  it "two sailfish number equals if there are the same numbers in them"  do
    inputs = ["[1, 2]", "[[3, 4], 5]", "[[1, 2], [[3, 4], 5]]", "[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]"]
    inputs.each do |str|
      SailfishNumber.new(str).should eq(SailfishNumber.new(str))
    end
  end

  it "adding sailfish numbers should give the reduced result" do
    sn1 = SailfishNumber.new "[1, 2]"
    sn2 = SailfishNumber.new "[[3, 4], 5]"
    sn3 = SailfishNumber.new "[[1, 2], [[3, 4], 5]]"
    (sn1 + sn2).should eq(sn3)

  end

  it "exploding pairs (reducing) of SailfishNumber examples should work", focus: true do
    sn = SailfishNumber.new("[[[[[9,8],1],2],3],4]")
    sn.reduce.should eq (SailfishNumber.new("[[[[0,9],2],3],4]"))

    sn = SailfishNumber.new("[7,[6,[5,[4,[3,2]]]]]")
    sn.reduce.should eq (SailfishNumber.new("[7,[6,[5,[7,0]]]]"))

    sn = SailfishNumber.new("[[6,[5,[4,[3,2]]]],1]")
    sn.reduce.should eq (SailfishNumber.new("[[6,[5,[7,0]]],3]"))

    sn = SailfishNumber.new("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")
    sn.reduce.should eq (SailfishNumber.new("[[3,[2,[8,0]]],[9,[5,[7,0]]]]"))  
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
