require 'pp'
require 'set'

def w
  :w
end

def x
  :x
end

def y
  :y
end

def z
  :z
end

$deps = Hash.new { |h, k| h[k] = [] }

class Instruction
  attr_reader :dst, :parents, :children
  attr_accessor :value, :dst_value, :constrain_values

  def reducable?
    false
  end

  def initialize(dst)
    @dst = dst
    @parents = {}
    @children = []
    @value = nil
    @dst_value = nil
    @constrain_values = Set.new
  end
  alias inspect to_s

  def dst_val(state)
    @dst_value || state[@dst]
  end

  def value
    nil
  end

  def get_parent_values
    nil
  end

  def constrain(v)
    raise "error" unless [@value].flatten.include? v
    @constrain_values.add(v)
  end
end

class Inp < Instruction
  def to_s
    "inp #{@dst}"
  end

  def eval(state)
    v = state[:inputs].shift
    state[@dst] = v
    state
  end

  def compute_value
    @value = (1..9).to_a
  end

  def value
    @value
  end
end

class BinaryOperator < Instruction
  attr_reader :src
  attr_accessor :src_value
  def initialize(dst, src)
    super(dst)
    @src = src
    @src_value = nil
  end

  def src_val(state)
    @src_value || (@src.kind_of?(Symbol) ? state[@src] : @src)
  end

  def value
    @value
  end

  def get_parent_values
    if !@parents[@dst]
      @dst_value = 0
    else
      @dst_value = @parents[@dst].value
    end
    if !@src.kind_of? Symbol
      @src_value = @src
    elsif !@parents[@src]
      @src_value = 0
    else
      @src_value = @parents[@src].value
    end
  end

  def compute_value_impl
    if @dst_value && @src_value
      if @dst_value.kind_of? Array
        if @src_value.kind_of? Array
          @dst_value.product(@src_value).map { |a, b|
            v = compute_value_impl2(a, b)
            #$deps[[self, v]].push [[@parents[@dst], a], [@parents[@src], b]]
            v
          }
        else
          @dst_value.map { |a|
            v = compute_value_impl2(a, @src_value)
            #$deps[[self, v]].push [[@parents[@dst], a]]
            v
          }
        end
      elsif @src_value.kind_of? Array
        @src_value.map { |a|
          v = compute_value_impl2(@dst_value, a)
          #$deps[[self, v]].push [[@parents[@src], a]]
          v
        }
      else
        compute_value_impl2(@dst_value, @src_value)
      end
    else
      raise "error"
    end
  end

  def compute_value
    get_parent_values
    @value = compute_value_impl
    @value = @value.uniq.sort if @value.kind_of? Array
    @value = value.first if @value.kind_of?(Array) && @value.size == 1
    @value
  end

end

class Add < BinaryOperator
  def to_s
    "add #{@dst} #{@src}"
  end

  def eval(state)
    state[@dst] = dst_val(state) + src_val(state)
    state
  end

  def compute_value_impl2(v1, v2)
    v1 + v2
  end

  def constrain(v)
    raise "error" unless [@value].flatten.include? v
    @constrain_values.add(v)
    [@dst_value].flatten.product([@src_value].flatten).select { |a, b| a + b == v }.each { |a, b|
      @parents[@dst].constrain(a) if @parents[@dst]
      @parents[@src].constrain(b) if @parents[@src]
    }
  end
end

class Mul < BinaryOperator
  def to_s
    "mul #{@dst} #{@src}"
  end

  def eval(state)
    state[@dst] = dst_val(state) * src_val(state)
    state
  end

  def compute_value_impl2(v1, v2)
    v1 * v2
  end

  def constrain(v)
    raise "error" unless [@value].flatten.include? v
    @constrain_values.add(v)
    [@dst_value].flatten.product([@src_value].flatten).select { |a, b| a * b == v }.each { |a, b|
      @parents[@dst].constrain(a) if @parents[@dst]
      @parents[@src].constrain(b) if @parents[@src]
    }
  end

  def compute_value_impl
    if (@dst_value && @dst_value == 0) || (@src_value && @src_value == 0)
      0
    else
      super
    end
  end
end

class Div < BinaryOperator
  def to_s
    "div #{@dst} #{@src}"
  end

  def eval(state)
    raise "error" if src_val(state) == 0
    state[@dst] = (dst_val(state).to_f / src_val(state)).to_i
    state
  end

  def compute_value_impl2(v1, v2)
    raise "error" if v2 == 0
    (v1.to_f / v2).to_i
  end

  def compute_value_impl
    if @dst_value && @dst_value == 0
      0
    else
      super
    end
  end
end

class Mod < BinaryOperator
  def to_s
    "mod #{@dst} #{@src}"
  end

  def eval(state)
    raise "error" if dst_val(state) < 0 || src_val(state) <= 0
    state[@dst] = dst_val(state) % src_val(state)
    state
  end

  def compute_value_impl2(v1, v2)
    raise "error" if v1 < 0 || v2 <= 0
    v1 % v2
  end

  def compute_value_impl
    if @dst_value && @dst_value == 0
      0
    else
      super
    end
  end
end

class Eql < BinaryOperator
  def to_s
    "eql #{@dst} #{@src}"
  end

  def eval(state)
    state[@dst] = dst_val(state) == src_val(state) ? 1 : 0
    state
  end

  def compute_value_impl2(v1, v2)
    v1 == v2 ?  1 : 0
  end
end

$instructions = []

def inp(r)
  $instructions.push Inp.new(r)
end

def add(r, s)
  $instructions.push Add.new(r, s)
end

def mul(r, s)
  $instructions.push Mul.new(r, s)
end

def div(r, s)
  $instructions.push Div.new(r, s)
end

def mod(r, s)
  $instructions.push Mod.new(r, s)
end

def eql(r, s)
  $instructions.push Eql.new(r, s)
end

File.read("input").gsub(/(w|x|y|z) /, '\1, ').each_line.map { |l| eval(l) }

#(1..9).each { |i|
#  state = { w: 0,  x: 0, y: 0, z: 0, inputs: "9#{i}111111111111".to_i.digits.reverse }
#  state = $instructions.reduce(state) { |state, instr| instr.eval(state) }
#  pp state
#}
  state = { w: 0,  x: 0, y: 0, z: 0, inputs: 38721111111111.digits.reverse }
  state = $instructions.reduce(state) { |state, instr| instr.eval(state) }
  pp state

exit
def find_parent(sym, i)
  indx = (0..(i-1)).reverse_each.find { |j| $instructions[j].dst == sym }
  if indx
    $instructions[i].parents[sym] = $instructions[indx]
    $instructions[indx].children.push $instructions[i]
  end
end

$instructions.each_with_index { |instr, i|
  if instr.kind_of?(BinaryOperator)
    find_parent(instr.dst, i)
    find_parent(instr.src, i) if instr.src.kind_of? Symbol
    instr.compute_value
    print "#{instr}"
    print instr.value ?
      (instr.value.kind_of?(Array) ?
        " ([" + (instr.value.size <= 3 ? instr.value.join(", ") : instr.value.first(3).join(", ") + ", ...(#{instr.value.size})") + "])" :
        " (#{instr.value})") :
      ""
    puts
  else
    instr.compute_value
    puts "#{instr} (#{instr.value})"
  end
}
puts "---------------------"
#puts $deps[[$instructions.last, 0]]
#$instructions.last.constrain(0)
#$instructions.each { |instr|
#    print "#{instr}"
#    print instr.value ?
#      (instr.value.kind_of?(Array) ?
#        " ([" + (instr.value.size <= 3 ? instr.value.join(", ") : instr.value.first(3).join(", ") + ", ...") + "])" :
#        " (#{instr.value})") :
#      ""
#    print " => #{instr.constrain_values}"
#    puts
#}.join("\n")
