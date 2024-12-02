data = File.read('./input').lines
puts data.count { |l| l.count("aeiou") >= 3 && !l.match(/ab|cd|pq|xy/) && l.match(/(.)\1/) }
puts data.count { |l| l.match(/((..).*\2)/) && l.match(/(.).\1/) }
