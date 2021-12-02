module AdventOfCode2021
  module Day3
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

content = File.read "./src/day3/input.txt"
input = AdventOfCode2021::Day3.parse_input content
puts AdventOfCode2021::Day3.solution1 input
puts AdventOfCode2021::Day3.solution2 input
