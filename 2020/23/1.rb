cups = "583976241".each_char.collect(&:to_i)
#cups = "389125467".each_char.collect(&:to_i)
100.times { |i|
  target = cups[0]
  cups.rotate!
  slice = cups.shift(3)
  begin 
    target -= 1
    target = (target == 0 ? 9 : target)
  end while !(e = cups.find_index(target))
  cups.insert(e+1, *slice)
}
e = cups.find_index(1)
cups.rotate!(e)
puts cups.drop(1).join
