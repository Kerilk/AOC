$d = File.read('./input').lines.collect { |l|
  l.chomp.chars.collect { |c| c == "#" }
}
$width = $d[0].length
$length = $d.length

def trace(h, v)
  (0..($length-1)).step(v).count { |i| $d[i][(i * h) % $width] }
end

vectors = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]

puts vectors.collect { |v| trace(*v) }.reduce(:*)

