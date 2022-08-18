module AdventOfCode2021
  extend self

  module Day23
    extend self
    DAY = 23

    WALL   = '#'.bytes[0]
    EMPTY  = '.'.bytes[0]
    AMBER  = 'A'.bytes[0]
    BRONZE = 'B'.bytes[0]
    COPPER = 'C'.bytes[0]
    DESERT = 'D'.bytes[0]

    def is_type?(t : UInt8) : Bool
      case t
      when AMBER..DESERT then true
      else                    false
      end
    end

    class Room
      SIZE = 2
      getter type
      getter amphipodas

      def initialize(@type : UInt8, @amphipodas : Array(UInt8) = Array(UInt8).new(SIZE))
        raise Exception.new("Type cannot be None") if @type == EMPTY
        raise Exception.new("Cannot add more amphipods then #{SIZE}") if @amphipodas.size > SIZE
        raise Exception.new("Amphipodas cannot contain EMPTY") if @amphipodas.any? &.== EMPTY
      end

      def clone
        Room.new(@type, @amphipodas.clone)
      end

      def can_pop? : Bool
        !@amphipodas.empty? && @amphipodas.any? &.!= @type
      end

      def pop : Tuple(UInt8, Int32) | Nil
        return nil if !can_pop?
        {@amphipodas.pop, SIZE - @amphipodas.size}
      end

      def can_push?(amp : UInt8) : Bool
        @type == amp && @amphipodas.size < SIZE && @amphipodas.all? &.== @type
      end

      # Returns the number of steps
      def push(amp : UInt8) : Int32 | Nil
        return nil if !can_push?(amp)
        @amphipodas << amp
        SIZE - @amphipodas.size + 1
      end

      def solved? : Bool
        @amphipodas.size == SIZE && @amphipodas.all? &.== @type
      end
    end

    class Burrow
      include AdventOfCode2021::Day23
      getter hallway = StaticArray(UInt8, 11).new(EMPTY)
      getter rooms = StaticArray(Room, 4).new { |i| AdventOfCode2021::Day23::Room.new(AdventOfCode2021::Day23::AMBER + i.to_u8) }
      getter used_energy = 0
      getter solutions1 = [] of Burrow
      getter min_energy1 = 0

      @@energies : StaticArray(Int32, 4) = StaticArray[1, 10, 100, 1000]

      def initialize; end

      def initialize(@hallway, @rooms, @used_energy, @solutions1, @min_energy1); end

      def clone
        Burrow.new(@hallway.clone, @rooms.clone, @used_energy, @solutions1, @min_energy1)
      end

      def initialize(str : String)
        parse_input(str)
      end

      private def parse_input(input : String)
        lines = input.lines
        (0...@rooms.size).each do |i|
          first = lines[3].byte_at(3 + 2*i)
          second = lines[2].byte_at(3 + 2*i)
          @rooms[i] = Room.new(AMBER + i.to_u8, [first, second])
        end
      end

      def to_s(io : IO) : Nil
        io << "#############\n"
        io << "#...........#\n"
        first_line_to_s io
        second_line_to_s io
        io << "  #########"
      end

      private def first_line_to_s(io)
        io << "##"
        (0...@rooms.size).each do |i|
          io << "#"
          if @rooms[i].amphipodas.size > 1
            io.write_byte @rooms[i].amphipodas[1]
          else
            io << EMPTY
          end
        end
        io << "###\n"
      end

      private def second_line_to_s(io)
        io << "  "
        (0...@rooms.size).each do |i|
          io << "#"
          unless @rooms[i].amphipodas.empty?
            io.write_byte @rooms[i].amphipodas[0]
          else
            io << EMPTY
          end
        end
        io << "#\n"
      end

      def solved? : Bool
        @rooms.all? &.solved?
      end

      def solve1 : Int32?
        iterate_over_amphipods
        12521
      end

      private def iterate_over_amphipods
        puts "Burrow :\n#{self}"
        puts "Press enter...  "
        gets
        checks_amps_in_hallway
        checks_amps_in_rooms
      end

      private def checks_amps_in_hallway
      end

      private def checks_amps_in_rooms
        @rooms.each_with_index do | room, i |
          if room.can_pop? 
            check_next_movement room,i
          end
        end
      end

      private def check_next_movement(idx : Int32)
      end

      private def check_next_movement(room : Room, idx : Int32)
        h = idx * 2 + 2;
        steps = 0
        (0...h).reverse_each do |i|
          steps += 1
          break if @hallway[i] != EMPTY
          if Burrow.is_not_entry? i
            # these fields will be a valid move
            # move amphipod from rooms[idx] to hallway[i]
          end
        end
        steps = 0
        ((h+1)...@hallway.sizes).each do |i|
          steps += 1
          break if @hallway[i] != EMPTY
          if Burrow.is_not_entry? i
            #these fields will be a valid move
            # move amphipod from rooms[idx] to hallway[i]
          end
        end
      end

      def self.index_of_room_entry(r : Int32) : Int32
        2 + r * 2
      end

      def self.is_entry?( h : Int32) : Bool
        case h
        when 2,4,6,8 then true
        else false
        end
      end

      def self.is_not_entry?( h : Int32) : Bool
        (0..10).includes?(h) && !Burrow.is_entry?(h)
      end

      private def move_amp_from_room(r,h)
        amp,energy = @rooms[r].pop
        energy += h  
      end
      
      #   def check_next_movements
      #     #puts "Burrow :\n#{self}"
      #     #puts "Press enter...  "
      #     #gets
      #     @amphipodas.each do |a|
      #       if !on_place? a
      #         #puts "Find possible new movements of #{a}..."
      #         find_possible_new_pos(a).each do |b|
      #           #puts "Found new position: #{b}"
      #           burrow = next_burrow a,b
      #           if burrow.solved?
      #             @solutions1 << burrow
      #           else
      #             min_used_energy = @solutions1.min_of? &.used_energy
      #             pp! min_used_energy, burrow.used_energy, @solutions1.size
      #             if min_used_energy.nil? || burrow.used_energy < min_used_energy
      #               burrow.check_next_movements
      #             end
      #           end
      #         end
      #       end
      #     end
      #   end

      #   private def find_possible_new_pos(amp)
      #     next_amps = [] of Amphipoda
      #     amp.next_positions.each do |new_pos|
      #       if is_valid_step?(amp, new_pos)
      #         new_amp = amp.clone
      #         new_amp.step new_pos
      #         if is_final_step?( new_amp )
      #           #puts "new pos found: #{new_pos}"
      #           next_amp = new_amp.clone
      #           next_amp.finish_step
      #           next_amps << next_amp
      #         end
      #         next_amps += find_possible_new_pos(new_amp)
      #       end
      #     end
      #     next_amps
      #   end

      #   private def on_place?(amp)
      #     tile = get_tile amp.position
      #     #pp! "on_place?", amp, tile.type
      #     return false unless amp.room_to_occupy == tile.type;
      #     pos_x,pos_y = amp.position
      #     return true if pos_x == 3
      #     other_tile = get_tile({3 , pos_y})
      #     return other_tile.has_good_amphipod?
      #   end

      #   private def is_valid_step?(amp, new_pos)
      #     tile = get_tile new_pos
      #     #pp! "is_valid_step?", amp, new_pos, tile.type
      #     return false if tile.is_wall? || !tile.amp.nil?
      #     starting_tile = get_tile amp.starting_position
      #     #pp! starting_tile.type
      #     #starting tile can be room or hallway
      #     return true if starting_tile.is_room? # amp can step to any other tile from a room tile
      #     return true if tile.is_hallway? || tile.is_no_stop?
      #     other_room = get_tile({ 5 - new_pos[0], new_pos[1]}) #rooms have coordinates x = 2 or x = 3
      #     return tile.type == amp.room_to_occupy && other_room.has_no_bad_amphipod?
      #   end

      #   private def is_final_step?(amp)
      #     tile = get_tile amp.position
      #     starting_tile = get_tile amp.starting_position
      #     #pp! "is_final_step?", amp, tile.type, starting_tile.type
      #     if tile.is_hallway? && starting_tile.is_room?
      #       return true
      #     elsif tile.is_room? && starting_tile.is_hallway?
      #       #pp! other_room
      #       return true if amp.position[0] == 3  # ampiphod can stop only on bottoem
      #       other_room = get_tile({ 3, amp.position[1]}) #rooms have coordinates x = 2 or x = 3
      #       return other_room.has_good_amphipod?
      #     end
      #     return false
      #   end

      #   private def get_tile(pos)
      #     @tiles[pos[0]][pos[1]]
      #   end

      #   private def next_burrow(amp_old, amp_new)
      #     tiles = @tiles.clone
      #     tile = get_tile amp_new.position
      #     tile_old = get_tile amp_old.position
      #     set_tile tiles, amp_new.position, Tile.new( tile.type, amp_new)
      #     set_tile tiles, amp_old.position, Tile.new( tile_old.type, nil)
      #     amps = @amphipodas.dup
      #     amps[amp_old.id] = amp_new
      #     Burrow.new tiles, amps, @solutions1
      #   end

      #   private def set_tile(tiles, pos, tile)
      #     tiles[pos[0]][pos[1]] = tile
      #   end

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
