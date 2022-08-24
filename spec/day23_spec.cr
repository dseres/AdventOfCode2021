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
    describe "is_type?" do
      it "is_type? should return true on valid ampiphod types" do
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
        room.amphipodas.should eq([COPPER])
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

      it "clone should deep copy everything except solutions" do
        b = Burrow.new
        c = b.clone
        b.hallway.==(c.hallway).should be_true
        b.rooms.==(c.rooms).should be_false # rooms are compared by refererence
        b.used_energy.==(c.used_energy).should be_true
        b.solutions.same?(c.solutions).should be_true
      end

      it "solved? should be false for input, and should be true for a presolved input" do
        b = Burrow.new(input)
        b.solved?.should be_false

        s = Burrow.new(solved_input)
        s.solved?.should be_true
      end

      it "room_index_to_hallway function should give the index of hallway at the entry of that room" do
        Burrow.room_index_to_hallway(0).should eq(2)
        Burrow.room_index_to_hallway(1).should eq(4)
        Burrow.room_index_to_hallway(2).should eq(6)
        Burrow.room_index_to_hallway(3).should eq(8)
      end

      it "hallway_index_to_room function should give the index of room from index of hallway entry" do
        Burrow.hallway_index_to_room(2).should eq(0)
        Burrow.hallway_index_to_room(4).should eq(1)
        Burrow.hallway_index_to_room(6).should eq(2)
        Burrow.hallway_index_to_room(8).should eq(3)
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

      it "energy_of should give 1,10,100,1000 for ampiphoda's type" do
        Burrow.energy_of(AMBER).should eq(1)
        Burrow.energy_of(BRONZE).should eq(10)
        Burrow.energy_of(COPPER).should eq(100)
        Burrow.energy_of(DESERT).should eq(1000)
        expect_raises(OverflowError) do
          Burrow.energy_of(EMPTY)
        end
        expect_raises(IndexError) do
          Burrow.energy_of(255.to_u8)
        end
      end

      it "test of move_amp_*_room should give proper result of ampiphods and energy" do
        b = Burrow.new input
        b.move_amp_r2h 1, 1
        result = <<-INPUT
        #############
        #.C.........#
        ###B#.#B#D###
          #A#D#C#A#
          #########
        INPUT
        b.to_s.should eq(result)
        b.used_energy.should eq(400)

        b.move_amp_r2h 2, 9
        result = <<-INPUT
        #############
        #.C.......B.#
        ###B#.#.#D###
          #A#D#C#A#
          #########
        INPUT
        b.to_s.should eq(result)
        b.used_energy.should eq(440)

        b.move_amp_h2r 1, 2
        result = <<-INPUT
        #############
        #.........B.#
        ###B#.#C#D###
          #A#D#C#A#
          #########
        INPUT
        b.to_s.should eq(result)
        b.used_energy.should eq(1040)
      end

      it "Check some simple input for solution" do
        simple = <<-INPUT
        #############
        #.A.........#
        ###.#B#C#D###
          #A#B#C#D#
          #########
        INPUT
        b = Burrow.new simple
        b.to_s.should eq(simple)
        b.solve.should eq(2)

        simple = <<-INPUT
        #############
        #.A.A.......#
        ###.#B#C#D###
          #.#B#C#D#
          #########
        INPUT
        b = Burrow.new simple
        b.to_s.should eq(simple)
        b.solve.should eq(5)

        simple = <<-INPUT
        #############
        #.A.........#
        ###B#.#C#D###
          #A#B#C#D#
          #########
        INPUT
        b = Burrow.new simple
        b.to_s.should eq(simple)
        b.solve.should eq(42)
      end

      it "a little bit more complicated example to solve function" do
        input2 = <<-INPUT
        #############
        #...........#
        ###D#B#C#D###
          #A#B#C#A#
          #########
        INPUT
        b = Burrow.new input2
        b.move_amp_r2h 3, 7
        b.used_energy.should eq(2000)
        b.move_amp_r2h 3, 9
        b.used_energy.should eq(2003)
        b.move_amp_h2r 7, 3
        b.used_energy.should eq(5003)
        b.move_amp_r2h 0, 7
        b.used_energy.should eq(11003)
        b.move_amp_h2r 7, 3
        b.used_energy.should eq(13003)
        b.move_amp_h2r 9, 0
        b.used_energy.should eq(13011)
        b.solved?.should be_true
        
        b = Burrow.new input2
        b.solve.should eq(2000 + 3 + 3000 + 8000 + 8)
      end

      it "solve function should return nil if problem not solvable" do
        not_solvable = <<-INPUT
        #############
        #.B.A.......#
        ###.#.#C#D###
          #B#D#C#A#
          #########
        INPUT
        b = Burrow.new not_solvable
        b.solve.should be_nil
      end

      it "solve function should return 0 to solved input" do
        b = Burrow.new solved_input
        b.solve.should eq(0)
      end

      it "solution1 of test input should be 12521" do
        b = Burrow.new input
        b.solve.should eq(12521)
      end
    end
  end
end
