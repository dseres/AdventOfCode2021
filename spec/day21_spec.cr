require "./spec_helper"

include AdventOfCode2021::Day21

describe AdventOfCode2021 do
  it "example for part1 of day21 should work" do
    str = "Player 1 starting position: 4\n" \
          "Player 2 starting position: 8\n"
    game = DiracDiceGame.new(str)
    game.perform
    game.solution.should eq(739785)
  end

  it "example for part2 of day21 should work" do
    str = "Player 1 starting position: 4\n" \
          "Player 2 starting position: 8\n"
    game = QuantumDiracDiceGame.new(str)
    game.perform
    game.solution.should eq(444356092776315)
  end
end
