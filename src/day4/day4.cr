module AdventOfCode2021
  module Day4
    extend self

    def parse_input(input : String) : Array(String)
      input.lines
    end

    def solution1(input) : Int32
      0
    end

    def solution2(input) : Int32
      0
    end
  end
end

content = File.read "./src/day4/input.txt"
input = AdventOfCode2021::Day4.parse_input content
puts AdventOfCode2021::Day4.solution1 input
puts AdventOfCode2021::Day4.solution2 input
