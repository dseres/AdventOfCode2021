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
        io<<"#{'A' + type.to_i} id: #{@id} position: #{@position}, used_energy: #{@used_energy}, starting_position: #{starting_position}"
      end

      def clone : Amphipoda
        Amphipoda.new(@id, @type, @position, @used_energy, @starting_position, @prev_position)
      end

      def energy : Int32
        @@energies[@type.to_i]
      end

      def step(new_pos) 
        @prev_position = @position
        @position = new_pos
        @used_energy += energy
      end

      def finish_step 
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

      def clone
        Tile.new @type, @amp
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

      def initialize(@tiles, @amphipodas)
      end

      def clone
        Burrow.new(@tiles, @amphipodas)
      end

      def solved? : Bool
        amphipodas.all? { |amp| get_tile(amp.position).type == amp.room_to_occupy}
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
        #puts "Burrow read :\n#{self}"
        check_next_movements 
        @solutions1.min_of { |burrow| burrow.amphipodas.sum &.used_energy }
      end

      def check_next_movements
        #puts "Burrow :\n#{self}"
        #puts "Press enter...  "
        #gets
        @amphipodas.each_with_index do |a, i|
          if !on_place? a
            #puts "Find possible new movements of #{a}..."
            find_possible_new_pos(a).each do |b|
              #puts "Found new position: #{b}"
              burrow = next_burrow a,b
              if burrow.solved?
                @solutions1 << burrow
              else
                burrow.check_next_movements
              end
            end
          end
        end
      end

      private def find_possible_new_pos(amp : Amphipoda) : Array(Amphipoda)
        next_amps = [] of Amphipoda
        amp.next_positions.each do |new_pos|
          if is_valid_step?(amp, new_pos)
            new_amp = amp.clone
            new_amp.step new_pos
            if is_final_step?( new_amp )
              #puts "new pos found: #{new_pos}"
              next_amp = new_amp.clone
              next_amp.finish_step
              next_amps << next_amp
            end
            next_amps += find_possible_new_pos(new_amp)
          end
        end
        next_amps
      end

      private def on_place?(amp) 
        tile = get_tile amp.position
        #pp! "on_place?", amp, tile.type
        pos_x,pos_y = amp.position
        return false unless tile.is_room?
        return false unless amp.room_to_occupy == tile.type;
        return true if pos_x == 3 
        other_tile = get_tile({3 , pos_y})
        other_amp = other_tile.amp
        return true if pos_x == 2 && !other_amp.nil? && other_amp.room_to_occupy == other_tile.type
        return false
      end

      private def is_valid_step?(amp : Amphipoda, new_pos) : Bool
        tile = get_tile new_pos
        #pp! "is_valid_step?", amp, new_pos, tile.type
        return false if tile.is_wall? || !tile.amp.nil? 
        starting_tile = get_tile amp.starting_position
        #pp! starting_tile.type
        #starting tile can be room or hallway
        return true if starting_tile.is_room? # from room amp can step to any other tile
        return true if tile.is_hallway? || tile.is_hallway_no_stop? 
        other_room = get_tile({ 5 - new_pos[0], new_pos[1]}) #rooms have coordinates x = 2 or x = 3 
        return tile.type == amp.room_to_occupy && other_room.has_no_bad_amphipod?
      end


      private def is_final_step?(amp : Amphipoda) : Bool
        tile = get_tile amp.position
        starting_tile = get_tile amp.starting_position
        #pp! "is_final_step?", amp, tile.type, starting_tile.type
        if tile.is_hallway? && starting_tile.is_room?
          return true
        elsif tile.is_room? && starting_tile.is_hallway? 
          other_room = get_tile({ 3, amp.position[1]}) #rooms have coordinates x = 2 or x = 3 
          #pp! other_room
          return amp.position[0] == 3 || amp.position[0] == 2 && !other_room.amp.nil? # ampiphod can stop only on bottoem
        end
        return false
      end


      private def get_tile(pos)
        @tiles[pos[0]][pos[1]]
      end
      
      private def next_burrow(amp_old, amp_new)
        tiles = @tiles.clone
        tile = get_tile amp_new.position
        tile_old = get_tile amp_old.position
        set_tile tiles, amp_new.position, Tile.new( tile.type, amp_new)
        set_tile tiles, amp_old.position, Tile.new( tile_old.type, nil)
        amps = @amphipodas.clone
        amps[amp_old.id] = amp_new
        Burrow.new tiles, amps
      end


      private def set_tile(tiles, pos, tile)
        tiles[pos[0]][pos[1]] = tile
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
