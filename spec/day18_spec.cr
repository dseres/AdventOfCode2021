require "./spec_helper"

alias SailfishNumber = AdventOfCode2021::Day18::SailfishNumber

describe AdventOfCode2021 do
  it "parsing of sailfish numbers as a tree structure should give the input" do
    input1 = "[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]"
    sn1 = SailfishNumber.new input1
    sn1.to_s.should eq(input1)

    input2 = "[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]"
    sn2 = SailfishNumber.new input2
    sn2.to_s.should eq(input2)
  end

  it "two sailfish number equals if there are the same numbers in them" do
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

  it "exploding pairs (reducing) of SailfishNumber examples should work" do
    sn = SailfishNumber.new("[[[[[9,8],1],2],3],4]")
    sn.reduce.should eq(SailfishNumber.new("[[[[0,9],2],3],4]"))

    sn = SailfishNumber.new("[7,[6,[5,[4,[3,2]]]]]")
    sn.reduce.should eq(SailfishNumber.new("[7,[6,[5,[7,0]]]]"))

    sn = SailfishNumber.new("[[6,[5,[4,[3,2]]]],1]")
    sn.reduce.should eq(SailfishNumber.new("[[6,[5,[7,0]]],3]"))

    sn = SailfishNumber.new("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")
    sn.reduce.should eq(SailfishNumber.new("[[3,[2,[8,0]]],[9,[5,[7,0]]]]"))
  end

  it "splitting should work" do
    sn = SailfishNumber.new("[11,1]")
    sn.reduce.should eq(SailfishNumber.new("[[5,6],1]"))

    sn = SailfishNumber.new("[1,18]")
    sn.reduce.should eq(SailfishNumber.new("[1,[9,9]]"))

    sn = SailfishNumber.new("[1,11]")
    sn.reduce.should eq(SailfishNumber.new("[1,[5,6]]"))

    sn = SailfishNumber.new("[1,9]")
    sn.reduce.should eq(SailfishNumber.new("[1,9]"))
  end

  it "addition example should work" do
    sn1 = SailfishNumber.new("[[[[4,3],4],4],[7,[[8,4],9]]]")
    sn2 = SailfishNumber.new("[1,1]")
    sn3 = SailfishNumber.new("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")
    (sn1 + sn2).should eq(sn3)
  end

  it "summary should work" do
    str = <<-INPUT
[1,1]
[2,2]
[3,3]
[4,4]
INPUT
    numbers = AdventOfCode2021::Day18.parse_input(str)
    numbers.sum.should eq(SailfishNumber.new("[[[[1,1],[2,2]],[3,3]],[4,4]]"))

    str = <<-INPUT
[1,1]
[2,2]
[3,3]
[4,4]
[5,5]
INPUT
    numbers = AdventOfCode2021::Day18.parse_input(str)
    numbers.sum.should eq(SailfishNumber.new("[[[[3,0],[5,3]],[4,4]],[5,5]]"))

    str = <<-INPUT
[1,1]
[2,2]
[3,3]
[4,4]
[5,5]
[6,6]
INPUT
    numbers = AdventOfCode2021::Day18.parse_input(str)
    numbers.sum.should eq(SailfishNumber.new("[[[[5,0],[7,4]],[5,5]],[6,6]]"))
  end

  it "example from reddit should work" do
    (SailfishNumber.new("[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]") \
      + SailfishNumber.new("[7,[5,[[3,8],[1,4]]]]")).should \
        eq(SailfishNumber.new("[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]"))
  end

  it "first complex example of day18 should work" do
    (SailfishNumber.new("[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]") + SailfishNumber.new("[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]")).should eq SailfishNumber.new("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]")
    (SailfishNumber.new("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]") + SailfishNumber.new("[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]")).should eq SailfishNumber.new("[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]")
    (SailfishNumber.new("[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]") + SailfishNumber.new("[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]")).should eq SailfishNumber.new("[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]")
    (SailfishNumber.new("[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]") + SailfishNumber.new("[7,[5,[[3,8],[1,4]]]]")).should eq SailfishNumber.new("[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]")
    (SailfishNumber.new("[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]") + SailfishNumber.new("[[2,[2,2]],[8,[8,1]]]")).should eq SailfishNumber.new("[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]")
    (SailfishNumber.new("[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]") + SailfishNumber.new("[2,9]")).should eq SailfishNumber.new("[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]")
    (SailfishNumber.new("[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]") + SailfishNumber.new("[1,[[[9,3],9],[[9,0],[0,7]]]]")).should eq SailfishNumber.new("[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]")
    (SailfishNumber.new("[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]") + SailfishNumber.new("[[[5,[7,4]],7],1]")).should eq SailfishNumber.new("[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]")
    (SailfishNumber.new("[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]") + SailfishNumber.new("[[[[4,2],2],6],[8,7]]")).should eq SailfishNumber.new("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")
  end

  it "complex examples of day18 should work" do
    str = <<-INPUT
[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]
INPUT
    numbers = AdventOfCode2021::Day18.parse_input(str)
    sum = SailfishNumber.new("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")
    # puts numbers.sum
    numbers.sum.should eq(sum)
    AdventOfCode2021::Day18.solution1(numbers).should eq(3488)

    str = <<-INPUT
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
INPUT
    numbers = AdventOfCode2021::Day18.parse_input(str)
    sum = SailfishNumber.new("[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]")
    numbers.sum.should eq(sum)
  end

  it "Answer for the example of second question should be true" do
    str = <<-INPUT
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
INPUT
    numbers = AdventOfCode2021::Day18.parse_input(str)
    AdventOfCode2021::Day18.solution2(numbers).should eq(3993)
  end
end
