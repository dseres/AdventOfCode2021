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
    describe "initialize" do
      it "test room's constructor" do
        room = Room.new(Type::Bronze, [Type::Copper, Type::Desert])
        room.type.should eq(Type::Bronze)
        room.amphipodas.should eq([Type::Copper, Type::Desert])

        room = Room.new(Type::Amber, [Type::Amber])
        room.type.should eq(Type::Amber)
        room.amphipodas.should eq([Type::Amber])

        room = Room.new(Type::Amber)
        room.type.should eq(Type::Amber)
        room.amphipodas.empty?().should be_true
      end

      it "room can be created with two or less amphipods" do
        expect_raises(Exception) do
          Room.new(Type::Amber, [Type::Amber, Type::Amber, Type::Amber])
        end
        expect_raises(Exception) do
          Room.new(Type::Amber, [Type::Amber, Type::Bronze, Type::Copper])
        end
        expect_raises(Exception) do
          Room.new(Type::Amber, [Type::None])
        end
        expect_raises(Exception) do
          Room.new(Type::Amber, [Type::Amber, Type::None])
        end
        expect_raises(Exception) do
          Room.new(Type::None, [Type::Copper, Type::Desert])
        end
      end
    end

    it "pop should give back type and number of steps" do
      room = Room.new(Type::Bronze, [Type::Copper, Type::Desert])
      room.pop.should eq({Type::Desert, 1})
      room.pop.should eq({Type::Copper, 2})
      room.pop.should be_nil
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

      room = Room.new(Type::Bronze, [Type::Bronze, Type::Bronze])
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
      Room.new(Type::Bronze, [] of Type).solved?.should be_false
      Room.new(Type::Bronze, [Type::Bronze]).solved?.should be_false
      Room.new(Type::Bronze, [Type::Copper]).solved?.should be_false
      Room.new(Type::Bronze, [Type::Copper, Type::Desert]).solved?.should be_false
      Room.new(Type::Bronze, [Type::Bronze, Type::Desert]).solved?.should be_false
      Room.new(Type::Bronze, [Type::Copper, Type::Bronze]).solved?.should be_false

      Room.new(Type::Bronze, [Type::Bronze, Type::Bronze]).solved?.should be_true
    end
  end

  describe Burrow do
    describe "constructor" do
      it "constructor should create empty burrow" do
        b = Burrow.new
        b.rooms.size().should eq(4)
        b.rooms[0].type.should eq(Type::Amber)
        b.rooms[1].type.should eq(Type::Bronze)
        b.rooms[2].type.should eq(Type::Copper)
        b.rooms[3].type.should eq(Type::Desert)
        b.rooms[0].amphipodas.empty?().should be_true
        b.rooms[1].amphipodas.empty?().should be_true
        b.rooms[2].amphipodas.empty?().should be_true
        b.rooms[3].amphipodas.empty?().should be_true
        b.used_energy.should eq(0)
        b.hallway.should eq(Array.new(11, Type::None))
        end
    end

    input = <<-INPUT
#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
INPUT
    
    it "parse input of day23" do
      burrow = Burrow.new(input)
      burrow.rooms[0].amphipodas.should eq([Type::Amber, Type::Bronze])
      burrow.rooms[1].amphipodas.should eq([Type::Desert, Type::Copper])
      burrow.rooms[2].amphipodas.should eq([Type::Copper, Type::Bronze])
      burrow.rooms[3].amphipodas.should eq([Type::Amber, Type::Desert])
      burrow.used_energy.should eq(0)
      burrow.hallway.should eq(Array.new(11, Type::None))
    end

    it "to_s should print the same as input" do
      burrow = Burrow.new(input)
      burrow.to_s().should eq(input)
    end

    it "solved? should be false for input, and should be true for a presolved input" do
      b = Burrow.new(input)
      b.solved?().should be_false

      solved_input = <<-INPUT
#############
#...........#
###A#B#C#D###
  #A#B#C#D#
  #########
INPUT
      s = Burrow.new(solved_input)
      s.solved?().should be_true
    end
  end
end
