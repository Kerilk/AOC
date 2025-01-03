inputs, gates = File.read('input').split("\n\n")
inputs = inputs.lines.map { |l| l.match(/(...): ([01])/)[1..2] }.map { |p, v| [p, v.to_i] }.to_h
gates = gates.lines.map { |l| l.match(/(...) (OR|XOR|AND) (...) -> (...)/)[1..4] }.map { |pi1, op, pi2, po| [po, [op, pi1, pi2] ] }.to_h
pins = gates.keys.select { |p| p.start_with?('z') }.sort
def fetch_pin(state, pin)
  s = state[pin]
  if s.kind_of?(Array)
    p1 = fetch_pin(state, s[1])
    p2 = fetch_pin(state, s[2])
    case s[0]
    when 'OR'
      p1 | p2
    when 'XOR'
      p1 ^ p2
    when 'AND'
      p1 & p2
    end
  else
    s
  end
end
state = inputs.merge(gates)
p pins.map { |p| fetch_pin(state, p) }.reverse.join.to_i(2)
