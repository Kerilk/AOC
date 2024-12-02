class Monkey
  attr_reader :items, :inspections
  def initialize(*items, &block)
    @items = [*items]
    @block = block
    @inspections = 0
  end

  def take_turn
    @items.each { |i| @block.call(i) }
    @inspections += items.size
    @items = []
  end
end

monkeys = File.read("input").split("\n\n").map(&:lines).map { |m|
  items = m[1].scan(/\d+/).map(&:to_i)
  arg1, op, arg2 = m[2].match(/= (old|\d+) (\+|\*) (old|\d+)/).captures
  div = m[3].scan(/\d+/).first.to_i
  targets = (4..5).map { |l| m[l].scan(/\d+/).first.to_i }
  Monkey.new(*items) { |old|
    new = eval("#{arg1} #{op} #{arg2}")
    new = new / 3
    monkeys[targets[(new % div == 0) ? 0 : 1]].items << new
  }
}

20.times {
  monkeys.each(&:take_turn)
}
p monkeys.each.map(&:inspections).max(2).reduce(&:*)
