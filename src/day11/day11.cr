module AdventOfCode2021
  module Day11
    extend self

    DAY = 11

    def parse_input(input : String) : Array(String)
      input.lines
    end

    def solution1(input) : Int32
      0
    end

    def solution2(input) : Int32
      0
    end

    def main
      input = parse_input File.read "./src/day#{DAY}/input.txt"
      puts "Solutions of day#{DAY} : #{solution1 input} #{solution2 input}"
    end
  end
end
