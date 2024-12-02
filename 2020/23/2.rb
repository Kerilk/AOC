class Item
  attr_reader :value
  attr_accessor :next
  def initialize(value)
    @value = value
  end

  def find(val)
    if @value == val
      return true
    elsif @next
      return @next.find(val)
    else
      return false
    end
  end

  def prepend(other)
    other.next = self
    other
  end
  alias << prepend

  def slice(count)
    return nil if count < 0
    head = @next
    tail = head
    (count - 1).times {
      tail = tail.next
    }
    @next = tail.next
    tail.next = nil
    head
  end

  def insert(head)
    tail = head
    while tail.next
      tail = tail.next
    end
    tail.next = @next
    @next = head
    self
  end
end

count =  1000000
turns = 10000000

cups = "583976241".each_char.collect { |c| Item.new(c.to_i) } + (10..count).collect { |i| Item.new(i) }
cups.reverse_each.reduce(:<<)
cups.last.next = cups.first

current = cups[0]
cups = cups.collect { |c| [c.value, c] }.to_h

turns.times {
  slice = current.slice(3)
  target = current.value
  begin
    target -= 1
    target = (target == 0 ? count : target)
  end while slice.find(target)
  cups[target].insert(slice)
  current = current.next
}
e = cups[1]
puts e.next.value * e.next.next.value
