require "./spec_helper"

module Day23Spec
  include AdventOfCode2021::Day23

  input = <<-INPUT
  #############
  #...........#
  ###B#C#B#D###
    #A#D#C#A#
    #########
  INPUT

  solved_input = <<-INPUT
  #############
  #...........#
  ###A#B#C#D###
    #A#B#C#D#
    #########
  INPUT

  describe AdventOfCode2021::Day23, focus: true do
    describe "is_room?" do
      it "is_room? should return true on valid ampiphod types" do
        AdventOfCode2021::Day23.is_type?(AMBER).should be_true
        AdventOfCode2021::Day23.is_type?(BRONZE).should be_true
        AdventOfCode2021::Day23.is_type?(COPPER).should be_true
        AdventOfCode2021::Day23.is_type?(DESERT).should be_true
        AdventOfCode2021::Day23.is_type?(EMPTY).should be_false
      end
    end

    describe Room do
      describe "initialize" do
        it "test room's constructor" do
          room = Room.new(BRONZE, [DESERT])
          room.type.should eq(BRONZE)
          room.amphipodas.should eq([DESERT])

          room = Room.new(AMBER, [AMBER])
          room.type.should eq(AMBER)
          room.amphipodas.should eq([AMBER])

          room = Room.new(AMBER)
          room.type.should eq(AMBER)
          room.amphipodas.empty?.should be_true
        end

        it "room can be created with two or less amphipods" do
          expect_raises(Exception) do
            Room.new(AMBER, [AMBER, AMBER, AMBER])
          end
          expect_raises(Exception) do
            Room.new(AMBER, [AMBER, BRONZE, COPPER])
          end
          expect_raises(Exception) do
            Room.new(AMBER, [EMPTY])
          end
          expect_raises(Exception) do
            Room.new(AMBER, [AMBER, EMPTY])
          end
          expect_raises(Exception) do
            Room.new(EMPTY, [DESERT])
          end
        end
      end

      it "clone should deep copy amphipodas" do
        room = Room.new(AMBER, [AMBER])
        cloned = room.clone
        cloned.amphipodas.same?(room.amphipodas).should be_false
      end

      it "can_pop? is true if there is 1 amphipod with different type in the room" do
        room = Room.new(BRONZE)
        room.can_pop?.should be_false
        room = Room.new(BRONZE, [BRONZE])
        room.can_pop?.should be_false
        room = Room.new(BRONZE, [BRONZE, BRONZE])
        room.can_pop?.should be_false

        room = Room.new(BRONZE, [COPPER])
        room.can_pop?.should be_true
        room = Room.new(BRONZE, [COPPER, DESERT])
        room.can_pop?.should be_true
      end

      it "pop should give back type and number of steps" do
        room = Room.new(BRONZE)
        room.pop.should be_nil
        room = Room.new(BRONZE, [BRONZE])
        room.pop.should be_nil
        room = Room.new(BRONZE, [BRONZE, BRONZE])
        room.pop.should be_nil

        room = Room.new(BRONZE, [COPPER, DESERT])
        room.pop.should eq({DESERT, 1})
        room.pop.should eq({COPPER, 2})
        room.amphipodas.empty?.should be_true
      end

      it "can_push? give true on type of room, and if there is no other or no more than 2 ampiphod" do
        room = Room.new(BRONZE, [DESERT])
        room.can_push?(BRONZE).should be_false
        room.can_push?(AMBER).should be_false

        room = Room.new(BRONZE, [COPPER])
        room.can_push?(BRONZE).should be_false
        room.can_push?(AMBER).should be_false
        room.can_push?(EMPTY).should be_false

        room = Room.new(BRONZE, [] of UInt8)
        room.can_push?(BRONZE).should be_true
        room.can_push?(AMBER).should be_false
        room.can_push?(EMPTY).should be_false

        room = Room.new(BRONZE, [BRONZE])
        room.can_push?(BRONZE).should be_true
        room.can_push?(AMBER).should be_false
        room.can_push?(EMPTY).should be_false

        room = Room.new(BRONZE, [BRONZE, BRONZE])
        room.can_push?(BRONZE).should be_false
        room.can_push?(AMBER).should be_false
        room.can_push?(EMPTY).should be_false
      end

      it "only proper type of amphipods can be pushed when room doesn't contains other ampiphod" do
        room = Room.new(DESERT)
        room.push(AMBER).should be_nil
        room.push(EMPTY).should be_nil
        room.push(DESERT).should eq(2)

        room.push(AMBER).should be_nil
        room.push(EMPTY).should be_nil
        room.push(DESERT).should eq(1)

        room.push(AMBER).should be_nil
        room.push(EMPTY).should be_nil
        room.push(DESERT).should be_nil

        room = Room.new(DESERT, [AMBER])
        room.push(DESERT).should be_nil
      end

      it "solved? should be true if room has two amphipods with its own type" do
        Room.new(BRONZE, [] of UInt8).solved?.should be_false
        Room.new(BRONZE, [BRONZE]).solved?.should be_false
        Room.new(BRONZE, [COPPER]).solved?.should be_false
        Room.new(BRONZE, [DESERT]).solved?.should be_false
        Room.new(BRONZE, [BRONZE, DESERT]).solved?.should be_false
        Room.new(BRONZE, [COPPER, BRONZE]).solved?.should be_false

        Room.new(BRONZE, [BRONZE, BRONZE]).solved?.should be_true
      end
    end

    describe Burrow do
      describe "constructor" do
        it "constructor should create empty burrow" do
          b = Burrow.new
          b.rooms.size.should eq(4)
          b.rooms[0].type.should eq(AMBER)
          b.rooms[1].type.should eq(BRONZE)
          b.rooms[2].type.should eq(COPPER)
          b.rooms[3].type.should eq(DESERT)
          b.rooms[0].amphipodas.empty?.should be_true
          b.rooms[1].amphipodas.empty?.should be_true
          b.rooms[2].amphipodas.empty?.should be_true
          b.rooms[3].amphipodas.empty?.should be_true
          b.used_energy.should eq(0)
          b.hallway.should eq(StaticArray(UInt8, 11).new(EMPTY))
        end
      end

      it "parse input of day23" do
        burrow = Burrow.new(input)
        burrow.rooms[0].amphipodas.should eq([AMBER, BRONZE])
        burrow.rooms[1].amphipodas.should eq([DESERT, COPPER])
        burrow.rooms[2].amphipodas.should eq([COPPER, BRONZE])
        burrow.rooms[3].amphipodas.should eq([AMBER, DESERT])
        burrow.used_energy.should eq(0)
        burrow.hallway.should eq(StaticArray(UInt8, 11).new(EMPTY))
      end

      it "to_s should print the same as input" do
        burrow = Burrow.new(input)
        burrow.to_s.should eq(input)
      end

      it "clone should deep copy everything except solutions1" do
        b = Burrow.new
        c = b.clone
        b.hallway.==(c.hallway).should be_true
        b.rooms.==(c.rooms).should be_false # rooms are compared by refererence
        b.used_energy.==(c.used_energy).should be_true
        b.solutions1.same?(c.solutions1).should be_true
        b.min_energy1.==(c.min_energy1).should be_true
      end

      it "solved? should be false for input, and should be true for a presolved input" do
        b = Burrow.new(input)
        b.solved?.should be_false

        s = Burrow.new(solved_input)
        s.solved?.should be_true
      end

      it "index_of_room_entry function should give the index of hallway at the entry of that room" do
        Burrow.index_of_room_entry(0).should eq(2)        
        Burrow.index_of_room_entry(1).should eq(4)        
        Burrow.index_of_room_entry(2).should eq(6)        
        Burrow.index_of_room_entry(3).should eq(8)        
      end

      it "is_entry? function should return true if an index in hallway is a room's entry point" do 
        Burrow.is_entry?(-1).should be_false
        Burrow.is_entry?(0).should be_false
        Burrow.is_entry?(1).should be_false
        Burrow.is_entry?(2).should be_true
        Burrow.is_entry?(3).should be_false
        Burrow.is_entry?(4).should be_true
        Burrow.is_entry?(5).should be_false
        Burrow.is_entry?(6).should be_true
        Burrow.is_entry?(7).should be_false
        Burrow.is_entry?(8).should be_true
        Burrow.is_entry?(9).should be_false
        Burrow.is_entry?(10).should be_false
        Burrow.is_entry?(11).should be_false
      end

      it "is_not_entry? function should return true if an index in hallway isn't a room's entry point" do 
        Burrow.is_not_entry?(-1).should be_false
        Burrow.is_not_entry?(0).should be_true
        Burrow.is_not_entry?(1).should be_true
        Burrow.is_not_entry?(2).should be_false
        Burrow.is_not_entry?(3).should be_true
        Burrow.is_not_entry?(4).should be_false
        Burrow.is_not_entry?(5).should be_true
        Burrow.is_not_entry?(6).should be_false
        Burrow.is_not_entry?(7).should be_true
        Burrow.is_not_entry?(8).should be_false
        Burrow.is_not_entry?(9).should be_true
        Burrow.is_not_entry?(10).should be_true
        Burrow.is_not_entry?(11).should be_false
      end

      it "solution1 of test input should be 12521" do
        b = Burrow.new input
        b.solve1.should eq(12521)
      end
    end
  end
end
