require 'nn'
require 'ga'
require 'player'

function nha()
	return Player(3,3)
end


population = {}
for i=1, 20 do
	table.insert(population, Player(1,1))
end

p = select(population)
p.brain.weights_input_hidden:print()