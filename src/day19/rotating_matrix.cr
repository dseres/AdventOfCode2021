module AdventOfCode2021::Day19
  extend self

  # Matrix for ro>tation
  class RotatingMatrix
    SIZE = 3

    # The numbers represents the columns,
    #
    # The 9 numbers in a row:
    # m[0][0], m[0][1], m[0][2], m[1][0], m[1][1], m[1][2], m[2][0], m[2][1], m[2][2]
    # represents the matrix as :
    # [ m[0][0], m[1][0], m[2][0]]
    # [ m[0][1], m[1][1], m[2][2]]
    # [ m[0][2], m[1][2], m[2][3]]
    property m = Array(Int32).new(SIZE * SIZE, 0)

    def initialize; end

    def initialize(@m); end

    def initialize(&block : Int32, Int32 -> Int32)
      (0...SIZE).each do |x|
        (0...SIZE).each do |y|
          self[x, y] = yield x, y
        end
      end
    end

    # defining constants
    @@sin = {0 => 0, 90 => 1, 180 => 0, 270 => -1, 360 => 0}
    @@cos = {0 => 1, 90 => 0, 180 => -1, 270 => 0, 360 => 1}

    # [ 1,  0,  0]
    # [ 0,  1,  0]
    # [ 0,  0,  1]
    @@t0 = RotatingMatrix.new { |x, y| x == y ? 1 : 0 }

    # This matrix will rotate around x axis by 90 degree counter clockwise
    # [ 1,  0,  0]
    # [ 0,  0, -1]
    # [ 0,  1,  0]
    @@tx = RotatingMatrix.new [1, 0, 0, 0, @@cos[90], @@sin[90], 0, -@@sin[90], @@cos[90]]

    # [ 0,  0,  1]
    # [ 0,  1,  0]
    # [-1,  0,  0]
    @@ty = RotatingMatrix.new [@@cos[90], 0, -@@sin[90], 0, 1, 0, @@sin[90], 0, @@cos[90]]

    # [ 0, -1,  0]
    # [ 1,  0,  0]
    # [ 0,  0,  1]
    @@tz = RotatingMatrix.new [@@cos[90], @@sin[90], 0, -@@sin[90], @@cos[90], 0, 0, 0, 1]

    def self.multiplicative_identity
      @@t0
    end

    def self.t0
      @@t0
    end

    def self.tx
      @@tx
    end

    def self.ty
      @@ty
    end

    def self.tz
      @@tz
    end

    def to_s(io)
      (0...SIZE).each do |y|
        io << "["
        (0...SIZE).each do |x|
          io.printf("%2d", self[x, y])
          if x != SIZE - 1
            io << ", "
          end
        end
        io << "]\n"
      end
      # io.printf("[%2d, %2d, %2d]\n", m[0], m[3], m[6])
      # io.printf("[%2d, %2d, %2d]\n", m[1], m[4], m[7])
      # io.printf("[%2d, %2d, %2d]\n", m[2], m[5], m[8])
    end

    def [](x : Int32, y : Int32)
      m[x * SIZE + y]
    end

    def []=(x : Int32, y : Int32, value : Int32)
      m[x * SIZE + y] = value
    end

    def *(other : RotatingMatrix) : RotatingMatrix
      RotatingMatrix.new do |x, y|
        (0...SIZE).map { |i| self[i, y] * other[x, i] }.sum
      end
    end

    def pow(n : Int32) : RotatingMatrix
      return @@t0 if n == 0
      return self if n == 1
      return self * self if n == 2
      return self * self * self if n == 3
      return self.pow(n % 4) if n >= 4
      raise Exception.new("n (#{n}) must be non negative") if n < 0
      self
    end

    def ==(other : self)
      @m == self.m
    end

    def ==(other)
      false
    end

    private def self.get_all_rotations 
      rotations = [] of RotatingMatrix
      (0...4).each do |x|
        (0...4).each do |y|
          (0...4).each do |z|
            rotations << tx.pow(x) * ty.pow(y) * tz.pow(z)
          end
        end
      end
      rotations.uniq { |m| m.m}
    end

    @@all_rotations : Array(RotatingMatrix) = get_all_rotations
    def self.all_rotations
      @@all_rotations
    end

  end
end
