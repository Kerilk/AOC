card, door = File.read('input').lines.collect { |l| l.to_i }

sn = 7

crack = lambda { |target|
  v = 1
  i = 0
  while v != target
    v = v * 7
    v = v % 20201227
    i += 1
  end
  i
}

transform = lambda { |sn, i|
  sn.pow(i, 20201227)
}

i = crack.call(card)
j = crack.call(door)
p card_key = transform.call(door, i)
p door_key = transform.call(card, j)
