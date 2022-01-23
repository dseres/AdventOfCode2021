require "./*"

module AdventOfCode2021::Day21
  class QuantumDiracDiceGame
    MAX_POINTS = 21

    class UniverseStatus
      # key fields
      property players = [Player.new(1), Player.new(1)]
      property next_player = 0
      # status fields
      property counter : Int64 = 1

      # dice combination will show the sum of 3 rolls how many times equal
      # see tally function in crystal documentation
      # the array will be [0, 0, 0, 1, 3, 6, 7, 6, 3, 1]
      # which means 5 can be rolled out with 3 dice 6 ways
      @@roll_prevalence : Array(Int32) = create_roll_prevalence

      private def self.create_roll_prevalence
        roll_prevalence = Array(Int32).new(10, 0)
        [1, 2, 3].cartesian_product({1, 2, 3}, {1, 2, 3}).map(&.sum).tally.each do |roll, count|
          roll_prevalence[roll] = count
        end
        roll_prevalence
      end

      def initialize; end

      def initialize(@players, @next_player, @counter); end

      def initialize(str : String)
        parse_input(str)
      end

      def clone : UniverseStatus
        UniverseStatus.new(@players.clone, @next_player.clone, @counter.clone)
      end

      def ==(other : UniverseStatus)
        @players == other.players && @counter == other.counter && @next_player == other.next_player
      end

      private def parse_input(str)
        str.lines[0] =~ /^Player 1 starting position: (\d+)$/
        player1 = Player.new($~[1].to_i32)
        str.lines[1] =~ /^Player 2 starting position: (\d+)$/
        player2 = Player.new($~[1].to_i32)
        @players = [player1, player2]
      end

      def to_s(io : IO)
        io.print "UniverseStatus[ counter : #{counter}, next_player : #{next_player}, players : [#{players[0]}, #{players[1]}]] "
      end

      def roll_and_create_next_universes : Array(UniverseStatus)
        (3..9).map do |roll|
          # puts "rolled : #{roll}"
          uni = self.clone
          uni.do_turn roll
        end
      end

      def do_turn(roll) : UniverseStatus
        @counter *= @@roll_prevalence[roll]
        @players[@next_player].do_turn(roll, @counter, MAX_POINTS)
        @next_player = 1 - @next_player
        self
      end

      def merge(other : UniverseStatus)
        raise Exception.new("Unable to merge other UniverseStatus") unless key == other.key
        @counter += other.counter
        players.each_with_index do |p, i|
          p.wins += other.players[i].wins
        end
      end

      class Key
        property positions = [1, 1]
        property scores = [0, 0]
        property next_player = 0

        def initialize(@positions, @scores, @next_player); end

        def hash : UInt64
          hash = next_player.to_u64
          hash <<= 4
          hash |= scores[0]
          hash <<= 4
          hash |= scores[1]
          hash <<= 3
          hash |= positions[0]
          hash <<= 3
          hash |= positions[1]
          hash
        end

        def ==(other : Key)
          positions == other.positions && scores == other.scores && next_player == other.next_player
        end

        def ==(other)
          false
        end

        def to_s(io : IO)
          io.print "Key[ next_player : #{next_player}, positions : [#{positions[0]}, #{positions[1]}], scores : [#{scores[0]}, #{scores[1]}]] "
        end
      end

      def key : Key
        Key.new(@players.map(&.position), @players.map(&.score), @next_player)
      end

      def next_score
        @players[@next_player].score
      end

      def finished?
        players[0].wins?(MAX_POINTS) || players[1].wins?(MAX_POINTS)
      end

      def not_finished?
        !finished?
      end
    end

    getter universes = Hash(UniverseStatus::Key, UniverseStatus).new
    getter not_finished : Array(Array(UniverseStatus))

    def initialize(str : String)
      uni = UniverseStatus.new(str)
      @not_finished = Array(Array(UniverseStatus)).new(MAX_POINTS + 10) { [] of UniverseStatus }
      @not_finished[uni.next_score] << uni
    end

    def perform
      n = 0
      while n < not_finished.size
        unis_to_roll = not_finished[n]
        while !unis_to_roll.empty?
          uni = unis_to_roll.pop
          universes.delete uni.key
          next_unis = uni.roll_and_create_next_universes
          next_unis.each do |u|
            k = u.key
            if universes.has_key? k
              universes[k].merge u
            else
              universes[k] = u
              if u.not_finished?
                not_finished[u.next_score] << u
                if u.next_score < n
                  n = u.next_score - 1
                end
              end
            end
          end
        end
        n += 1
      end
    end

    def solution
      pp! universes.values.sum(&.players[0].wins), universes.values.sum(&.players[1].wins)
      Math.max(universes.values.sum(&.players[0].wins), universes.values.sum(&.players[1].wins))
    end
  end
end
