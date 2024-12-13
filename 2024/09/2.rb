disk, _, _, _ = File.read('input').chomp.chars.map(&:to_i).reduce([[], 0, 0, true]) { |(s, idx, i, file), c|
  [s << [idx, c, file ? i : nil], idx + c, i + (file ? 0 : 1), !file]
}
disk2 = []
while !disk.empty?
  idx, cnt, v = disk.shift
  if v
    disk2 << [idx, cnt, v]
  else
    if i = disk.rindex { |(idx2, cnt2, v2)| v2 && cnt2 <= cnt }
      _, cnt2, v2 = disk.delete_at(i)
      disk2 << [idx, cnt2, v2]
      disk.unshift [idx + cnt2, cnt - cnt2, nil]
    end
  end
end
p disk2.sum { |idx, cnt, v| cnt.times.sum { |i| (idx + i) * v } }
