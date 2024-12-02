require 'narray'
require 'rb_heap'

CORRIDOR_TILES = (1..11).each.map { |i| [i, 1] }
FORBIDDEN_TILES = [[3,1], [5,1], [7,1], [9,1]]
ALLOWED_TILES = CORRIDOR_TILES - FORBIDDEN_TILES
COSTS = {
  1 => 1,
  2 => 10,
  3 => 100,
  4 => 1000 }
DESTINATION_ROOM_COORDS = {
  1 => [[3, 2], [3, 3], [3, 4], [3, 5]],
  2 => [[5, 2], [5, 3], [5, 4], [5, 5]],
  3 => [[7, 2], [7, 3], [7, 4], [7, 5]],
  4 => [[9, 2], [9, 3], [9, 4], [9, 5]]
}
DESTINATION_ROOM_RANGES = {
  1 => [3, 2..5],
  2 => [5, 2..5],
  3 => [7, 2..5],
  4 => [9, 2..5]
}


class State
  attr_reader :board
  def initialize(board)
    @board = board
  end

  def eql?(other)
    self.class == other.class && @board == other.board
  end
  alias == eql?

  def hash
    @board.hash
  end

  def cost(a, c)
    ((a[0] - c[0]).abs + (a[1] - c[1]).abs) * COSTS[@board[*a]]
  end

  # return list of possible movements and costs
  def transitions
    # check corridor, amphipods can only move from there if their room is empty, or
    # only contain amphipods of the same type
    moves = []
    ALLOWED_TILES.each do |c|
      v = @board[*c]
      if v != 0
        index = nil
        found = false
        DESTINATION_ROOM_COORDS[v].each_with_index { |r, i|
          rv = @board[*r]
          if rv == 0
            found = true
            index = i
          elsif rv != v
            found = false
            break
          end
        }
        if found
          start, stop = c[0], DESTINATION_ROOM_RANGES[v][0]
          start, stop = stop, start if start > stop
          if @board[start..stop, c[1]].sum == v
            moves.push [c, DESTINATION_ROOM_COORDS[v][index]]
          end
        end
      end
    end
    amphipods = []
    # find amphipods that can get out of their room
    DESTINATION_ROOM_COORDS.each do |k, coords|
      index = nil
      coord = nil
      coords.each_with_index { |r, i|
        if @board[*r] != 0
          index = i
          coord = r
          break
        end
      }
      if index
        if @board[*coord] == k
          move = false
          coords[(index+1)..4].each { |r|
            if @board[*r] != k
              move = true
              break
            end
          }
          amphipods.push coord if move
        else
          amphipods.push coord
        end
      end
    end
    # find where those amphipods can go
    amphipods.each do |a|
      ALLOWED_TILES.each do |c|
        start, stop = c[0], a[0]
        start, stop = stop, start if start > stop
        if @board[start..stop, c[1]].sum == 0
          moves.push [a, c]
        end
      end
    end
    # create states and costs
    moves.map { |a, c|
      new_board = @board.dup
      new_board[*c] = new_board[*a]
      new_board[*a] = 0
      [State.new(new_board), cost(a, c)]
    }
  end

  def to_s
    @board.shape[1].times.map { |j|
      @board.shape[0].times.map { |i|
        v = @board[i, j]
        case v
        when 255
          "#"
        when 254
          " "
        when 0
          "."
        else
          ("A".ord - 1 + v).chr
        end
      }.join
    }.join("\n")
  end

end

d = File.read("input2").split("\n").map(&:chars)

start = NArray.byte(d.first.size, d.size)
stop = NArray.byte(d.first.size, d.size)
start.shape[1].times { |j|
  start.shape[0].times { |i|
    v = d[j][i]
    start[i, j] = v == "#" ? 255 : v == " " || v.nil? ? 254 : v == "." ? 0 : v.ord - "A".ord + 1
  }
}
stop[0..-1, 0..-1] = start
CORRIDOR_TILES.each { |c|
  stop[*c] = 0
}
DESTINATION_ROOM_RANGES.each { |k, v|
  stop[*v] = k
}
start = State.new(start)
stop = State.new(stop)
puts start
puts "------------------"

#start.transitions.each { |node, cost|
#puts "------------------"
#  puts node
#}
#exit
nodes = {}

heap = Heap.new { |(c1, v1), (c2, v2)| v1 < v2 }
heap << [start, 0]
j = 0
while !heap.empty?
  node, cost = heap.pop
  unless nodes[node]
    j += 1
    puts "#{j} #{cost}" if j % 1000 == 0
    nodes[node] = cost
    break if node == stop
    transitions = node.transitions
    transitions.each { |n, c|
      heap << [n, c + cost] unless nodes[n]
    }
  end
end
p nodes[stop]
