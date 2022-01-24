module AdventOfCode2021
  module Day22
    extend self

    DAY = 22

    enum Operation
      On
      Off
    end

    class Cuboid
      property op : Operation
      property x_range : Range(Int32, Int32)
      property y_range : Range(Int32, Int32)
      property z_range : Range(Int32, Int32)

      def initialize(@op, @x_range, @y_range, @z_range); end

      def initialize(str : String)
        str =~ /^(on|off) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)$/
        op = Operation.parse $~[1]
        x1 = $~[2].to_i32
        x2 = $~[3].to_i32
        y1 = $~[4].to_i32
        y2 = $~[5].to_i32
        z1 = $~[6].to_i32
        z2 = $~[7].to_i32
        initialize(op, (x1..x2), (y1..y2), (z1..z2))
      end
    end

    def parse_input(input : String) : Array(Cuboid)
      input.lines.map { |line| Cuboid.new(line) }
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
