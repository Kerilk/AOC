MEMO = {}

class CPU
  attr_reader :registers, :output, :program
  def initialize(a, b, c, *program)
    @registers = {pc: 0, A: a, B: b, C: c}
    @output = []
    @program = program
  end

  def reset(a = 0)
    @registers = {pc: 0, A: a, B: 0, C: 0}
    @output = []
    self
  end

  class Instruction
    def self.combo?
      @combo || false
    end

    def initialize(v)
      @v = v
    end

    def increase_pc(state)
      state.registers[:pc] += 2
    end

    def decode_combo(state, v)
      self.class.decode_combo(state, v)
    end

    def self.decode_combo(state, v)
      if combo?
        case v
        when 0..3
          v
        when 4
          state.registers[:A]
        when 5
          state.registers[:B]
        when 6
          state.registers[:C]
        when 7
          raise "Invalid Combo"
        end
      else
        v
      end
    end
  end

  class Adv < Instruction
    @combo = true
    def exec(state)
      state.registers[:A] /= 1 << decode_combo(state, @v)
    end
  end

  class Bxl < Instruction
    def exec(state)
      state.registers[:B] ^= decode_combo(state, @v)
    end
  end

  class Bst < Instruction
    @combo = true
    def exec(state)
      state.registers[:B] = decode_combo(state, @v) % 8
    end
  end

  class Jnz < Instruction
    def exec(state)
      if state.registers[:A] != 0
        state.registers[:pc] = @v
      end
    end

    def increase_pc(state)
      if state.registers[:A] == 0
        state.registers[:pc] += 2
      end
    end
  end

  class Bxc < Instruction
    def exec(state)
      state.registers[:B] ^= state.registers[:C]
    end
  end

  class Out < Instruction
    @combo = true
    def exec(state)
      state.output << decode_combo(state, @v) % 8
    end
  end

  class Bdv < Instruction
    @combo = true
    def exec(state)
      state.registers[:B] = state.registers[:A] / (1 << decode_combo(state, @v))
    end
  end

  class Cdv < Instruction
    @combo = true
    def exec(state)
      state.registers[:C] = state.registers[:A] / (1 << decode_combo(state, @v))
    end
  end

  INSTRUCTIONS = { 0 => Adv, 1 => Bxl, 2 => Bst, 3 => Jnz, 4 => Bxc, 5 => Out, 6 => Bdv, 7 => Cdv }

  def decode
    pc = @registers[:pc]
    instr, val = @program[pc..(pc+1)]
    raise StopIteration unless instr
    INSTRUCTIONS[instr].new(val)
  end

  def step
    instr = decode
    instr.exec(self)
    instr.increase_pc(self)
  end

  def run
    loop do
      if m = MEMO[@registers]
        @registers = m[0]
        @output += m[1]
      else
        state = @registers.dup
        sz = @output.size
        step
        MEMO[state] = [@registers.dup, @output[sz..-1]]
      end
    end
  end
end

cpu = CPU.new(*File.read('input').scan(/\d+/).map(&:to_i))
cpu.run
puts cpu.output.join(',')

puts cpu.program.size.times.inject([0]) { |seeds, index|
  8.times.flat_map { |i|
    seeds.filter_map { |s|
      cpu.reset(s * 8 + i).run
      cpu.output == cpu.program[(-index - 1)..-1] ? s * 8 + i : nil
    }
  }
}.min
