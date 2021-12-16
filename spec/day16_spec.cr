require "./spec_helper"

describe AdventOfCode2021 do
  it "day16 should work" do
    AdventOfCode2021::Day16.solution1("D2FE28").should eq(6)
    AdventOfCode2021::Day16.solution1("38006F45291200").should eq(9)
    AdventOfCode2021::Day16.solution1("EE00D40C823060").should eq(16)
    AdventOfCode2021::Day16.solution1("8A004A801A8002F478").should eq(16)
    AdventOfCode2021::Day16.solution1("620080001611562C8802118E34").should eq(12)
    AdventOfCode2021::Day16.solution1("C0015000016115A2E0802F182340").should eq(23)
    AdventOfCode2021::Day16.solution1("A0016C880162017C3686B18A3D4780").should eq(31)

    AdventOfCode2021::Day16.solution2("").should eq(0)
  end
end
