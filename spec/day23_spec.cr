require "./spec_helper"

alias Type = AdventOfCode2021::Day23::Type
alias Room = AdventOfCode2021::Day23::Room
alias Burrow = AdventOfCode2021::Day23::Burrow
describe AdventOfCode2021, focus: true do

  it "day23 - convert amphipda type to and from character" do
    t = AdventOfCode2021::Day23.from_char('A')
    t.should eq(Type::Amber)
    c = AdventOfCode2021::Day23.to_char(t)
    c.should eq('A')

    t = AdventOfCode2021::Day23.from_char('B')
    t.should eq(Type::Bronze)
    c = AdventOfCode2021::Day23.to_char(t)
    c.should eq('B')

    t = AdventOfCode2021::Day23.from_char('C')
    t.should eq(Type::Copper)
    c = AdventOfCode2021::Day23.to_char(t)
    c.should eq('C')

    t = AdventOfCode2021::Day23.from_char('B')
    t.should eq(Type::Bronze)
    c = AdventOfCode2021::Day23.to_char(t)
    c.should eq('B')

    t = AdventOfCode2021::Day23.from_char('D')
    t.should eq(Type::Desert)
    c = AdventOfCode2021::Day23.to_char(t)
    c.should eq('D')

    t = AdventOfCode2021::Day23.from_char('.')
    t.should eq(Type::None)
    c = AdventOfCode2021::Day23.to_char(t)
    c.should eq('.')
  end 

  it "day23 - room can accept proper amphipod and can push and pop one" do
    room = Room.new(Type::Bronze, [Type::Copper, Type::Desert])
    room.solved?().should be_false
    room.pop().should eq({Type::Desert,1})
    room.solved?().should be_false
    room.pop().should eq({Type::Copper,2})
    room.can_push?(Type::Amber).should be_false
    room.push(Type::Amber).should be_nil
    room.push(Type::None).should be_nil
    room.can_push?(Type::Bronze).should be_true
    room.push(Type::Bronze).should eq(2)
    room.solved?().should be_false
    room.can_push?(Type::Amber).should be_false
    room.push(Type::Amber).should be_nil
    room.push(Type::None).should be_nil
    room.push(Type::Bronze).should eq(1)
    room.solved?().should be_true

    room = Room.new(Type::Bronze, [Type::Bronze, Type::Desert])
    room.solved?().should be_false
    room.push(Type::Amber).should be_nil
    room.push(Type::None).should be_nil
    room.push(Type::Bronze).should be_nil

    room = Room.new(Type::Bronze, [Type::Copper, Type::Bronze])
    room.solved?().should be_false

    room = Room.new(Type::Bronze, [Type::Bronze, Type::Bronze])
    room.solved?().should be_true
    room.push(Type::Amber).should be_nil
    room.push(Type::None).should be_nil
    room.push(Type::Bronze).should be_nil
  end

  it "day23 should work" do
    input = <<-INPUT
#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
INPUT
    burrow = Burrow.new(input)
    burrow.solve1.should eq(12521)
    burrow.solve2.should eq(0)
  end
end
