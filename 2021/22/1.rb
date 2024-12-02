require 'narray'

d = File.read("input").each_line.map(&:strip).map { |l| l.match(/(on|off) (.*)/)[1..2] }.map { |tog, area| [tog == "on" ? 1 : 0, eval(area)] }

d = d.reject { |tog, area| area.find { |range| range.min < -50 || range.max > 50 } }.map { |tog, area|
  [tog, area.map { |range| (range.min + 50)..(range.max + 50) }] }
a = NArray.int(101, 101, 101)

d.each { |tog, area|
  a[*area] = tog
}

p a.sum
