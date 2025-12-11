$machines = File.read('input').each_line.map(&:chomp).map { |l| l.split(': ') }.
  map { |(machine, outputs)| [machine, outputs.split(' ')] }.to_h

$memo = {}
def count_paths(in_node, out_node, ping)
  $memo[[in_node, ping]] ||= begin
    ping += 1 if in_node == 'dac' || in_node == 'fft'
    if in_node == out_node
      ping == 2 ? 1 : 0
    else
      $machines[in_node].sum { |node| count_paths(node, out_node, ping) }
    end
  end
end

p count_paths('svr', 'out', 0)
