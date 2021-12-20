require "./*"

module AdventOfCode2021::Day19
  extend self
  DAY = 19

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
