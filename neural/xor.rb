#!/usr/bin/ruby

require "neural.rb"

# training data
D = [
  [[0, 0], [0]],
  [[1, 1], [0]],
  [[0, 1], [1]],
  [[1, 0], [1]],
]

# units
in_units = [Unit.new("x1"), Unit.new("x2")]
bias = [BiasUnit.new("1")]
hiddenunits = [TanhUnit.new("z1"), TanhUnit.new("z2"), TanhUnit.new("z3"), TanhUnit.new("z4")]
out_unit = [SigUnit.new("y1")]

# network
network = Network.new
network.in  = in_units
network.link in_units + bias, hiddenunits
network.link hiddenunits + bias, out_unit
network.out = out_unit

eta = 0.1
sum_e = 999999
1000.times do |tau|
  s = 0
  D.each do |data|
    s += network.sum_of_squares_error(data[0], data[1])
  end
  puts "sum of errors: #{tau} => #{s}"
  break if s > sum_e
  sum_e = s

  D.sort{rand}.each do |data|
    grad = network.gradient_E(data[0], data[1])
    network.descent_weights eta, grad
  end
end
network.weights.dump
