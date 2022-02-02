module AdventOfCode2021
  module Day22
    extend self

    DAY = 22

    enum Operation
      On
      Off
    end

    class Range
      getter begin : Int32
      getter end : Int32

      def initialize(@begin, @end)
        raise Exception.new("Bad parameters for Range : #{@begin} #{@end}") if @end < @begin
      end

      def includes?(other : Range) : Bool
        @begin <= other.begin && other.begin <= @end && @begin <= other.end && other.end <= @end
      end

      def has_intersection?(other : Range) : Bool
        @begin <= other.begin && other.begin <= @end || @begin <= other.end && other.end <= @end || other.begin < @begin && @end < other.end
      end

      def intersection(other : Range) : Range
        Range.new(Math.max(@begin, other.begin), Math.min(@end, other.end))
      end

      def intersection?(other : Range) : Range | Nil
        return nil unless has_intersection? other
        return intersection other
      end

      def split_by(other : Range)
        splitted = Tuple.new
        if other.begin > Int32::MIN
          range_before = Range.new(Int32::MIN, other.begin - 1)
          if has_intersection? range_before
            splitted += {intersection(range_before)}
          end
        end
        if has_intersection? other
          splitted += {intersection(other)}
        end
        if other.end < Int32::MAX
          range_after = Range.new(other.end + 1, Int32::MAX)
          if has_intersection? range_after
            splitted += {intersection(range_after)}
          end
        end
        splitted
      end

      def size
        return @end - @begin + 1
      end

      def to_s(io : IO)
        io << "#{@begin}..#{@end}"
      end

      def ==(other : Range)
        @begin == other.begin && @end == other.end
      end
    end

    struct Cuboid
      property op : Operation
      property x : Range, y : Range, z : Range

      def initialize(@op, @x, @y, @z); end

      def initialize(str : String)
        str =~ /^(on|off) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)$/
        op = Operation.parse $~[1]
        x1 = $~[2].to_i32
        x2 = $~[3].to_i32
        y1 = $~[4].to_i32
        y2 = $~[5].to_i32
        z1 = $~[6].to_i32
        z2 = $~[7].to_i32
        initialize(op, Range.new(x1, x2), Range.new(y1, y2), Range.new(z1, z2))
      end

      def ==(other : Cuboid)
        @op == other.op && @x == other.x @y == other.y && @z == other.z
      end

      def is_on?
        @op == Operation::On
      end

      def includes?(other : Cuboid) : Bool
        @x.includes?(other.x) && @y.includes?(other.y) && @z.includes?(other.z)
      end

      def has_intersection?(other : Cuboid) : Bool
        @x.has_intersection?(other.x) && @y.has_intersection?(other.y) && @z.has_intersection?(other.z)
      end

      def intersection(other : Cuboid) : Cuboid
        Cuboid.new(other.op, @x.intersection(other.x), @y.intersection(other.y), @z.intersection(other.z))
      end

      def size : Int64
        @x.size.to_i64 * @y.size.to_i64 * @z.size.to_i64
      end

      def split_by(other : Cuboid) : Array(Cuboid)
        raise Exception.new("Other coboid has no intersection.") unless has_intersection? other
        splitted = [] of Cuboid
        x_ranges = @x.split_by(other.x)
        y_ranges = @y.split_by(other.y)
        z_ranges = @z.split_by(other.z)
        x_ranges.each_cartesian(y_ranges, z_ranges) do |x, y, z|
          c = Cuboid.new(@op, x, y, z)
          c.op = other.op if other.includes? c
          splitted << c
        end
        splitted
      end

      def to_s(io : IO) : Nil
        io << "Cuboid(#{@op} x=#{@x}, y=#{@y}, z=#{@z})"
      end
    end

    class Generator
      getter init_cuboid : Cuboid
      getter cuboids : Array(Cuboid)

      def initialize(size = 50)
        @init_cuboid = Cuboid.new(Operation::Off, Range.new(-size, size), Range.new(-size, size), Range.new(-size, size))
        @cuboids = [@init_cuboid]
      end

      def add(new_cuboid : Cuboid)
        return unless init_cuboid.has_intersection? new_cuboid
        new_cuboid = init_cuboid.intersection new_cuboid
        new_cuboids = [] of Cuboid
        cuboids.each do |cuboid|
          if cuboid.has_intersection? new_cuboid
            new_cuboids.concat cuboid.split_by new_cuboid
          else
            new_cuboids << cuboid
          end
        end
        @cuboids = new_cuboids
      end

      def count_on : Int64
        cuboids.select(&.is_on?).sum(&.size)
      end
    end

    def parse_input(input : String) : Array(Cuboid)
      input.lines.map { |line| Cuboid.new(line) }
    end

    def solution1(cuboids : Array(Cuboid)) : Int64
      generator = Generator.new
      cuboids.each do |c|
        generator.add c
      end
      generator.count_on
    end

    def solution2(cuboids : Array(Cuboid)) : Int64
      generator = Generator.new(size = Int32::MAX)
      cuboids.each do |c|
        generator.add c
      end
      generator.count_on
    end

    def main
      input = parse_input File.read "./src/day#{DAY}/input.txt"
      puts "Solutions of day#{DAY} : #{solution1 input} #{solution2 input}"
    end
  end
end
