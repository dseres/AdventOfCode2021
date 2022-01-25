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
      property x1 : Int32, x2 : Int32, y1 : Int32, y2 : Int32, z1 : Int32, z2 : Int32

      def initialize(@op, @x1, @x2, @y1, @y2, @z1, @z2); end

      def initialize(str : String)
        str =~ /^(on|off) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)$/
        op = Operation.parse $~[1]
        x1 = $~[2].to_i32
        x2 = $~[3].to_i32
        y1 = $~[4].to_i32
        y2 = $~[5].to_i32
        z1 = $~[6].to_i32
        z2 = $~[7].to_i32
        initialize(op, x1, x2, y1, y2, z1, z2)
      end

      def has_intersection?(other : Cuboid) : Bool
        has_intersection(@x1, @x2, other.x1, other.x2) && has_intersection(@y1, @y2, other.y1, other.y2) && has_intersection(@z1, @z2, other.z1, other.z2)
      end

      private def has_intersection?(x1, x2, y1, y2)
        x1 <= y1 && y1 <= x2 || x1 <= y2 && y2 <= y2
      end

      def intersection(other : Cuboid) : Cuboid
        Cuboid.new(other.op, Math.max(@x1, other.x1), Math.min(@x2, other.x2), Math.max(@y1, other.y1), Math.min(@y2, other.y2), Math.max(@z1, other.z1), Math.min(@z2, other.z2))
      end

      def size : Int32
        (@x2 - @x1 + 1) * (@y2 - @y1 + 1) * (@z2 -@z1 + 1)
      end
    end

    def parse_input(input : String) : Array(Cuboid)
      input.lines.map { |line| Cuboid.new(line) }
    end

    def solution1(cuboids : Array(Cuboid)) : Int32
      generators = 0
      initial = Cuboid.new(Operation::Off, -50, 50, -50, 50, -50, 50)
      cuboids.each_with_index do |cuboid,i|
        cuboid = initial.intersection(cuboid)
        j = i-1
        while j >= 0
          if cuboid.op == Operation::On
            generators += cuboid.size
          else
            generators -= cuboid.size
          end 
          process_intersections cuboid, cuboids[j]
          j -= 1
        end
      end
      generators
    end

    def process_intersections(cuboid, prev)
      generators = 0
      case cuboid.op
      when Operation::On
        case prev.op
        when Operation::On
          generators -= prev.size
        when Operation::Off
        end
      when Operation::Off
        case prev.op
        when Operation::On
        when Operation::Off
          generators += prev.size
        end
      end
    end

    def solution2(cuboids : Array(Cuboid)) : Int32
      0
    end

    def main
      input = parse_input File.read "./src/day#{DAY}/input.txt"
      puts "Solutions of day#{DAY} : #{solution1 input} #{solution2 input}"
    end
  end
end
