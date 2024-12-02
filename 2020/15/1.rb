input = [0,1,5,10,3,12,19]

mem = Hash::new { |h, k| h[k] = [] }

input.each_with_index { |v, i|
  mem[v].push(i+1)
}

last = input.last
i = input.length
while i < 30000000
  i += 1
  l = mem[last]
  last = (l.length == 1 ? 0 : l[-1]-l[-2])
  mem[last].push(i)
end

puts last
