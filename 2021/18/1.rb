class Num
  attr_reader :left, :right
  attr_accessor :parent

  def left=(child)
    child.parent = self if child.kind_of?(Num)
    @left = child
  end

  def right=(child)
    child.parent = self if child.kind_of?(Num)
    @right = child
  end

  def initialize(left, right)
    self.left = left
    self.right = right
  end

  def self.expect(chars, v)
    raise "error" unless (c = chars.shift) == v
    c
  end

  def self.parse_member(chars)
    chars.first == "[" ? parse(chars) : chars.shift.to_i
  end

  def self.parse(chars)
    expect(chars, "[")
    left = parse_member(chars)
    expect(chars, ",")
    right = parse_member(chars)
    expect(chars, "]")
    self.new(left, right)
  end

  def to_s
    "[#{@left},#{@right}]"
  end

  def +(other)
    Num.new(self, other).reduce
  end

  def reduce
    while explode || split do end
    self
  end

  def replace(who, v)
    if @left == who
      self.left = v
    elsif @right == who
      self.right = v
    else
      raise "error"
    end
  end

  def explode(depth = 0)
    if depth == 4
      @parent.send_up_left(self, @left)
      @parent.send_up_right(self, @right)
      @parent.replace(self, 0)
      return true
    end
    return true if @left.kind_of?(Num) && @left.explode(depth + 1)
    return true if @right.kind_of?(Num) && @right.explode(depth + 1)
    return false
  end

  def send_up_left(who, v)
    if @left.kind_of?(Num)
      if @left != who
        @left.send_down_right(v)
      elsif @parent
        @parent.send_up_left(self, v)
      end
    else
      @left += v
    end
  end

  def send_up_right(who, v)
    if @right.kind_of?(Num)
      if @right != who
        @right.send_down_left(v)
      elsif @parent
        @parent.send_up_right(self, v)
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

  def split_member(pos)
    child = self.send(pos)
    if child.kind_of?(Num)
      return true if child.split
    elsif child >= 10
      self.send(:"#{pos}=", Num.new(v = child/2, v + child%2))
      return true
    end
    return false
  end

  def split
    return true if split_member(:left)
    return true if split_member(:right)
    return false
  end

  def to_i
    v = 3 * @left.to_i
    v += 2 * @right.to_i
  end
  alias magnitude to_i
end

numbers = File.read("input").each_line.map(&:strip)
p numbers.map { |l| Num.parse(l.chars) }.reduce(:+).magnitude

p numbers.permutation(2).map { |n1, n2|
  (Num.parse(n1.chars) + Num.parse(n2.chars)).magnitude
}.max
