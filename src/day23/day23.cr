module AdventOfCode2021
  module Day23
    extend self

    DAY = 23

    enum RoomType
      Empty
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

    class Amphipoda
      getter id : Int32
      getter type : AmphipodaType
      getter position : Tuple(Int32, Int32)
      getter used_energy : Int32
      getter starting_position : Tuple(Int32, Int32)
      getter prev_position : Tuple(Int32, Int32) | Nil

      @@energies : StaticArray(Int32, 4) = StaticArray[1, 10, 100, 1000]

      def initialize(@id, @type, @position)
        @used_energy = 0
        @starting_position = @position
        @prev_position = nil
      end

      def initialize(@id, @type, @position, @used_energy, @starting_position, @prev_position)
      end

      def to_s( io : IO ) 
        io<<"#{'A' + type.to_i} id: #{@id} position: #{@position}, used_energy: #{@used_energy}"
      end

      def energy : Int32
        @@energies[@type.to_i]
      end


      def clone : Amphipoda
        Amphipoda.new(@id, @type, @position, @used_energy, @starting_position, @prev_position)
      end

      def step(new_pos) 
        @prev_position = @position
        @position = new_pos
        @used_energy + @@energies[ @type.to_i]
      end

      def next_round 
        @prev_position = nil
        @starting_position = @position
      end

      def room_to_occupy : RoomType
        RoomType.new(@type.to_i + RoomType::Room_A.to_i)
      end

      def next_positions : Array(Tuple(Int32,Int32))
        [{-1, 0}, {1, 0}, {0, -1}, {0, 1}].map{|x,y| {@position[0] + x, @position[1] + y} }.select &.!=(@prev_position)
      end

    end

    struct Tile
      property type : RoomType = RoomType::Wall
      property amp : Amphipoda|Nil = nil

      def initialize(@type, @amp); end

      def initialize(c : Char, id : Int32, pos_x : Int32 , pos_y : Int32)
        case c
        when ' '
          @type = RoomType::Empty
        when '#'
          @type = RoomType::Wall
        when '.'
          case pos_y
          when 3, 5, 7, 9
            @type = RoomType::Hallway_No_Stop
          else
            @type = RoomType::Hallway
          end
        when 'A', 'B', 'C', 'D'
          @type = RoomType::Room_A + (pos_y - 3) // 2 # x could be 3,5,7,9
          @amp = Amphipoda.new(id, AmphipodaType::Amber + (c - 'A'), {pos_x, pos_y})
        end
      end

      def to_s(io : IO) : Nil
        amp = @amp
        if amp.nil?
          case @type
          when RoomType::Empty
            io<<' '
          when RoomType::Wall
            io<<'#'
          else
            io<<'.'
          end
        else
          io<<('A' + amp.type.to_i)
        end
      end

      def is_room?
        return @type == RoomType::Room_A || @type == RoomType::Room_B || @type == RoomType::Room_C || @type == RoomType::Room_D
      end

      def is_hallway?
        return @type == RoomType::Hallway
      end

      def is_hallway_no_stop?
        return @type == RoomType::Hallway_No_Stop
      end

      def is_wall?
        return @type == RoomType::Wall
      end

      def has_no_bad_amphipod?
        amp = @amp
        amp.nil? || amp.room_to_occupy == type
      end

    end

    class Burrow
      getter tiles = [] of Array(Tile)
      getter amphipodas = [] of Amphipoda
      getter solutions1 = [] of Burrow

      def initialize(str : String)
        parse_input str
      end

      def solved?(amps : Array(Amphipoda)) : Bool
        amps.all? { |a| get_room_type(a.position) == a.room_to_occupy}
      end

      private def parse_input(input : String)
        @tiles = input.lines.map_with_index do |line, x|
          line.ljust(13, ' ').chars.map_with_index do |c, y|
            parse_tile c,x,y
          end
        end
      end

      private def parse_tile(c, x, y)
        r = Tile.new(c, @amphipodas.size, x, y)
        amp = r.amp
        if !amp.nil?
          @amphipodas<<amp
        end
        r
      end

      def to_s(io : IO) : Nil
        tiles.each do |line|
          line.each { |r| io << r }
          io<<"\n"
        end
        amphipodas.each do |amp| 
          io << amp
          io<<"\n"
        end
      end

      def solve1 : Int32?
        puts "Burrow read :\n#{self}"
        check_next_movements @amphipodas
        @solutions1.min_of { |burrow| burrow.amphipodas.sum &.used_energy }
      end

      def check_next_movements(amps)
        amps.each_with_index do |a, i|
          puts "check_next_movement of #{a}"
          find_possible_new_pos(a).each do |b|
            amps2 = amps.clone
            amps2[i] = b
            # if solved?(amps2)
            #   solution1 << amps2
            # else
            #   check_next_movements amps2
            # end
          end
        end
      end

      def find_possible_new_pos(amp : Amphipoda) : Array(Amphipoda)
        next_amps = [] of Amphipoda
        amp.next_positions.each do |new_pos|
          if is_valid_step?(amp, new_pos)
            new_amp = amp.clone
            new_amp.step new_pos
            if is_final_step?( new_amp, new_pos)
              puts "new pos found: #{new_pos}"
              next_amp = new_amp.clone
              next_amp.next_round
              next_amps << next_amp
            end
            next_amps += find_possible_new_pos(new_amp)
          end
        end
        next_amps
      end

      private def is_valid_step?(amp : Amphipoda, new_pos) : Bool
        tile = get_tile new_pos
        return false if tile.is_wall? || !tile.amp.nil? 
        starting_tile = get_tile amp.starting_position
        #starting tile can be room all hallway
        return true if starting_tile.is_room? # from room amp can step to any other tile
        return true if tile.is_hallway? || tile.is_hallway_no_stop? 
        other_room = get_tile({ 5 - new_pos[0], new_pos[1]}) #rooms have coordinates x = 2 or x = 3 
        return tile.type == amp.room_to_occupy && other_room.has_no_bad_amphipod?
      end


      private def is_final_step?(amp : Amphipoda, new_pos) : Bool
        tile = get_tile new_pos
        starting_tile = get_tile amp.starting_position
        if tile.is_hallway? && starting_tile.is_room?
          return true
        elsif tile.is_room? && starting_tile.is_hallway? 
          other_room = get_tile({ 5 - new_pos[0], new_pos[1]}) #rooms have coordinates x = 2 or x = 3 
          return new_pos[0] == 3 || !other_room.amp.nil? # ampiphod can stop only on bottoem
        end
        false
      end


      private def get_tile(pos)
        @tiles[pos[0]][pos[1]]
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
