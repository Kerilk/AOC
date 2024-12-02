str_='389125467'
str_='653427918'
cups = str_.each_char.map(&:to_i)
cups  = cups + (10..1000000).to_a
def algo0 (c)
  cups = c.clone
  current_cup_idx = 0 #cups.first
  current_cup = cups[current_cup_idx]
  cups_size = cups.size
  100.times {
    # Pickups
    #p cups
    picked_up_cups = 3.times.map { |i| 
      idx = (current_cup_idx +i+1) % cups_size 
      cups[idx]  
    }
    #p picked_up_cups
    3.times.map { |i| (current_cup_idx +i+1) % cups_size }.sort.reverse.each { |i|
      cups.delete_at(i)
    }
    # Destination cups
    guess = (current_cup-1)
    while not cups.each_with_index.find { |v,i| v ==  guess }
      if guess <= cups.min
        guess = cups.max
      else
        guess = guess - 1
      end
    end
    destination_cups, destination_cups_idx = cups.each_with_index.find { |v,i| v ==  guess }
    #p destination_cups
    # Put insert 
    cups.insert((destination_cups_idx+1), *picked_up_cups)  
    # Find cups after moving. I guess it should be smarter and doing beforeo the invert and all
    _, current_cup_idx = cups.each_with_index.find { |v,i| v ==  current_cup }  
    current_cup_idx =  ( current_cup_idx + 1 ) % cups_size
    current_cup = cups[current_cup_idx]
    #p cups
  }
  cups
end
def algo1 (cups)
  current_cup =  cups.first
  chain = cups.each_cons(2).map.to_h
  chain[cups.last] = cups.first
  cups_min = cups.min
  cups_max = cups.max
  picked_up_cups = [0,0,0]
  10000000.times {
    a = current_cup
    3.times { |i|
      a = chain[a]
      picked_up_cups[i] =a
    }
    destination_cups = current_cup
    begin
        destination_cups-=1
        destination_cups = cups_max if destination_cups == 0
    end while picked_up_cups.include?(destination_cups)
    chain[current_cup] = chain[picked_up_cups.last]
    chain[picked_up_cups.last] = chain[destination_cups]
    chain[destination_cups] = picked_up_cups.first
    current_cup = chain[current_cup]
  }
  chain
end
#p idx
#cups1 = algo0(cups)
#_, idx = cups1.each_with_index.find { |v,i| v ==  1 } 
#p cups1.size.times.map{ |i| cups1[ (idx+i) % cups1.size] }.drop(1).join
chain = algo1(cups)
p chain[1]*chain[chain[1]]
#puts(Benchmark.measure { algo0(cups) })
#puts(Benchmark.measure { algo1(cups) })
