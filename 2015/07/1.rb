class Node
  attr_reader :inputs
  attr_reader :output
  attr_accessor :value
  def initialize(op, inputs, output)
    @op = op
    @inputs = inputs
    @output = output
  end

  def value
    @value ||= begin
      i1 = evaluate(@inputs[0])
      i2 = evaluate(@inputs[1])
      v = case @op
      when :NOT
        ~i1
      when :OR
        i1 | i2
      when :AND
        i1 & i2
      when :LSHIFT
        i2 << i1
      when :RSHIFT
        i2 >> i1
      else
        i1
      end
      v & 0xffff
    end
  end

  def reset!
    @value = nil
  end

  def to_s
    i1 = input_to_s(@inputs[0])
    i2 = input_to_s(@inputs[1])
    op = @op.to_s
    o = @output
    a = [i1, "->", o]
    a.unshift op if op
    a.unshift i2 if i2
    a.join(" ")
  end

  private
  def evaluate(input)
    case input
    when Integer
      input
    when Node
      input.value
    else
      nil
    end
  end

  def input_to_s(input)
    case input
    when Integer
      input.to_s
    when Node
      input.output
    else
      nil
    end
  end
end

data = File.open('input').each_line.collect { |l|
  m = l.match(/([0-9a-z]+ )?(NOT|AND|OR|LSHIFT|RSHIFT)? ?([0-9a-z]+) -> (\w+)/)
}.collect { |m|
  inputs = [m[3]]
  inputs << m[1].chomp(" ") if m[1]
  inputs.collect! { |i| i.match(/\d/) ? i.to_i : i }
  Node.new( m[2] ? m[2].to_sym : m[2], inputs.compact, m[4] )
}
data.each { |n|
  n.inputs.collect! { |i| i.kind_of?(String) ? data.find { |on| on.output == i } : i }
}
puts v = data.find { |n| n.output == "a" }.value
data.each { |d| d.reset! }
data.find { |n| n.output == "b" }.value = v
puts data.find { |n| n.output == "a" }.value
#data.each { |n| puts n }

