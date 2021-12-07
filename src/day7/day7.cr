module AdventOfCode2021
  module Day7
    extend self

    NUMBER = 7

    def parse_input(input : String) : Array(Int32)
      input.split(",").map &.to_i32
    end

    def solution1(positions : Array(Int32)) : Int32
      min = positions.min
      max = positions.max
      best_pos = (min..max).min_of do |i|
        positions.sum { |p| (p - i).abs }
      end
      best_pos
    end

    def solution2(positions) : Int32
      min = positions.min
      max = positions.max
      best_pos = (min..max).min_of do |i|
        positions.sum { |p| ((p - i).abs * ((p-i).abs + 1)) // 2}
      end
      best_pos
    end

    def main
      positions = parse_input File.read "./src/day#{NUMBER}/input.txt"
      puts "Solutions of day#{NUMBER} : #{solution1 positions} #{solution2 positions}"
    end
  end
end
