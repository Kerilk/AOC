class Array
  alias old_starship <=>
  def <=>(other)
    other.kind_of?(Integer) ? self <=> [other] : old_starship(other)
  end
end

class Integer
  alias old_starship <=>
  def <=>(other)
    other.kind_of?(Array) ? [self] <=> other : old_starship(other)
  end
end

input = File.foreach("input").reject { |l| l == "\n" }.map { |l| eval(l) }
p input.each_slice(2).with_index(1).filter_map { |(a, b), i| (a <=> b) < 0 ? i : nil }.sum
dividers = [[[2]], [[6]]]
p dividers.each_with_object(input.push(*dividers).sort).map { |div, d| d.find_index(div) + 1 }.reduce(&:*)
