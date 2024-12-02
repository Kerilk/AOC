class Bag
  attr_reader :contains
  attr_reader :parents
  attr_accessor :children
  attr_reader :color

  def initialize(color, contains)
    @color = color
    @contains = contains
    @parents = []
  end

  def ancestors
    @ancestors ||= begin
      (@parents.collect(&:ancestors).flatten + @parents).uniq
    end
  end

  def bag_count
    @bag_count ||= begin
      @children.sum { |count, child|
        count * (child.bag_count + 1)
      }
    end
  end
end

bags = File.read("input").each_line.collect { |l|
  color = l.match(/\A(.*?) bags contain/)[1]
  contains = l.scan(/(\d+) (.*?) bags{0,1}[,.]/)
  [color, Bag.new(color, contains)]
}.to_h

bags.each_value { |bag|
  bag.children = bag.contains.collect { |count, color| [count.to_i, bags[color]] }
  bag.children.each { |_, child| child.parents.push bag }
}

puts bags["shiny gold"].ancestors.count
puts bags["shiny gold"].bag_count
