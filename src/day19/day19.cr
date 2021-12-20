require "./*"

module AdventOfCode2021::Day19
  extend self
  DAY = 19

  def solution1(scanners : ScannerSet) : Tuple(Int32, Int32)
    s1, centers = scanners.merge_scanners
    {s1.beams.size, scanners.max_manhattan_distance(centers)}
  end

  def main
    scanners = ScannerSet.new(File.read "./src/day#{DAY}/input.txt")
    puts "Solutions of day#{DAY} : #{solution1 scanners}"
  end
end
