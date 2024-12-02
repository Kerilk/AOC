class Item
  attr_reader :value
  attr_accessor :next
  attr_accessor :prev
  def initialize(value)
    @value = value
    @next = self
    @prev = self
  end

  def append(head)
    tail = head.prev
    @prev.next = head
    head.prev = @prev
    @prev = tail
    tail.next = self
  end
  alias << append

  def include?(val)
    return each.include?(val)
    tail = @prev
    cur = @prev
    begin
      cur = cur.next
      return true if cur.value == val
    end while cur != tail
    false
  end

  def slice(count)
    return nil if count < 0
    head = @next
    tail = head
    (count - 1).times {
      tail = tail.next
    }
    @next = tail.next
    @next.prev = self
    tail.next = head
    head.prev = tail
    head
  end

  def insert(head)
    tail = head.prev
    tail.next = @next
    @next.prev = tail
    head.prev = self
    @next = head
    self
  end
end

count =  1000000
turns = 10000000

cups = "583976241".each_char.collect { |c| Item.new(c.to_i) } + (10..count).collect { |i| Item.new(i) }

current = cups.reduce(:<<)
cups = cups.collect { |c| [c.value, c] }.to_h

turns.times {
  slice = current.slice(3)
  target = current.value
  begin
    target -= 1
    target = (target == 0 ? count : target)
  end while slice.include?(target)
  cups[target].insert(slice)
  current = current.next
}
e = cups[1]
puts e.next.value * e.next.next.value
