require 'set'
xrange, yrange  = File.read("input").match(/target area: x=(\d+..\d+), y=(-\d+..-\d+)/)[1..2].map { |s| eval(s) }

yshots = []
((yrange.min)..(-yrange.min)).each { |y0|
  y = y0
  step = apex = pos = 0
  while pos >= yrange.min
    pos += y
    apex = pos > apex ? pos : apex
    y -= 1
    step += 1
    yshots.push [y0, step, apex] if yrange.include?(pos)
  end 
}

max_step = yshots.map { |s| s[1] }.max

xshots = []
(0..(xrange.max)).each { |x0|
  x = x0
  step = pos = 0
  while step < max_step && pos <= xrange.max
    pos += x
    x += 0 <=> x
    step += 1
    xshots.push [x0, step] if xrange.include?(pos)
  end
}

possible_steps = xshots.map { |s| s[1] }.to_set
p yshots.select { |s| possible_steps.include?(s[1]) }.map { |s| s[2] }.max

ysteps = Hash.new { |h, k| h[k] = [] }
yshots.each { |y0, step, _| ysteps[step].push y0 }

velocities = Set.new
xshots.each { |x0, step|
  ysteps[step].each { |y0| velocities.add([x0, y0]) }
}
p velocities.size
