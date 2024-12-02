require 'matrix'

class Instructions
  class << self
     attr_reader :duration
     attr_reader :triggers
  end

  def duration
    self.class.duration
  end

  def triggers
    self.class.triggers
  end

  def self.decode(instr)
    case instr
    when /^noop$/
      return Noop.new
    when /^addx (-?\d+)$/
      return AddX.new($1.to_i)
    else
      raise "Unknown instruction #{instr}"
    end
  end

  def enact(state)
    exec(state)
    triggers.each { |r| state.check(r) }
  end
end

class Noop < Instructions
  @triggers = []
  @duration = 1

  def exec(state)
  end
end

class AddX < Instructions
  @triggers = [:x]
  @duration = 2

  def initialize(v)
    @v = v
  end

  def exec(state)
    state.registers[:x] += @v
  end
end

class State
  attr_reader :registers
  attr_reader :triggers
  attr_reader :program
  attr_reader :instruction
  attr_reader :ticks

  def reset
    @registers = {}
    @triggers = Hash.new { |k, v| k[v] = [] }
    @registers[:x] = 1
    @registers[:pc] = -1
    @registers[:cy] = 0
    @instruction = Noop.new
    @ticks = 0
  end

  def initialize(program)
    @program = program.lines.map { |l| Instructions.decode(l) }
    reset
  end

  def trigger(register, condition, &block)
    @triggers[register].push [condition, block]
  end

  def check_reg(register, cond)
    case cond
    when true
      true
    when Integer
      @registers[register] == cond
    when Proc
      cond.call(@registers[register], self)
    else
      raise "Invalid condition!"
    end
  end

  def check(register)
    @triggers[register].each { |cond, cb| cb.call(self) if check_reg(register, cond) }
  end

  def step
    if @ticks == 0
      @instruction.enact(self)
      @registers[:pc] += 1
      @instruction = program[@registers[:pc]]
      raise StopIteration unless @instruction
      @ticks = @instruction.duration
      check(:pc)
    end
    @registers[:cy] += 1
    check(:cy)
    @ticks -= 1
  end

  def run
    loop do step end
  end
end

signal_strengths = []
crt = Matrix.build(6, 40) { "." }
s = State.new(File.read("input"))
s.trigger(:cy, lambda { |cy, _| (cy + 20) % 40 == 0 }) { |s|
  signal_strengths.push s.registers[:cy] * s.registers[:x]
}
s.trigger(:cy, true) { |s|
  cy = s.registers[:cy] - 1
  x = s.registers[:x]
  py, px = cy.divmod 40
  crt[py, px] = "#" if ((x-1)..(x+1)).include? px
}
s.run
puts signal_strengths.sum
puts crt.row_vectors.map { |v| v.to_a.join }.join("\n")
