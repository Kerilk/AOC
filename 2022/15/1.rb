require 'matrix'
require 'set'
input, y, l = "input", 2000000, 4000000
data = File.foreach(input).map { |l| l.scan(/-?\d+/).map(&:to_i).each_slice(2).map { |e| Vector[*e] } }
radi = data.map { |s, b| [s, (b - s).map(&:abs).sum] }

p radi.combination(2).filter { |(s, r), (s2, r2)| (s-s2).map(&:abs).sum == r + r2 + 2 }.
  map { |(s, r), (s2, r2)|
    d = (s2 - s).map { |v| v <=> 0 }
    [s[0] + d[0] * (r + 1), s[1], *d]
  }.yield_self { |(a1, b1, d01, d11), (a2, b2, d02, d12) |
    i = d01 == d02 ? (a1 + b1) - (a2 + b2) : (a1 - b1) - (a2 - b2)
    i /= 2 * d01
    [-i * d01 + a1, i * d11 + b1]
  }.yield_self { |x, y| x * 4000000 + y }
exit
p (Set[ *radi.filter_map { |b, r| [b, r, r - (b[1] - y).abs] if (b[1] - y).abs <= r }.
              map { |b, r, d| ((b[0] - d)..(b[0] + d)).to_a }.flatten(1) ] -
   Set[ *data.filter_map { |_, b| b[0] if b[1] == y } ]).size

p (0..l).each { |y|
  segments = radi.filter_map { |b, r| [b, r, r - (b[1] - y).abs] if (b[1] - y).abs <= r }.
    map { |b, r, d| (b[0] - d)..(b[0] + d) }.sort_by(&:min)
  reduced_segments =
    segments.reduce([]) { |memo, i| 
      if memo.last && memo.last.max >= i.min - 1
        memo[-1] = memo.last.min..i.max if memo.last.max <= i.max
      else
        memo.push (i.min < 0 ? 0 : i.min)..(i.max > l ? l : i.max)
      end
      memo
    }
  break [y, reduced_segments] if reduced_segments.size > 1
}.yield_self { |i, segs| (segs.first.max + 1) * 4000000 + i }
