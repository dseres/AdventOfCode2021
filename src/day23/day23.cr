module AdventOfCode2021
  module Day23
    extend self

    DAY = 23

    enum RoomType
      Wall
      Hallway
      Hallway_No_Stop
      Room_A
      Room_B
      Room_C
      Room_D
    end

    enum AmphipodaType
      Amber
      Bronze
      Copper
      Desert
    end

    struct Amphipoda
      getter id : Int32
      getter type : AmphipodaType
      getter position : Tuple(Int32, Int32)
      getter used_energy : Int32
      getter starting_position : Tuple(Int32, Int32)
      getter prev_position : Tuple(Int32, Int32) | Nil

      def initialize(@id, @type, @position)
        @used_energy = 0
        @starting_position = @position
        @prev_position = nil
      end

      def initialize(@id, @type, @position, @used_energy, @starting_position, @prev_position)
      end

      @@energies : StaticArray(Int32, 4) = StaticArray[1, 10, 100, 1000]

      def energy : Int32
        @@energies[@type.to_i]
      end

      def clone : Amphipoda
        Amphipoda.new(@id, @type, @position, @used_energy, @starting_position, @prev_position)
      end

      def step(new_pos) : Amphipoda
        Amphipoda.new(@id, @type, new_pos, next_energy, @starting_position, @position)
      end

      def step_for_next_round(new_pos) : Amphipoda
        Amphipoda.new(@id, @type, new_pos, next_energy, new_pos, nil)
      end

      def room_to_occupy : RoomType
        RoomType.new(@type.to_i + RoomType::Room_A.to_i)
      end

      def next_energy
        @used_energy + @@energies[ @type.to_i]
      end
    end

    class Burrow
      getter rooms = [] of Array(RoomType)
      getter amphipodas = [] of Amphipoda
      getter solution1 = [] of Array(Amphipoda)

      def initialize(str : String)
        parse_input str
      end

      def solved?(amps : Array(Amphipoda)) : Bool
        amps.all? { |a| get_room_type(a.position) == a.room_to_occupy}
      end

      def to_s(io : IO)
      end

      private def parse_input(input : String)
        # puts "Input: #{input.lines}"
        @rooms = input.lines.map_with_index do |line, i|
          line.gsub(' ', '#').ljust(13, '#').chars.map_with_index do |c, j|
            parse_room_char(c, i, j)
          end
        end
        @amphipodas = @amphipodas.sort { |a, b| a.type <=> b.type }
        @rooms.each { |line| puts "#{line}" }
        @amphipodas.each { |amp| puts "#{amp}" }
      end

      private def parse_room_char(c, i, j) : RoomType
        case c
        when '#'
          return RoomType::Wall
        when '.'
          case j
          when 3, 5, 7, 9
            return RoomType::Hallway_No_Stop
          else
            return RoomType::Hallway
          end
        when 'A', 'B', 'C', 'D'
          amphipodas << Amphipoda.new(amphipodas.size, AmphipodaType::Amber + (c - 'A'), {i, j})
          room_type = RoomType::Room_A + (j - 3) // 2 # j could be 3,5,7,9
          return room_type
        end
        return RoomType::Wall
      end

      def solve1 : Int32?
        check_next_movements @amphipodas
        solution1.min_of? { |amps| amps.sum &.used_energy }
      end

      def check_next_movements(amps)
        amps.each_with_index do |a, i|
          puts "check_next_movement of #{a}"
          find_possible_new_pos(a).each do |b|
            amps2 = amps.clone
            amps2[i] = b
            if solved?(amps2)
              solution1 << amps2
            else
              check_next_movements amps2
            end
          end
        end
      end


      def find_possible_new_pos(amp : Amphipoda) : Array(Amphipoda)
        next_amps = [] of Amphipoda
        steps = [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
        steps.each do |x, y|
          new_pos = {amp.position[0] + x, amp.position[1] + y}
          if is_new_pos_valid?(amp, new_pos)
            new_amp = amp.step(new_pos)
            if is_new_pos_step?( amp, new_pos)
              puts "new pos found: #{new_pos}"
              next_amps << amp.step_for_next_round(new_pos)
            end
            next_amps += find_possible_new_pos(new_amp)
          end
        end
        next_amps
      end

      private def is_new_pos_valid?(amp : Amphipoda, new_pos) : Bool
        !(!amp.prev_position.nil? && new_pos == amp.prev_position || get_room_type(new_pos) == RoomType::Wall || amphipodas.any? { |a| a.position == new_pos && a.id != amp.id }) && ( !is_room?(new_pos) || room_has_proper_amphipods(new_pos))
      end

      private def is_new_pos_step?(amp : Amphipoda, new_pos) : Bool
        is_hallway?(new_pos) && is_room?(amp.starting_position) || is_room?(new_pos) && is_hallway?(amp.starting_position)
      end

      def get_room_type(pos_x : Int32, pos_y : Int32) : RoomType
        @rooms[pos_x][pos_y]
      end

      def get_room_type(pos : Tuple(Int32, Int32) = @position) : RoomType
        get_room_type pos[0], pos[1]
      end

      def is_hallway?(pos)
        get_room_type(pos) == RoomType::Hallway
      end

      def is_room?(pos)
        rt = get_room_type(pos)
        return rt == RoomType::Room_A || rt == RoomType::Room_B || rt == RoomType::Room_C || rt == RoomType::Room_D
      end

      def room_has_proper_amphipods(pos)
        is_room?(pos) && amphipodas.none?{ |amp| amp.room_to_occupy != get_room_type(pos) && get_room_type(amp.position) == get_room_type(pos)}
      end

      def solve2
        0
      end
    end

    def main
      burrow = Burrow.new(File.read "./src/day#{DAY}/input.txt")

      puts "Solutions of day#{DAY} : #{burrow.solve1} #{burrow.solve2}"
    end
  end
end
