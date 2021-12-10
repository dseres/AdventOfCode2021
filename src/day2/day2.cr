module AdventOfCode2021
  module Day2
    extend self

    DAY = 2

    enum Direction
      Forward
      Down
      Up
    end

    def parse_input(input : String) : Array(Tuple(Direction, Int32))
      parsed = [] of Tuple(Direction, Int32)
      input.each_line do |line|
        str1, str2 = line.split
        dir = Direction.parse str1
        i = str2.to_i32
        parsed << {dir, i}
      end
      parsed
    end

    def solution1(input : Array(Tuple(Direction, Int32))) : Int32
      dist_x = 0
      dist_y = 0
      input.each do |dir, dist|
        case dir
        when Direction::Forward
          dist_x += dist
        when Direction::Down
          dist_y += dist
        else
          dist_y -= dist
        end
        # puts "#{dir} #{dist} #{dist_x} #{dist_y}"
      end
      dist_x * dist_y
    end

    def solution2(input : Array(Tuple(Direction, Int32))) : Int32
      dist_x = 0
      dist_y = 0
      aim = 0
      input.each do |dir, dist|
        case dir
        when Direction::Forward
          dist_x += dist
          dist_y += aim * dist
        when Direction::Down
          aim += dist
        else
          aim -= dist
        end
      end
      dist_x * dist_y
    end

    def main
      input = parse_input File.read "./src/day#{DAY}/input.txt"
      puts "Solutions of day#{DAY} : #{solution1 input} #{solution2 input}"
    end
  end
end
