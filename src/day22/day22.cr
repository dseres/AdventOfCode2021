module AdventOfCode2021
  module Day22
    extend self

    DAY = 22

    enum Operation
      On
      Off
    end

    struct Cuboid
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

      def ==(other : Cuboid)
        op == other.op && x1 == other.x1 && x2 == other.x2 && y1 == other.y1 && y2 == other.y2 && z1 == other.z1 && z2 == other.z2
      end

      def is_on?
        @op == Operation::On
      end

      def has_intersection?(other : Cuboid) : Bool
        has_intersection?(@x1, @x2, other.x1, other.x2) && has_intersection?(@y1, @y2, other.y1, other.y2) && has_intersection?(@z1, @z2, other.z1, other.z2)
      end

      private def has_intersection?(x1, x2, y1, y2)
        x1 <= y1 && y1 <= x2 || x1 <= y2 && y2 <= x2
      end

      def intersection(other : Cuboid) : Cuboid
        Cuboid.new(other.op, Math.max(@x1, other.x1), Math.min(@x2, other.x2), Math.max(@y1, other.y1), Math.min(@y2, other.y2), Math.max(@z1, other.z1), Math.min(@z2, other.z2))
      end

      def size : Int32
        (@x2 - @x1 + 1) * (@y2 - @y1 + 1) * (@z2 - @z1 + 1)
      end

      def split_by(other : Cuboid) : Array(Cuboid)
        raise Exception.new("Other coboid has no intersection.") unless has_intersection? other
        splitted = [] of Cuboid
        x_values = get_included_points(@x1, @x2, other.x1, other.x2)
        y_values = get_included_points(@y1, @y2, other.y1, other.y2)
        z_values = get_included_points(@z1, @z2, other.z1, other.z2)
        pp! x_values, y_values, z_values
        x_values.each do |x1, x2|
          y_values.each do |y1, y2|
            z_values.each do |z1, z2|
              c = Cuboid.new(@op, x1, x2, y1, y2, z1, z2)
              c.op = other.op if c.has_intersection? other
              splitted << c
            end
          end
        end
        puts "Splitted cuboids are : "
        splitted.each { |c| puts "\t#{c}" }
        splitted
      end

      def get_included_points(p1, p2, q1, q2)
        # pp! p1,p2, q1, q2
        if p1 < q1 && q1 < p2 && p1 < q2 && q2 < p2
          return { {p1, (q1 - 1)}, {q1, q2}, {q2 + 1, p2} }
        elsif p1 < q1 && q1 < p2
          return { {p1, q1 - 1}, {q1, p2} }
        elsif p1 < q1 && q1 == p2
          return { {p1, q1 - 1}, {q1, p2} }
        elsif p1 < q2 && q2 < p2
          return { {p1, q2 - 1}, {q2, p2} }
        elsif p1 == q2 && q2 < p2
          return { {p1, q2}, {q2 + 1, p2} }
        else
          return { {p1, p2} }
        end
      end

      def to_s(io : IO) : Nil
        io << "Cuboid(#{@op} x=#{@x1}..#{@x2}, y=#{@y1}..#{@y2}, z=#{@z1}..#{@z2})"
      end
    end

    class Generator
      getter init_cuboid : Cuboid
      getter cuboids : Array(Cuboid)

      def initialize(size = 50)
        @init_cuboid = Cuboid.new(Operation::Off, -size, size, -size, size, -size, size)
        @cuboids = [@init_cuboid]
      end

      def add(new_cuboid : Cuboid)
        puts "Adding new cuboid #{new_cuboid}"
        return unless init_cuboid.has_intersection? new_cuboid
        new_cuboid = init_cuboid.intersection new_cuboid
        new_cuboids = [] of Cuboid
        cuboids.each do |cuboid|
          if cuboid.has_intersection? new_cuboid
            puts "Splitting cuboid #{cuboid} with new_cuboid #{new_cuboid}."
            new_cuboids.concat cuboid.split_by new_cuboid
          else
            new_cuboids << cuboid
          end
        end
        @cuboids = new_cuboids
      end

      def count_on : Int32
        cuboids.select(&.is_on?).sum(&.size)
      end
    end

    def parse_input(input : String) : Array(Cuboid)
      input.lines.map { |line| Cuboid.new(line) }
    end

    def solution1(cuboids : Array(Cuboid)) : Int32
      generator = Generator.new
      cuboids.each do |c|
        generator.add c
      end
      generator.count_on
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
