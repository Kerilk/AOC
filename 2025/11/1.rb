$machines = File.read('input').each_line.map(&:chomp).map { |l| l.split(': ') }.
  map { |(machine, outputs)| [machine, outputs.split(' ')] }.to_h

$memo = {}
def count_paths(in_node, out_node)
  $memo[in_node] ||= in_node == out_node ?
    1 : $machines[in_node].sum { |node| count_paths(node, out_node) }
end

p count_paths('you', 'out')
