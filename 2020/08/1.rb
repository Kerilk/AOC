require 'set'

class Instruction
  attr_reader :pc
  attr_reader :preds
  attr_accessor :succ
  attr_accessor :executed
  attr_accessor :param
  def initialize(param, pc)
    @param = param
    @pc = pc
    @executed = false
    @preds = []
    @succ = nil
  end

  def exec
    throw :already_executed, true if @executed
    @executed = true
    op
    $pc = self.next
  end

  def self.from_instr(op, param, pc)
    case op
    when "nop"
      Nop
    when "acc"
      Acc
    when "jmp"
      Jmp
    else
      raise "illegal instruction"
    end.new(param, pc)
  end

  def op
  end

  def next
    @pc + 1
  end

  def predecessors
    @preds.collect(&:predecessors).flatten + @preds
  end
end

class Nop < Instruction
end

class Acc < Instruction
  def op
    $acc += @param
  end
end

class Jmp < Instruction
  def next
    @pc + @param
  end
end

def predecessors(prog, pc)
  preds = prog.select { |instr| instr.succ == pc }
  preds = preds.collect(&:predecessors).flatten + preds
  preds.uniq.collect(&:pc).to_set
end

def run_prog(prog)
  $pc = 0
  $acc = 0
  catch(:already_executed) do
    loop do
      instr = prog[$pc]
      break unless instr
      instr.exec
    end
  end
end

def create_graph(prog)
  prog.each_with_index { |instr, i|
    instr.succ = instr.next
    prog[instr.succ].preds.push instr if prog[instr.succ]
  }
end

def parse(file)
  File.read(file).each_line.each_with_index.collect { |l, i|
    m = l.match(/(nop|acc|jmp) ([+-]\d+)/)
    Instruction.from_instr(m[1], m[2].to_i, i)
  }
end

prog = parse("./input")
p run_prog(prog)
puts $acc

create_graph(prog)

reach_from = prog.select { |instr| instr.executed && (instr.kind_of?(Nop) || instr.kind_of?(Jmp)) }.collect(&:pc)
to_reach = predecessors(prog, prog.length)

pc_to_change = reach_from.select { |pc|
  instr = prog[pc]
  if instr.kind_of?(Nop)
    to_reach.include?(pc + instr.param)
  else
    to_reach.include?(pc + 1)
  end
}.first

inst_to_change = prog[pc_to_change]
prog[pc_to_change] = if inst_to_change.kind_of?(Nop)
    Jmp.new(inst_to_change.param, pc_to_change)
  else
    Nop.new(inst_to_change.param, pc_to_change)
  end

prog.each { |instr| instr.executed = false }

p run_prog(prog)
puts $acc
