require "./spec_helper"

alias Type = AdventOfCode2021::Day23::Type
alias Room = AdventOfCode2021::Day23::Room
alias Burrow = AdventOfCode2021::Day23::Burrow

describe AdventOfCode2021::Day23, focus: true do

  describe Type do
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
  end

  describe Room do
    it "room can be created with two or less amphipods" do
      Room.new(Type::Bronze, [Type::Copper, Type::Desert])
      Room.new(Type::Amber, [Type::Amber])
      Room.new(Type::Amber, [] of Type)
      expect_raises(Exception) do
        Room.new(Type::Amber, [Type::Amber,Type::Amber,Type::Amber])
      end
      expect_raises(Exception) do
        Room.new(Type::Amber, [Type::Amber,Type::Bronze,Type::Copper])
      end
      expect_raises(Exception) do
        Room.new(Type::Amber, [Type::None])
      end
      expect_raises(Exception) do
        Room.new(Type::Amber, [Type::Amber,Type::None])
      end
      expect_raises(Exception) do
        Room.new(Type::None, [Type::Copper, Type::Desert])
      end
    end

    it "pop should give back type and number of steps" do
      room = Room.new(Type::Bronze, [Type::Copper, Type::Desert])
      room.pop().should eq({Type::Desert,1})
      room.pop().should eq({Type::Copper,2})
      room.pop().should be_nil
    end

    it "can_push? give true on type of room, and if there is no other or no more than 2 ampiphod" do
      room = Room.new(Type::Bronze, [Type::Copper, Type::Desert])
      room.can_push?(Type::Bronze).should be_false
      room.can_push?(Type::Amber).should be_false

      room = Room.new(Type::Bronze, [Type::Copper])
      room.can_push?(Type::Bronze).should be_false
      room.can_push?(Type::Amber).should be_false
      room.can_push?(Type::None).should be_false

      room = Room.new(Type::Bronze, [] of Type)
      room.can_push?(Type::Bronze).should be_true
      room.can_push?(Type::Amber).should be_false
      room.can_push?(Type::None).should be_false

      room = Room.new(Type::Bronze, [Type::Bronze])
      room.can_push?(Type::Bronze).should be_true
      room.can_push?(Type::Amber).should be_false
      room.can_push?(Type::None).should be_false

      room = Room.new(Type::Bronze, [Type::Bronze,Type::Bronze])
      room.can_push?(Type::Bronze).should be_false
      room.can_push?(Type::Amber).should be_false
      room.can_push?(Type::None).should be_false
    end

    it "only proper type of amphipods can be pushed when room doesn't contains other ampiphod" do
      room = Room.new(Type::Desert, [] of Type)
      room.push(Type::Amber).should be_nil
      room.push(Type::None).should be_nil
      room.push(Type::Desert).should eq(2)

      room.push(Type::Amber).should be_nil
      room.push(Type::None).should be_nil
      room.push(Type::Desert).should eq(1)

      room.push(Type::Amber).should be_nil
      room.push(Type::None).should be_nil
      room.push(Type::Desert).should be_nil

      room = Room.new(Type::Desert, [Type::Amber] of Type)
      room.push(Type::Desert).should be_nil
    end

    it "solved? should be true if room has two amphipods with its own type" do
      Room.new(Type::Bronze, [] of Type).solved?().should be_false
      Room.new(Type::Bronze, [Type::Bronze]).solved?().should be_false
      Room.new(Type::Bronze, [Type::Copper]).solved?().should be_false
      Room.new(Type::Bronze, [Type::Copper, Type::Desert]).solved?().should be_false
      Room.new(Type::Bronze, [Type::Bronze, Type::Desert]).solved?().should be_false
      Room.new(Type::Bronze, [Type::Copper, Type::Bronze]).solved?().should be_false

      Room.new(Type::Bronze, [Type::Bronze, Type::Bronze]).solved?().should be_true
    end
  end

  describe Burrow do
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
end
