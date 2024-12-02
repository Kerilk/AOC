class Monkey
  attr_reader :items, :inspections
  def initialize(*items, block)
    @items, @block, @inspections = items, block, 0
  end

  def take_turn
    @inspections += items.size
    @items.each(&@block).clear
  end
end

monkeys, pdivisors = File.read("input").split("\n\n").map(&:lines).map { |m|
  items = m[1].scan(/\d+/).map(&:to_i)
  expr = m[2].match(/= (.*)$/)[1]
  div, t1, t2 = m[3..5].map { |l| l.scan(/\d+/).first.to_i }
  block = eval <<EOF
lambda { |old|
  new = (#{expr}) % pdivisors
  monkeys[new % #{div} == 0 ? #{t1} : #{t2}].items << new
}
EOF
  [Monkey.new(*items, block), div]
}.transpose.yield_self { |ms, divs| [ms, divs.reduce(&:*)] }

10000.times { monkeys.each(&:take_turn) }
p monkeys.map(&:inspections).max(2).reduce(&:*)
