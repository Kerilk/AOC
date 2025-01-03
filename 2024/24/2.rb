inputs, gates = File.read('input').split("\n\n")
inputs = inputs.lines.map { |l| l.match(/(...): ([01])/)[1..2] }.map { |p, v| [p, v.to_i] }.to_h
gates = gates.lines.map { |l| l.match(/(...) (OR|XOR|AND) (...) -> (...)/)[1..4] }.map { |pi1, op, pi2, po| [po, [op, [pi1, pi2].sort].flatten ] }.to_h
pins = gates.keys.select { |p| p.start_with?('z') }.sort


input_xors = gates.select { |k, (op, pi1, pi2)|
  op == 'XOR' && pi1.start_with?('x')
}
first_sum = input_xors.select { |k, (op, pi1, pi2)| pi1 == 'x00' }.keys.first
non_input_xors = gates.select { |k, (op, pi1, pi2)|
  op == 'XOR' && !pi1.start_with?('x')
}
input_ands = gates.select { |k, (op, pi1, pi2)|
  op == 'AND' && pi1.start_with?('x')
}
first_carry = input_ands.select { |k, (op, pi1, pi2)| pi1 == 'x00' }.keys.first
non_input_ands = gates.select { |k, (op, pi1, pi2)|
  op == 'AND' && !pi1.start_with?('x')
}
carries = gates.select { |k, (op, pi1, pi2)|
  op == 'OR'
}

wrong = input_xors.keys.select { |p| p.start_with?('z') && p != first_sum }

wrong += non_input_xors.keys.select { |p| !p.start_with?('z') }
wrong += non_input_xors.values.map { |_, p, _| p }.select { |p|
  p.start_with?('z') || !(input_xors[p] || (carries[p] || p == first_carry))
}
wrong += non_input_xors.values.map { |_, _, p| p }.select { |p|
  p.start_with?('z') || !(input_xors[p] || (carries[p] || p == first_carry))
}

wrong += input_ands.keys.select { |p| p.start_with?('z') }

wrong += non_input_ands.keys.select { |p| p.start_with?('z') }
wrong += non_input_ands.values.map { |_, p, _| p }.select { |p|
  p.start_with?('z') || !(input_xors[p] || (carries[p] || p == first_carry))
}
wrong += non_input_ands.values.map { |_, _, p| p }.select { |p|
  p.start_with?('z') || !(input_xors[p] || (carries[p] || p == first_carry))
}

wrong += carries.keys.select { |p| p.start_with?('z') && p != pins.last }
wrong += carries.values.map { |_, p, _| p }.select { |p| p.start_with?('z') || !(input_ands[p] || non_input_ands[p]) }
wrong += carries.values.map { |_, _, p| p }.select { |p| p.start_with?('z') || !(input_ands[p] || non_input_ands[p]) }

puts wrong.uniq.sort.join(",")
