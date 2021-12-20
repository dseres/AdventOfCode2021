require "./rotating_matrix.cr"

module AdventOfCode2021::Day19
  extend self

  struct Beam
    property x = 0
    property y = 0
    property z = 0

    def initialize(@x, @y, @z); end

    def initialize(@x, @y, @z); end

    def initialize(&block : (Int32 -> Int32))
      @x = yield 0
      @y = yield 1
      @z = yield 2
    end

    def [](i : Int32)
      case i
      when 0
        x
      when 1
        y
      when 2
        z
      else
        raise IndexError.new
      end
    end

    def *(other : RotatingMatrix)
      Beam.new do |x|
        (0...3).map { |y| self[y] * other[x, y] }.sum
      end
    end

    def to_s(io)
      io.printf("[%4d, %4d, %4d]", @x, @y, @z)
    end

    def ==(other : Beam)
      @x == other.x && @y == other.y && @z == other.z
    end

    def ==(other)
      false
    end

    def +(other : Beam)
      Beam.new(@x + other.x, @y + other.y, @z + other.z)
    end

    def -(other : Beam)
      Beam.new(@x - other.x, @y - other.y, @z - other.z)
    end

    def <=>(other : Beam)
      [@x, @y, @z] <=> [other.x, other.y, other.z]
    end
  end
end
