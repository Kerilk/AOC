inputs = File.read('input').strip.split(',')

hash = lambda { |s| s.each_byte.inject(0) { |memo, c| ((memo + c) * 17) & 0xff } }

p inputs.map(&hash).sum

boxes = 256.times.map { Hash.new }
instructions = inputs.map { |s| s.match(/(\w+)(?:=(\d+)|-)/)[1..2] }
instructions.each { |label, lens|
  if lens
    boxes[hash[label]][label] = lens
  else
    boxes[hash[label]].delete(label)
  end
}
p boxes.each.with_index(1).sum { |box, j| box.each.with_index(1).sum { |(_, f), i| j * i * f.to_i } }
