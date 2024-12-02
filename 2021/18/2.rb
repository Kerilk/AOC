class Num
  attr_reader :left, :right
  attr_accessor :parent

  def initialize(left, right)
    @left = left
    @right = right
  end

  def self.parse_member(chars)
    if chars.first == "["
      parse(chars)
    else
      chars.shift.to_i
    end
  end

  def self.parse(chars)
    char = chars.shift
    raise "error" unless char == "["
    left = parse_member(chars)
    char = chars.shift
    raise "error" unless char == ","
    right = parse_member(chars)
    char = chars.shift
    raise "error" unless char == "]"
    v = self.new(left, right)
    left.parent = v if left.kind_of?(Num)
    right.parent = v if right.kind_of?(Num)
    v
  end

  def to_s
    "[#{@left},#{@right}]"
  end

  def +(other)
    v = Num.new(self, other)
    self.parent = v
    other.parent = v
    v.reduce
  end

  def reduce
    loop do
      reduced = explode
      reduced = split unless reduced
      break unless reduced
    end
    self
  end

  def explode(depth = 0)
    if @left.kind_of?(Num)
      if depth < 3
        exploded = @left.explode(depth + 1)
      else
        exploded = true
        @parent.send_up_left(self, @left.left)
        send_up_right(self, @left.right)
        @left = 0
      end
      return true if exploded
    end
    if @right.kind_of?(Num)
      if depth < 3
        exploded = @right.explode(depth + 1)
      else
        exploded = true
        send_up_left(self, @right.left)
        @parent.send_up_right(self, @right.right)
        @right = 0
      end
      return true if exploded
    end
    return false
  end

  def send_up_left(who, v)
    if @left.kind_of?(Num)
      if @left == who
        @parent.send_up_left(self, v) if @parent
      else
        @left.send_down_right(v)
      end
    else
      @left += v
    end
  end

  def send_up_right(who, v)
    if @right.kind_of?(Num)
      if @right == who
        @parent.send_up_right(self, v) if @parent
      else
        @right.send_down_left(v)
      end
    else
      @right += v
    end
  end

  def send_down_left(v)
    if @left.kind_of?(Num)
      @left.send_down_left(v)
    else
      @left += v
    end
  end

  def send_down_right(v)
    if @right.kind_of?(Num)
      @right.send_down_right(v)
    else
      @right += v
    end
  end

  def split
    if @left.kind_of?(Num)
      return true if @left.split
    else
      if @left >= 10
        @left = Num.new(@left/2, @left/2 + @left%2)
        @left.parent = self
        return true
      end
    end
    if @right.kind_of?(Num)
      return true if @right.split
    else
      if @right >= 10
        @right = Num.new(@right/2, @right/2 + @right%2)
        @right.parent = self
        return true
      end
    end
    return false
  end

  def magnitude
    v = 3 * (@left.kind_of?(Num) ? @left.magnitude : @left)
    v += 2 * (@right.kind_of?(Num) ? @right.magnitude : @right)
  end
end

numbers = File.read("input").each_line.map(&:strip).map { |l| Num.parse(l.chars) }
result = numbers.reduce(:+)
result
puts result.magnitude

numbers = File.read("input").each_line.map(&:strip)

p max = numbers.permutation(2).map { |n1, n2|
  (Num.parse(n1.chars) + Num.parse(n2.chars)).magnitude
}.max
