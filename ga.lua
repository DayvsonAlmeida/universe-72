require 'nn'

function mutation(chromosome, mutation_rate)
  first_layer = chromosome.brain.weights_input_hidden
  second_layer = chromosome.brain.weights_hidden_output

  for i=1, first_layer.rows do
    for j=1, first_layer.columns do
      ticket = math.random()
      if ticket <= mutation_rate then
        first_layer.data[i][j] = math.random()
      end
    end
  end

  for i=1, second_layer.rows do
    for j=1, second_layer.columns do
      ticket = math.random()
      if ticket <= mutation_rate then
        second_layer.data[i][j] = math.random()
      end
    end
  end

  chromosome.brain.weights_input_hidden = first_layer
  chromosome.brain.weights_hidden_output = second_layer
end


function crossover(chromosomeA, chromosomeB, create)
  child1 = create()
  child2 = create()

 
  child1_layer1 = child1.brain.weights_input_hidden
  child1_layer2 = child1.brain.weights_hidden_output
  A_layer1 = chromosomeA.brain.weights_input_hidden
  A_layer2 = chromosomeA.brain.weights_hidden_output


  child2_layer1 = child2.brain.weights_input_hidden
  child2_layer2 = child2.brain.weights_hidden_output
  B_layer1 = chromosomeB.brain.weights_input_hidden
  B_layer2 = chromosomeB.brain.weights_hidden_output

  for i=1, child1_layer1.rows do
    for j=1, child1_layer1.columns do
      
      pick = math.random()
      if pick < 0.5 then
        child1_layer1.data[i][j] = A_layer1.data[i][j]
      else
        child1_layer1.data[i][j] = B_layer1.data[i][j]
      end

      if pick < 0.5 then
        child2_layer1.data[i][j] = B_layer1.data[i][j]
      else
        child2_layer1.data[i][j] = A_layer1.data[i][j]
      end

    end
  end

  for i=1, child2_layer2.rows do
    for j=1, child2_layer2.columns do
      
      pick = math.random()
      if pick < 0.5 then
        child1_layer2.data[i][j] = A_layer2.data[i][j]
      else
        child1_layer2.data[i][j] = B_layer2.data[i][j]
      end

      if pick < 0.5 then
        child2_layer2.data[i][j] = B_layer2.data[i][j]
      else
        child2_layer2.data[i][j] = A_layer2.data[i][j]
      end

    end
  end

  return child1, child2
end



function select(population)
  total_fitness = 1
  for i, chromosome in ipairs(population) do
    total_fitness = total_fitness + chromosome.fitness
  end
  for j=1, 100 do
    for i=1, #population do
      ticket = math.random()
      if ticket <= population[i].fitness/total_fitness then
        return population[i]
      end
    end
  end
  return population[math.random(1,#population)]
end


function generate_population(population, cr, mr, sr, create)
  size = #population
  best_chromosome = population[1]
  for i=1, #population do
    if population[i].fitness > best_chromosome.fitness then
      best_chromosome = population[i]
    end
  end
  best_chromosome.fitness = 0
  new_population = {best_chromosome}
  tamanho = #new_population
  while tamanho < #population do
    op = math.random()
    chromosome = nil
    if op <= cr then
      a = select(population)
      b = select(population)
      chromosome = crossover(a, b, create)
    elseif op > cr and op <= cr+mr then
      a = select(population)
      chromosome = mutation(a, mr)
    else
      chromosome = select(population)
    end
    if chromosome ~= nil then
      chromosome.fitness = 0
      table.insert(new_population, chromosome)
    end
    tamanho = #new_population
  end
  return new_population
end