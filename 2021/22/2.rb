class Range
  def intersection(other)
    return nil if self.max < other.min || other.max < self.min
    [self.min, other.min].max..[self.max, other.max].min
  end
  alias & intersection

  def split(other)
    int = self & other
    raise "error" unless int == other
    ranges = []
    if self.min < other.min
      ranges.push self.min..(other.min-1)
    end
    ranges.push other
    if self.max > other.max
      ranges.push (other.max+1)..self.max
    end
    ranges
  end
end

class Cuboid
  attr_reader :xrange, :yrange, :zrange
  def initialize(xrange, yrange, zrange)
    @xrange, @yrange, @zrange = xrange, yrange, zrange
  end

  def size
    @xrange.size * @yrange.size * @zrange.size
  end

  def intersection(other)
    x = @xrange & other.xrange
    y = @yrange & other.yrange
    z = @zrange & other.zrange
    return nil unless x && y && z
    Cuboid.new(x, y, z)
  end
  alias & intersection

  def ==(other)
    @xrange == other.xrange && @yrange == other.yrange && @zrange == other.zrange
  end

  def split(other)
    int = self & other
    raise "error" unless int == other
    return [self] if self == int
    xranges = @xrange.split(int.xrange)
    yranges = @yrange.split(int.yrange)
    zranges = @zrange.split(int.zrange)
    xranges.product(yranges, zranges).map { |ranges|
      Cuboid.new(*ranges)
    }
  end
end

d = File.read("input").each_line.map(&:strip).map { |l| l.match(/(on|off) (.*)/)[1..2] }.map { |tog, area| [tog == "on" ? true : false, eval(area)] }.map { |tog, area| [tog, Cuboid.new(*area)] }

lit_areas = []
while !d.empty?
  tog, area = d.shift
  if tog
    new_lit_areas = [area]
    while !new_lit_areas.empty?
      ar = new_lit_areas.shift
      split = false
      lit_areas.each { |a|
        int = a & ar
        if int
          split = true
          ars = ar.split(int)
          new_lit_areas += ars.reject { |i| i == int }
          break
        end
      }
      lit_areas.push ar unless split
    end
  else
    new_dark_areas = [area]
    while !new_dark_areas.empty?
      ar = new_dark_areas.shift
      new_lit_areas = []
      split = false
      lit_areas.each { |a|
        if !split
          int = a & ar
          if int
            new_lit_areas += a.split(int).reject { |i| i == int }
            new_dark_areas += ar.split(int).reject { |i| i == int }
          else
            new_lit_areas.push a
          end
        else
          new_lit_areas.push a
        end
      }
      lit_areas = new_lit_areas
    end
  end
end

p lit_areas.map(&:size).sum
