require "./spec_helper"

module Day25Spec
  include AdventOfCode2021::Day25

  describe AdventOfCode2021::Day25 , focus: true do
    # TODO: Write tests

    it "day1 works" do
      input = <<-INPUT
      INPUT
      AdventOfCode2021::Day25.solution1(input).should eq(0)
      AdventOfCode2021::Day25.solution2(input).should eq(0)
    end
  end
end
