require "./spec_helper"

include AdventOfCode2021::Day19

describe AdventOfCode2021, focus: true do
  it "Product of rotating matrices should be an other rotating matrix" do
    (RotatingMatrix.tx * RotatingMatrix.tx * RotatingMatrix.tx * RotatingMatrix.tx).should eq RotatingMatrix.t0
    (RotatingMatrix.tx * RotatingMatrix.tx * RotatingMatrix.tx * RotatingMatrix.tx * RotatingMatrix.tx * RotatingMatrix.tx).should eq RotatingMatrix.tx

    (RotatingMatrix.ty * RotatingMatrix.ty * RotatingMatrix.ty * RotatingMatrix.ty).should eq RotatingMatrix.t0
    (RotatingMatrix.ty * RotatingMatrix.ty * RotatingMatrix.ty * RotatingMatrix.ty * RotatingMatrix.ty * RotatingMatrix.ty).should eq RotatingMatrix.ty

    (RotatingMatrix.tz * RotatingMatrix.tz * RotatingMatrix.tz * RotatingMatrix.tz).should eq RotatingMatrix.t0
    (RotatingMatrix.tz * RotatingMatrix.tz * RotatingMatrix.tz * RotatingMatrix.tz * RotatingMatrix.tz * RotatingMatrix.tz).should eq RotatingMatrix.tz

    RotatingMatrix.tx.pow(0).should eq RotatingMatrix.t0
    RotatingMatrix.tx.pow(1).should eq RotatingMatrix.tx
    RotatingMatrix.tx.pow(3).should eq RotatingMatrix.tx * RotatingMatrix.tx
    RotatingMatrix.tx.pow(3).should eq RotatingMatrix.tx * RotatingMatrix.tx * RotatingMatrix.tx
    RotatingMatrix.tx.pow(4).should eq RotatingMatrix.t0
    RotatingMatrix.tx.pow(7).should eq RotatingMatrix.tx.pow(3)
    t1 = RotatingMatrix.tx.pow(3) * RotatingMatrix.tx.pow(2) * RotatingMatrix.tz.pow(1)
    t1.pow(3).should eq t1 * t1 * t1
    t1.pow(4).should eq t1 * t1 * t1 * t1
  end

  it "There should be 24 unique roration matrices" do
    rotations = RotatingMatrix.all_rotations
    rotations.size.should eq 24
  end

  it "Product of a beam and a rotating matrix should be an other beam" do
    beam = Beam.new 1, 2, 3
    (beam * RotatingMatrix.t0).should eq beam
    (beam * RotatingMatrix.tx * RotatingMatrix.tx * RotatingMatrix.tx * RotatingMatrix.tx ).should eq beam
  end

  it "Addition of beam should be valid" do
    b1 = Beam.new(1,2,3)
    (b1 + b1).should eq Beam.new(2,4,6)
    (b1 - b1).should eq Beam.new(0,0,0)
  end

  it "Transformation should work on all of the beams of a scanner" do
    scanners = ScannerSet.new(File.read "./src/day19/input.txt")

    s1 = scanners[0]
    s2 = s1 * RotatingMatrix.t0 
    s1.should eq s2

    tx = RotatingMatrix.tx
    s2 = s1 * tx * tx * tx * tx
    s2.should eq s1
  end

  it "Scanner 0 and scanner 1 and other scanners from example should overlap" do
    scanners = ScannerSet.new(File.read "./src/day19/input.txt")

    puts scanners.get_common_beams(scanners[0], scanners[1])
    #puts scanners.get_common_beams(scanners[0], scanners[4])
  end

  it "day19 should work" do
    scanners = ScannerSet.new(File.read "./src/day19/input.txt")
    AdventOfCode2021::Day19.solution1(scanners).should eq(0)
    AdventOfCode2021::Day19.solution2(scanners).should eq(0)
  end
end
