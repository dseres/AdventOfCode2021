require "./spec_helper"

describe AdventOfCode2021 do
  it "day5 should work" do
    str = "0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"
    output_matrix = ".......1..
..1....1..
..1....1..
.......1..
.112111211
..........
..........
..........
..........
222111...."
    input = AdventOfCode2021::Day5.parse_input(str)
    matrix = AdventOfCode2021::Day5.create_matrix(input)
    puts matrix
    AdventOfCode2021::Day5.print_matrix(matrix).should eq(output_matrix)
    AdventOfCode2021::Day5.solution1(input).should eq(5)
    AdventOfCode2021::Day5.solution2(input).should eq(0)
  end
end
