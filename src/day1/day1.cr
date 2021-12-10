# TODO: Write documentation for `AdventOfCode2021`
module AdventOfCode2021
  module Day1
    extend self

    DAY = 1

    def parse_input(input : String) : Array(Int32)
      input.lines.map &.to_i32
    end

    def self.solution1(input : Array(Int32)) : Int32
      count = 0
      (1...input.size).each do |i|
        if input[i - 1] < input[i]
          count += 1
        end
      end
      count
    end

    def self.solution2(input : Array(Int32)) : Int32
      count = 0
      (1..(input.size - 3)).each do |i|
        if input[i - 1, 3].sum < input[i, 3].sum
          count += 1
        end
        # puts "#{input[i-1,3].sum} < #{input[i,3].sum} , count: #{input[i-1,3].sum < input[i,3].sum}"
      end
      count
    end

    def main
      input = parse_input File.read "./src/day#{DAY}/input.txt"
      puts "Solutions of day#{DAY} : #{solution1 input} #{solution2 input}"
    end
  end
end
