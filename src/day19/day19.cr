require "./*"

module AdventOfCode2021::Day19
  extend self
  DAY = 19

  def solution1(scanners : ScannerSet) : Int32
    s1 = scanners.merge_scanners
    pp! s1.beams.size
  end

  def solution2(scanners : ScannerSet) : Int32
    0
  end

  def main
    scanners = ScannerSet.new(File.read "./src/day#{DAY}/input.txt")
    puts "Solutions of day#{DAY} : #{solution1 scanners} #{solution2 scanners}"
  end
end
