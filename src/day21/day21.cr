module AdventOfCode2021
  module Day21
    extend self

    DAY = 21

    class Dice
      getter value = 0
      getter rolled = 0

      def roll
        if @value == 100
          @value = 1
        else
          @value += 1
        end
        @rolled += 1
        @value
      end
    end

    struct Player
      property position : Int32
      property score : Int32
      property wins : Int32

      def initialize(@position, @score = 0, @wins = 0); end

      def do_turn(dice : Dice) : Int32
        roll = 3.times.map { dice.roll }.sum
        do_turn roll
      end

      def do_turn(roll : Int32, counter = 1) : Int32
        @position += roll
        while @position > 10
          @position -= 10
        end
        @score += @position
        if @score >= 1000
          @wins += counter
        end
        @score
      end

      def wins?
        @wins > 0
      end
    end

    class DiracDiceGame
      getter dice = Dice.new
      getter p1 = Player.new(1)
      getter p2 = Player.new(1)

      def initialize(str : String)
        parse_input(str)
      end

      private def parse_input(str)
        str.lines[0] =~ /^Player 1 starting position: (\d+)$/
        @p1 = Player.new($~[1].to_i32)
        str.lines[1] =~ /^Player 2 starting position: (\d+)$/
        @p2 = Player.new($~[1].to_i32)
      end

      def perform
        loop do
          @p1.do_turn @dice
          # pp! @p1, @dice
          break if @p1.wins?
          @p2.do_turn @dice
          # pp! @p2, @dice
          break if @p2.wins?
        end
      end

      def solution : Int32
        (@p1.wins? ? @p2.score : @p1.score) * @dice.rolled
      end
    end

    class UniverseStatus
      # key fields
      property players = [Player.new(1), Player.new(1)]
      property next_player = 0
      # status fields
      property counter = 0

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
        UniverseStatus.new(@position.clone, @score.clone, @next_player.clone, @counter.clone, @wins.clone)
      end

      def ==(other : UniverseStatus)
        @position == other.position && @score == other.score && @next_player == other.next_player
      end

      private def parse_input(str)
        str.lines[0] =~ /^Player 1 starting position: (\d+)$/
        player1 = Player.new($~[1].to_i32)
        str.lines[1] =~ /^Player 2 starting position: (\d+)$/
        player2 = Player.new($~[1].to_i32)
        @players = [player1, player2]
      end

      def roll_and_create_next_universes : Array(UniverseStatus)
        next_unis = Array(UniverseStatus).new
        (3..9).each do |roll|
          uni = self.clone
          uni.do_turn roll
          next_unis << uni
        end
        next_unis
      end

      private def do_turn(roll)
        @counter = @counter + @@roll_prevalence[roll]
        @players[@next_player].do_turn(roll, @counter)
        @next_player = 1 - @next_player
      end

      class Key
        property positions = [1, 1]
        property scores = [0, 0]
        property next_player = 0

        def initialize(@positions, @scores, @next_player); end

        def hash : UInt64
          hash = next_player.to_u64
          hash <<= 5
          hash |= scores[0]
          hash <<= 5
          hash |= scores[1]
          hash <<= 3
          hash |= positions[0]
          hash <<= 3
          hash |= positions[1]
          hash
        end
      end

      def key : Key
        Key.new(@players.map(&.position), @players.map(&.score), @next_player)
      end
    end

    class QuantumDiracDiceGame

      getter universes = Hash(UniverseStatus::Key, UniverseStatus).new

      def initialize(str : String)
        uni = UniverseStatus.new(str)
        universes[uni.key] = uni
      end

    end

    def main
      input = File.read "./src/day#{DAY}/input.txt"
      game = DiracDiceGame.new(input)
      game.perform
      puts "Solutions of day#{DAY} : #{game.solution}"
    end
  end
end
