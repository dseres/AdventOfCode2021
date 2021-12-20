require "./*"

module AdventOfCode2021::Day19
  extend self
  DAY = 19

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
      io << "[" << x << "," << y << "," << z << "]"
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
  end

  class Scanner
    include Enumerable(Beam)
    property id : Int32
    property beams = [] of Beam

    def initialize(@id, @beams = [] of Beam); end

    def [](i : Int32)
      @beams[i]
    end

    def size
      @beams.size
    end

    def each
      beams.each do |b|
        yield b
      end
    end

    def *(matrix : RotatingMatrix) : Scanner
      Scanner.new(@id, beams.map { |beam| beam * matrix })
    end

    def ==(other : Scanner)
      @id == other.id && @beams == other.beams
    end

    def ==(other)
      false
    end
  end

  class ScannerSet
    include Enumerable(Scanner)

    property scanners = [] of Scanner

    def initialize(str : String)
      parse_input str
    end

    def [](i : Int32)
      @scanners[i]
    end

    def size
      @scanners.size
    end

    def each
      scanners.each do |s|
        yield s
      end
    end

    def ==(other : Scanners)
      @scanners == other.scanners
    end

    def ==(other)
      false
    end

    private def parse_input(str)
      str.lines.each do |line|
        if line =~ /--- scanner (\d+) ---/
          id = $~[1].to_i32
          scanner = Scanner.new(id)
          scanners << scanner
        elsif !line.empty?
          x, y, z = line.split(",").map &.to_i32
          scanners.last.beams << Beam.new(x, y, z)
        end
      end
    end

    def find_pairs
      pairs = [] of {Int32, Int32}
      scanners.each do |s1|
        scanners.each do |s2|
          if s1 != s2 && get_common_beams(s1, s2) >= 12
            pairs << {s1.id, s2.id}
          end
        end
      end
      pairs
    end

    def get_common_beams(s1, s2)
      RotatingMatrix.all_rotations.map() do |t|
        s2t = s2 * t
        commons = compare_beams s1, s2t
        puts t, commons
        commons
      end.max
    end

    private def compare_beams(s1, s2)
      counter = {} of Beam => Int32
      s1.beams.each do |b1|
        s2.beams.each do |b2|
          diff = b2 - b1
          if counter[diff]?.nil?
            counter[diff] = 1
          else
            counter[diff] += 1
          end
        end
      end
      #counter.each { |beam,c| puts beam; pp! counter}
      counter.max_of { |beam, c| c }
    end
  end

  def solution1(scanners : ScannerSet) : Int32
    0
  end

  def solution2(scanners : ScannerSet) : Int32
    0
  end

  def main
    scanners = ScannerSet.new(File.read "./src/day#{DAY}/input.txt")
    scanners.each do |s|
      pp! s.id, s.size
    end
    # pp scanners
    puts "Solutions of day#{DAY} : #{solution1 scanners} #{solution2 scanners}"
  end
end
