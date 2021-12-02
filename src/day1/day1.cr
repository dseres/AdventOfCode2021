# TODO: Write documentation for `AdventOfCode2021`
module AdventOfCode2021
  module Day1
    def self.solution1(input : String) : Int32
      count = 0
      lines = input.lines.map &.to_i32
      (1...lines.size).each do |i|
        if lines[i - 1] < lines[i]
          count += 1
        end
      end
      count
    end

    def self.solution2(input : String) : Int32
      count = 0
      lines = input.lines.map &.to_i32
      (1..(lines.size - 3)).each do |i|
        if lines[i - 1, 3].sum < lines[i, 3].sum
          count += 1
        end
        # puts "#{lines[i-1,3].sum} < #{lines[i,3].sum} , count: #{lines[i-1,3].sum < lines[i,3].sum}"
      end
      count
    end
  end
end

content = File.read "./src/day1/input.txt"
puts AdventOfCode2021::Day1.solution1 content
puts AdventOfCode2021::Day1.solution2 content
