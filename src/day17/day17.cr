module AdventOfCode2021
  module Day17
    extend self

    DAY = 17

    class Area
      property range_x : Range(Int32, Int32)
      property range_y : Range(Int32, Int32)

      def initialize(str)
        str =~ /^target area: x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)$/
        x0, x1, y0, y1 = $~[1..4].map &.to_i32
        @range_x = (x0..x1)
        @range_y = (y0..y1)
      end

      def includes?(x, y)
        range_x.includes?(x) && range_y.includes?(y)
      end

      def over_thrown?(x, y)
        x > range_x.end || y < range_y.begin
      end

      def limits
        {range_x.end.abs, range_y.begin.abs}
      end
    end

    class TrickShot
      property vx, vy
      getter my = 0

      def initialize(@vx : Int32, @vy : Int32)
      end

      def check_in_area(area : Area)
        x, y, @my = 0, 0, 0
        loop do
          x += @vx
          y += @vy
          @my = Math.max y, my
          @vx -= @vx.sign
          @vy -= 1
          if area.includes? x, y
            return true
          elsif area.over_thrown? x, y
            return false
          end
        end
      end
    end

    def solutions(input : String) : Tuple(Int32, Int32)
      area = Area.new(input)
      lx, ly = area.limits
      my = Int32::MIN
      count = 0
      (0..lx).each do |vx|
        (-ly..ly).each do |vy|
          ts = TrickShot.new vx, vy
          if ts.check_in_area area
            count += 1
            my = Math.max my, ts.my
          end
        end
      end
      {my, count}
    end

    def main
      input = File.read "./src/day#{DAY}/input.txt"
      count, my = solutions input
      puts "Solutions of day#{DAY} : #{count} #{my}"
    end
  end
end
