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
    output_matrix2 = "1.1....11.
.111...2..
..2.1.111.
...1.2.2..
.112313211
...1.2....
..1...1...
.1.....1..
1.......1.
222111...."
    vents = AdventOfCode2021::Day5.parse_input str
    matrix = AdventOfCode2021::Day5.create_matrix vents
    matrix.should eq(Array.new(10, Array.new(10, 0)))

    AdventOfCode2021::Day5.add_horizontal_or_vertiacals matrix, vents
    AdventOfCode2021::Day5.print_matrix(matrix).should eq(output_matrix)
    AdventOfCode2021::Day5.solution1(matrix).should eq(5)

    AdventOfCode2021::Day5.add_diagonals matrix, vents
    AdventOfCode2021::Day5.print_matrix(matrix).should eq(output_matrix2)
    AdventOfCode2021::Day5.solution2(matrix).should eq(12)
  end
end
