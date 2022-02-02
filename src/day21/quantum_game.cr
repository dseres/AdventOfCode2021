require "./*"

module AdventOfCode2021::Day21
  class QuantumDiracDiceGame
    MAX_POINTS = 21
    MAX_ROLL   =  9
    POSITIONS  = 10

    struct Player
      getter position : Int8
      getter score = 0_i8

      def initialize(@position); end

      def to_s(io : IO)
        io.print "Player[ position : #{position}, score : #{score}, wins : #{wins}] "
      end

      def do_turn(roll : Int32)
        @position += roll
        while @position > 10
          @position -= 10
        end
        @score += @position
      end

      def wins?
        @score >= MAX_POINTS
      end
    end

    struct Universe
      getter current_player = 0_i8
      getter player1 : Player
      getter player2 : Player
      getter counter = 1_i64

      def initialize(@player1, @player2); end

      def do_turn(roll, count)
        if @current_player == 0
          @player1.do_turn roll
          @current_player = 1
        else
          @player2.do_turn roll
          @current_player = 0
        end
        @counter = @counter * count
      end
    end

    @won1 = 0_i64
    @won2 = 0_i64
    @u : Universe

    def initialize(str : String)
      @u = parse_input str
    end

    private def parse_input(str) : Universe
      str.lines[0] =~ /^Player 1 starting position: (\d+)$/
      player1 = Player.new($~[1].to_i8)
      str.lines[1] =~ /^Player 2 starting position: (\d+)$/
      player2 = Player.new($~[1].to_i8)
      Universe.new(player1, player2)
    end

    # dice combination will show the sum of 3 rolls how many times equal
    # see tally function in crystal documentation
    # the array will be {3 => 1, 4  => 3, 5 => 6, 6 => 7, 7 => 6, 8 => 3, 9 => 1}
    # which means 5 can be rolled out with 3 dice 6 ways
    @@roll_prevalence : Hash(Int32, Int32) = [1, 2, 3].cartesian_product({1, 2, 3}, {1, 2, 3}).map(&.sum).tally

    def perform(uni : Universe)
      @@roll_prevalence.each do |roll, count|
        uni2 = uni
        uni2.do_turn roll, count
        if uni2.player1.score >= MAX_POINTS
          @won1 += uni2.counter
        elsif uni2.player2.score >= MAX_POINTS
          @won2 += uni2.counter
        else
          perform uni2
        end
      end
    end

    def perform
      perform(@u)
    end

    def solution
      # pp! @won1, @won2
      Math.max(@won1, @won2)
    end
  end
end
