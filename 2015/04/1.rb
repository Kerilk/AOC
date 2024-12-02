require 'digest'

input = "iwrupvqb"
puts (1..Float::INFINITY).lazy.find { |i| Digest::MD5.hexdigest(input + i.to_s).match(/\A00000/) }
puts (1..Float::INFINITY).lazy.find { |i| Digest::MD5.hexdigest(input + i.to_s).match(/\A000000/) }
