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


    def merge_scanners
        s1 = scanners.delete_at(0)
        while !scanners.empty?
            s2,t, diff,i = find_first_connected(s1, scanners).not_nil!
            scanners.delete_at(i)
            merge_scanners s1, s2, t, diff
        end
        s1
    end

    def find_first_connected(s1, scanners)
        scanners.each_with_index do |s2, i|
            t, diff, commons = get_common_beams(s1, s2)
            if commons >= 12
                return {s2, t, diff, i}
            end
        end
    end

    def merge_scanners(s1,s2,t,diff)
        s2 = (s2 * t) + diff
        s1.beams = (s1.beams + s2.beams).sort.uniq
    end

    def find_pairs : Array(Tuple(Scanner, Scanner, RotatingMatrix, Beam, Int32))
      pairs = [] of Tuple(Scanner, Scanner, RotatingMatrix, Beam, Int32)
      to_check = scanners.reverse
      s = to_check.pop
      checked = [] of Scanner
      find_pairs_for(s, to_check, checked, pairs)
      pairs
    end

    private def find_pairs_for(s, to_check, checked, pairs)
      return if to_check.empty?
      to_check.each { |s2| check_pair s, s2, pairs }
      checked << s
      s = to_check.pop
      find_pairs_for(s, to_check, checked, pairs)
    end

    private def check_pair(s1, s2, pairs)
      t, diff, commons = get_common_beams(s1, s2)
      if commons >= 12
        pairs << {s1, s2, t, diff, commons}
      end
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


    def print_scanners(t, s1, s2)
        puts t
        b1s = s1.beams.sort
        b2s = s2.beams.sort
        0.upto(Math.max(b1s.size, b2s.size) - 1) do |i|
          if i < b1s.size && i < b2s.size
            printf("%20s%20s%20s%20s\n", b1s[i], b2s[i], b2s[i] * t, Beam.new(68, -1246, -43) + b2s[i] * t)
          elsif i < b1s.size
            printf("%20s\n", b1s[i])
          else
            printf("%20s%20s%20s%20s\n", "", b2s[i], b2s[i]*t, Beam.new(68, -1246, -43) + b2s[i] * t)
          end
        end
      end
  end
end
