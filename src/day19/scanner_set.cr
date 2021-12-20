require "./scanner.cr"

module AdventOfCode2021::Day19
  extend self

  class ScannerSet
    include Enumerable(Scanner)

    property scanners = [] of Scanner

    def initialize(@scanners); end

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

    def merge_scanners : Tuple(Scanner, Array(Beam))
      s1 = scanners.delete_at(0)
      centers = [Beam.new(0, 0, 0)]
      while !scanners.empty?
        s2, t, diff, i = find_first_connected(s1, scanners).not_nil!
        centers << diff
        scanners.delete_at(i)
        merge_scanners s1, s2, t, diff
      end
      {s1, centers}
    end

    def find_first_connected(s1, scanners)
      scanners.each_with_index do |s2, i|
        t, diff, commons = get_common_beams(s1, s2)
        if commons >= 12
          return {s2, t, diff, i}
        end
      end
    end

    def merge_scanners(s1, s2, t, diff)
      s2 = (s2 * t) + diff
      s1.beams = (s1.beams + s2.beams).sort.uniq
    end

    def get_common_beams(s1, s2)
      RotatingMatrix.all_rotations.map() do |t|
        # print_scanners t, s1, s2
        s2t = s2 * t
        diff, commons = compare_beams s1, s2t
        # puts t, commons
        {t, diff, commons}
      end.max_by &.[2]
    end

    private def compare_beams(s1, s2)
      counter = {} of Beam => Int32
      s1.beams.each do |b1|
        s2.beams.each do |b2|
          diff = b1 - b2
          if counter[diff]?.nil?
            counter[diff] = 1
          else
            counter[diff] += 1
          end
        end
      end
      # counter.each { |beam,c| puts beam; pp! counter}
      counter.max_by { |diff, commons| commons }
    end

    def max_manhattan_distance(centers)
        centers.cartesian_product(centers).map do |c1,c2|
            (c1.x - c2.x).abs + (c1.y-c2.y).abs + (c1.z - c2.z).abs
        end.max
    end

  end
end
