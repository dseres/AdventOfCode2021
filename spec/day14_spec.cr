require "./spec_helper"

describe AdventOfCode2021 do
  it "day14 should work" do
    str = <<-INPUT
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
INPUT
    template, rules = AdventOfCode2021::Day14.parse_input(str)
    AdventOfCode2021::Day14.solution1(template, rules).should eq(1588)
    AdventOfCode2021::Day14.solution2(template, rules).should eq(2188189693529)
  end
end
