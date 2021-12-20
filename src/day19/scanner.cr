require "./beam.cr"

module AdventOfCode2021::Day19
  extend self

  class Scanner
    include Enumerable(Beam)
    property id : Int32
    property beams = [] of Beam

    def initialize(@id, @beams = [] of Beam); end

    def [](i : Int32)
      @beams[i]
    end

    def size
      @beams.size
    end

    def each
      beams.each do |b|
        yield b
      end
    end

    def *(matrix : RotatingMatrix) : Scanner
      Scanner.new(@id, beams.map { |beam| beam * matrix })
    end

    def +(add : Beam) : Scanner
      Scanner.new(@id, beams.map &.+(add))
    end

    def ==(other : Scanner)
      @id == other.id && @beams == other.beams
    end

    def ==(other)
      false
    end
  end
end
