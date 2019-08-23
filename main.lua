require 'player'
require 'ga'

function love.load()
  w, h = love.graphics.getDimensions( )
  
  food = {}
  food.w = 10
  food.h = 10
  food.color = {0, 1, 0}
  food.x = math.random(0, w - food.w)
  food.y = math.random(0, h - 100 - food.h)
  food.max_time = 6
  food.time = food.max_time

  max_generation_time = 90
  generation_time = max_generation_time
  generation_number = 1
  cr = 0.7
  mr = 0.05
  sr = 1 - (cr+mr)
  population = {}
  for i=1, 15 do
    table.insert(population, Player(math.random(0, w-30),
                                math.random(h-100, h-30)))
  end
end

function love.update(dt)
  if generation_time > 0 then
    generation_time = generation_time - dt
    for i, player in ipairs(population) do
      player:update(dt, food)
      if check_collision(player, food) then
        player.fitness = player.fitness + 1
        randomize_food(food, w, h)
      end
    end

    food.time = food.time - dt
    if food.time < 0 then
      randomize_food(food, w, h)
    end
  else
    generation_number = generation_number + 1
    generation_time = max_generation_time
    new_population = generate_population(population, cr, mr, sr, create)
    population = new_population
    if population == nil then
      print("population")
    end
  end
end

function love.draw(dt)
  for i, player in ipairs(population) do
    player:draw(dt)
  end
  draw_food()

end

function check_collision(player, food)
  return player.x < (food.x + food.w) and
        food.x < (player.x + player.w) and
        player.y < (food.y + food.h) and
        food.y < (player.y + player.h)
end

function draw_food()
  love.graphics.setColor(food.color[1], food.color[2],
                        food.color[3])
  love.graphics.rectangle("fill", food.x, food.y,
                          food.w, food.h)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(generation_time, w-40, 0)
  love.graphics.print(generation_number, w/2, h/2)
end

function randomize_food(food, w, h)
  food.time = food.max_time
  --math.randomseed(os.time())
  food.x = math.random(0, w - food.w)
  food.y = math.random(0, h - food.h)
end

function create()
  return Player(math.random(0, w-30),math.random(h-100, h-30))
end