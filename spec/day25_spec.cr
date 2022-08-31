require "./spec_helper"

module Day25Spec
  include AdventOfCode2021::Day25

  describe AdventOfCode2021::Day25, focus: true do
    input = <<-INPUT
      v...>>.vv>
      .vv>>.vv..
      >>.>v>...v
      >>v>>.>.v.
      v>v.vv.v..
      >.>>..v...
      .vv..>.>v.
      v.v..>>v.v
      ....v..v.>
      INPUT

    it "parsing cucumbers and printing should give input" do
      cucumbers = SeaCucumbers.new input
      cucumbers.to_s.should eq(input)
    end

    it "step should work for given smaller example" do
      step0 = <<-INPUT
        ...>...
        .......
        ......>
        v.....>
        ......>
        .......
        ..vvv..
        INPUT
      step1 = <<-INPUT
        ..vv>..
        .......
        >......
        v.....>
        >......
        .......
        ....v..
        INPUT
      step2 = <<-INPUT
        ....v>.
        ..vv...
        .>.....
        ......>
        v>.....
        .......
        .......
        INPUT
      step3 = <<-INPUT
        ......>
        ..v.v..
        ..>v...
        >......
        ..>....
        v......
        .......
        INPUT
      step4 = <<-INPUT
        >......
        ..v....
        ..>.v..
        .>.v...
        ...>...
        .......
        v......
        INPUT
      cucumbers = SeaCucumbers.new step0
      cucumbers.step
      cucumbers.to_s.should eq(step1)
      cucumbers.step
      cucumbers.to_s.should eq(step2)
      cucumbers.step
      cucumbers.to_s.should eq(step3)
      cucumbers.steps.should eq(3)
      cucumbers.step
      cucumbers.to_s.should eq(step4)
      cucumbers.steps.should eq(4)
      cucumbers.should eq(SeaCucumbers.new step4)
    end

    it "step function should work on test input" do
      step1 = <<-INPUT
        ....>.>v.>
        v.v>.>v.v.
        >v>>..>v..
        >>v>v>.>.v
        .>v.v...v.
        v>>.>vvv..
        ..v...>>..
        vv...>>vv.
        >.v.v..v.v
        INPUT

      step2 = <<-INPUT
        >.v.v>>..v
        v.v.>>vv..
        >v>.>.>.v.
        >>v>v.>v>.
        .>..v....v
        .>v>>.v.v.
        v....v>v>.
        .vv..>>v..
        v>.....vv.
        INPUT

      step3 = <<-INPUT
        v>v.v>.>v.
        v...>>.v.v
        >vv>.>v>..
        >>v>v.>.v>
        ..>....v..
        .>.>v>v..v
        ..v..v>vv>
        v.v..>>v..
        .v>....v..
        INPUT

      step4 = <<-INPUT
        v>..v.>>..
        v.v.>.>.v.
        >vv.>>.v>v
        >>.>..v>.>
        ..v>v...v.
        ..>>.>vv..
        >.v.vv>v.v
        .....>>vv.
        vvv>...v..
        INPUT

      step5 = <<-INPUT
        vv>...>v>.
        v.v.v>.>v.
        >.v.>.>.>v
        >v>.>..v>>
        ..v>v.v...
        ..>.>>vvv.
        .>...v>v..
        ..v.v>>v.v
        v.v.>...v.
        INPUT

      step10 = <<-INPUT
        ..>..>>vv.
        v.....>>.v
        ..v.v>>>v>
        v>.>v.>>>.
        ..v>v.vv.v
        .v.>>>.v..
        v.v..>v>..
        ..v...>v.>
        .vv..v>vv.
        INPUT

      step20 = <<-INPUT
        v>.....>>.
        >vv>.....v
        .>v>v.vv>>
        v>>>v.>v.>
        ....vv>v..
        .v.>>>vvv.
        ..v..>>vv.
        v.v...>>.v
        ..v.....v>
        INPUT

      step30 = <<-INPUT
        .vv.v..>>>
        v>...v...>
        >.v>.>vv.>
        >v>.>.>v.>
        .>..v.vv..
        ..v>..>>v.
        ....v>..>v
        v.v...>vv>
        v.v...>vvv
        INPUT

      step40 = <<-INPUT
        >>v>v..v..
        ..>>v..vv.
        ..>>>v.>.v
        ..>>>>vvv>
        v.....>...
        v.v...>v>>
        >vv.....v>
        .>v...v.>v
        vvv.v..v.>
        INPUT

      step50 = <<-INPUT
        ..>>v>vv.v
        ..v.>>vv..
        v.>>v>>v..
        ..>>>>>vv.
        vvv....>vv
        ..v....>>>
        v>.......>
        .vv>....v>
        .>v.vv.v..
        INPUT

      step55 = <<-INPUT
        ..>>v>vv..
        ..v.>>vv..
        ..>>v>>vv.
        ..>>>>>vv.
        v......>vv
        v>v....>>v
        vvv...>..>
        >vv.....>.
        .>v.vv.v..
        INPUT

      step56 = <<-INPUT
        ..>>v>vv..
        ..v.>>vv..
        ..>>v>>vv.
        ..>>>>>vv.
        v......>vv
        v>v....>>v
        vvv....>.>
        >vv......>
        .>v.vv.v..
        INPUT

      step57 = <<-INPUT
        ..>>v>vv..
        ..v.>>vv..
        ..>>v>>vv.
        ..>>>>>vv.
        v......>vv
        v>v....>>v
        vvv.....>>
        >vv......>
        .>v.vv.v..
        INPUT

      step58 = <<-INPUT
        ..>>v>vv..
        ..v.>>vv..
        ..>>v>>vv.
        ..>>>>>vv.
        v......>vv
        v>v....>>v
        vvv.....>>
        >vv......>
        .>v.vv.v..
        INPUT

      cucumbers = SeaCucumbers.new input
      cucumbers.step
      cucumbers.to_s.should eq(step1)
      cucumbers.step
      cucumbers.to_s.should eq(step2)
      cucumbers.step
      cucumbers.to_s.should eq(step3)
      cucumbers.step
      cucumbers.to_s.should eq(step4)
      cucumbers.step
      cucumbers.to_s.should eq(step5)
      5.times { cucumbers.step }
      cucumbers.to_s.should eq(step10)
      10.times { cucumbers.step }
      cucumbers.to_s.should eq(step20)
      10.times { cucumbers.step }
      cucumbers.to_s.should eq(step30)
      10.times { cucumbers.step }
      cucumbers.to_s.should eq(step40)
      10.times { cucumbers.step }
      cucumbers.to_s.should eq(step50)
      5.times { cucumbers.step }
      cucumbers.to_s.should eq(step55)
      cucumbers.step
      cucumbers.to_s.should eq(step56)
      cucumbers.step
      cucumbers.to_s.should eq(step57)
      cucumbers.steps.should eq(57)
      # 58 should be frozen1
      cucumbers.step
      cucumbers.to_s.should eq(step57)
      cucumbers.to_s.should eq(step58)
      cucumbers.steps.should eq(58)
    end

    it "day1 works" do
      cucumbers = SeaCucumbers.new input
      cucumbers.solution1.should eq(58)
    end
  end
end
