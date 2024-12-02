require 'set'
require 'matrix'
require 'pp'

def dist(p1, p2)
  v = p2 - p1
  v.dot(v)
end

def manhattan_dist(p1, p2)
  (p2 - p1).map { |v| v.abs }.sum
end

$scanners = File.read("input_thomas").split("\n\n").map(&:lines).map { |lines| 
  [lines[0].match(/scanner (\d+)/)[1].to_i, lines[1..-1].map { |l| l.split(",").map(&:to_i) }.map { |v| Vector.elements(v) }]
}.to_h

$distances = $scanners.map { |scanner, probes|
  [scanner, probes.each_with_index.map { |probe, i|
    [i, $scanners[scanner].map { |probe2|
      dist(probe2, probe)
    }]
  }.to_h]
}.to_h

$distances_map = $distances.map { |scanner, probes|
  [scanner, probes.values.flatten.uniq.reject{ |e| e == 0 }]
}.to_h

$overlaps = $scanners.keys.combination(2).select { |s1, s2|
  ($distances_map[s1] & $distances_map[s2]).size >= 66
}.map { |s1, s2| [[s1, s2].to_set, ($distances_map[s1] & $distances_map[s2])] }.to_h

#pp $overlaps.transform_values { |v| v.size}

$scanner_pos = { 0 => Vector[0,0,0] }
$scanner_rotation = { 0 => Matrix.I(3) }

def tranform_to(s0, s1)
  common = $overlaps[[s0, s1].to_set]
  common_points_0 = $distances[s0].select { |probe_index, ds| (ds & common).size >= 11 }.keys
  common_points_1 = $distances[s1].select { |probe_index, ds| (ds & common).size >= 11 }.keys

  coords_0 = common_points_0.first(3).map { |i| $scanners[s0][i] }
  coords_1 = []
  probe0, probe1, probe2 = *coords_0
  d0 = dist(probe1, probe0)
  d1 = dist(probe2, probe0)
  d2 = dist(probe2, probe1)
  coords_1 = [[d0, d1], [d0, d2], [d1, d2]].map { |dists|
    $distances[s1].find { |probe_index, ds| (ds & dists).size == 2 }
  }.map { |probe_index, _| $scanners[s1][probe_index] }
  v0 = v1 = nil
  [[1, 0], [2, 0], [2, 1]].each { |i, j|
    v0 = coords_0[i] - coords_0[j]
    v1 = coords_1[i] - coords_1[j]
    break unless v0.include?(0)
  }
  raise "error" if v0.include?(0)

  m = Matrix.build(3) { 0 }
  (0..2).each { |i|
    j = v1.find_index { |v| v.abs == v0[i].abs }
    m[i, j] = v0[i]/v1[j]
  }
  coords_1.map! { |v| m * v }

  trans = coords_0.zip(coords_1).map { |v0, v1| v1 - v0 }.uniq
  raise "error" unless trans.size == 1
  trans = trans.first
  $scanners[s1].map! { |probe| m*probe - trans }

  $scanner_pos[s1] = -trans
  $scanner_rotation[s1] = m
end

while $overlaps.keys.size > 0
  tuple = $overlaps.keys.find { |t| (t & $scanner_pos.keys).size > 0 }
  raise "error" unless tuple
  source = tuple & $scanner_pos.keys
  target = tuple - source
  if target.size > 0
    source = source.to_a.first
    target = target.to_a.first
    tranform_to(source, target)
  end
  $overlaps.delete(tuple)
end

p $scanners.reduce(Set.new) { |memo, (k, probes)| memo | probes }.size
p $scanners.keys.combination(2).map { |s0, s1| manhattan_dist($scanner_pos[s1], $scanner_pos[s0]) }.max
