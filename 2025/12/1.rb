require 'matrix'
$shapes, regions = File.read('input').split("\n\n").then { |*shapes, regions|
  [shapes.map { |s| s.each_line.map(&:chomp)[1..-1].map(&:chars) },
   regions.each_line.map { |l|
     l.split(": ").then { |size, indices|
       [size.split('x').map(&:to_i),
        indices.split(' ').map(&:to_i)]
     }
   }]
}

# Find all mirrored and rotated shapes and express them as
# list of coordinates
$shapes.map! { |s|
  Matrix.build(s.size, s.first.size) { |i, j| s[i][j] == '#' ? 1 : 0 }
}.map! { |shape|
  Set[shape, shape.transpose]
}.map! { |set|
  3.times.reduce([set, set]) { |(memo, shapes), _|
    rotated = shapes.map { |shape| Matrix.columns(shape.row_vectors.reverse) }
    [memo | rotated, rotated]
  }.first
}.map! { |shapes|
  shapes.map { |m| m.each_with_index.filter_map { |e, i, j| [i, j] if e == 1 } }
}

# express required shapes as a hash map of counts
regions.map! { |(size, indices)|
  [size, indices.each_with_index.reject { |i, j| i == 0 }.map { |i, j| [j, i] }.to_h]
}

# increment j by inc or i by 1 if a shape would not fit
def next_indices(x, y, i, j)
  new_i, new_j = i, j+1
  new_i, new_j = i+1, 0 if new_j >= y - 2
  [new_i, new_j]
end

def consume_shape(required, shape_index)
  new_required = required.dup
  new_required[shape_index] -= 1
  new_required.delete(shape_index) if new_required[shape_index] <= 0
  new_required
end

# test if required shapes fit in a rectangle of size x * y, given
# a set of occupied coordinates and starting from indices i, j
def try_place(x, y, i, j, occupied, required)
  if required.empty? # they fit
    true
  elsif i >= x - 2 # can't fit a shape anymore
    false
  elsif required.sum { |k, v| $shapes[k].first.size * v } > (x - i) * y - j
    false # Not enough space remaining to fit required shapes
  else # Try to fit any required shape at this spot and recurse if successful
    required.keys.any? { |shape_index|
      $shapes[shape_index].any? { |shape|
        coords = shape.map { |(k, l)| [i+k, j+l] } # move shape at i, j
        (occupied & coords).empty? && # if shape fits, check the rest
          try_place(x, y, *next_indices(x, y, i, j),
                    occupied | coords, consume_shape(required, shape_index))
      }
    } || # no solution, so move to the next grid spot
      try_place(x, y, *next_indices(x, y, i, j), occupied, required)
  end
end

p regions.count { |region, required|
  try_place(*region, 0, 0, Set.new, required)
}
