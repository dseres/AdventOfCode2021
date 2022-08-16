module AdventOfCode2021
  module Day23
    extend self

    DAY = 23

    enum Type
      None
      Amber
      Bronze
      Copper
      Desert
    end

    def from_char(c : Char) : Type
      case c
      when 'A' then Type::Amber
      when 'B' then Type::Bronze
      when 'C' then Type::Copper
      when 'D' then Type::Desert
      else Type::None
      end
    end

    def to_char( t : Type ) : Char
      case t
      when Type::Amber then 'A'
      when Type::Bronze then 'B'
      when Type::Copper then 'C'
      when Type::Desert then 'D'
      else '.'
      end
    end

    class Room
      SIZE = 2
      getter type 
      getter amphipodas 

      def initialize(@type : Type, @amphipodas : Array(Type)); 
        raise Exception.new("Type cannot be None") if @type == Type::None
        raise Exception.new("Cannot add more amphipods then #{SIZE}") if @amphipodas.size > SIZE
        raise Exception.new("Amphipodas cannot be None") if @amphipodas.any? &.== Type::None
      end

      #returns the type and number of steps or nil if there are no ampiphod
      def pop() : Tuple(Type,Int32) | Nil
        return nil if @amphipodas.empty?
        {@amphipodas.pop(), 2 - @amphipodas.size()}
      end

      def can_push?(amp : Type) : Bool
        @type == amp && @amphipodas.size < SIZE && ( @amphipodas.empty? || @amphipodas[0] == @type )
      end

      # Returns the number of steps
      def push( amp : Type) : Int32 | Nil
        return nil unless can_push?(amp)
        @amphipodas<<amp
        3 - @amphipodas.size() 
      end

      def solved? : Bool
        @amphipodas == [@type, @type]
      end

    end

    class Burrow
    #   getter tiles = [] of Array(Tile)
    #   getter amphipodas = [] of Amphipoda
    #   getter solutions1 = [] of Burrow

      def initialize(str : String)
        parse_input str
      end

    #   def initialize(@tiles, @amphipodas, @solutions1 )
    #   end

    #   def solved? : Bool
    #     amphipodas.all? { |amp| get_tile(amp.position).type == amp.room_to_occupy}
    #   end

      private def parse_input(input : String)
      end

    #   private def parse_tile(c, x, y)
    #     r = Tile.new(c, @amphipodas.size, x, y)
    #     amp = r.amp
    #     if !amp.nil?
    #       @amphipodas<<amp
    #     end
    #     r
    #   end

    #   def to_s(io : IO) : Nil
    #     tiles.each do |line|
    #       line.each { |r| io << r }
    #       io<<"\n"
    #     end
    #     amphipodas.each do |amp| 
    #       io << amp
    #       io<<"\n"
    #     end
    #   end

      def solve1 : Int32?
        12521
      end

    #   def used_energy
    #     @amphipodas.sum &.used_energy
    #   end

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
