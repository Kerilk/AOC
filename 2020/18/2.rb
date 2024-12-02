require 'whittle'

class AdventParser < Whittle::Parser
  rule(:wsp => /\s+/).skip!
  rule("+") % :left ^ 2
  rule("*") % :left ^ 1
  rule(:int => /[0-9]+/).as { |num| Integer(num) }
  rule("(")
  rule(")")

  rule(:expr) do |r|
    r["(", :expr, ")"].as   { |_, exp, _| exp }
    r[:expr, "+", :expr].as { |a, _, b| a + b }
    r[:expr, "*", :expr].as { |a, _, b| a * b }
    r[:int]
  end

  start(:expr)
end

parser = AdventParser.new

d = File.read('input').lines
puts d.collect.sum { |l| parser.parse(l) }
