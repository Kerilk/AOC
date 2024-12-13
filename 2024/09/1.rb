disk, _, _ = File.read('input').chomp.chars.map(&:to_i).reduce([[], 0, true]) { |(s, i, file), c|
  [s + (file ? [i] : [nil]) * c, i + (file ? 0 : 1), !file]
}
s, e = 0, disk.size - 1
while s < disk.size - 1
  while !disk[s] && s < disk.size - 1  
    disk[s] = disk.pop
  end
  s += 1
end
p disk.each_with_index.map { |c, i| c * (i || 0) }.sum
