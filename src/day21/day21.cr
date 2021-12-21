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

    class Player
      property position : Int32
      property score : Int32

      def initialize(@position, @score = 0); end

      def do_turn(dice : Dice) : Int32
        roll = 3.times.map { dice.roll }.sum
        @position = ( @position + roll -1) % 10 + 1
        @score += position
      end

      def do_turn(roll : Int32) : Int32
        @position += roll
        while @position > 10
          @position -= 10
        end
        @score += @position
        @score
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
          break if @p1.score >= 1000
          @p2.do_turn @dice
          # pp! @p2, @dice
          break if @p2.score >= 1000
        end
      end

      def solution : Int32
        (@p1.score >= 1000 ? @p2.score : @p1.score) * @dice.rolled
      end
    end

    class QuantumDiracDiceGame < DiracDiceGame
      def initialize(str : String)
        super str
      end

      def perform
      end

      def solution : Int64
        0.to_i64
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
