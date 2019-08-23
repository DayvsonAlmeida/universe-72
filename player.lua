require 'class'
require 'nn'
require 'matrix'
math.randomseed(os.time())

local function player_base(p, x, y)
  p.x = x
  p.y = y
  p.w = 30
  p.h = 30
  p.speed = 250
  p.color = {math.random(), math.random(), math.random()}
  
  p.fitness = 0
  p.brain = NN(2,5,4)
  p.input = {1,1}

end

Player = Class(player_base)


function Player:draw(dt)
  love.graphics.setColor(self.color[1], self.color[2],
                        self.color[3])
  love.graphics.rectangle("fill", self.x, self.y,
                          self.w, self.h)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(self.fitness, self.x+self.w/2, self.y + self.h/2)
end

function Player:update(dt, food)
  -- INPUT: Distância do player para a comida em x, y
  self.input = {food.x-self.x, food.y-self.y} -- [dx, dy]
  decision = self.brain:predict(self.input)
  -- decision [left, right, up, down]
  pos = 1
  for i=2, #decision do
    if decision[i] > decision[pos] then
      pos = i
    end
  end

  if pos == 1 then
    self:left(dt)
  elseif pos == 2 then
    self:right(dt)
  elseif pos == 3 then
    self:up(dt)
  elseif pos == 4 then
    self:down(dt)
  end
end

function Player:up(dt)
  w, h = love.graphics.getDimensions()
  dspeed = self.speed * dt
  if (self.y-dspeed >= 0) then
    self.y = self.y - dspeed
  end
end

function Player:down(dt)
  w, h = love.graphics.getDimensions()
  dspeed = self.speed * dt
  if (self.y+self.h+dspeed <= h) then
    self.y = self.y + dspeed
  end
end

function Player:right(dt)
  w, h = love.graphics.getDimensions()
  dspeed = self.speed * dt
  if ( self.x+self.w+dspeed <= w) then
    self.x = self.x + dspeed
  end
end

function Player:left(dt)
  w, h = love.graphics.getDimensions()
  dspeed = self.speed * dt
  if ( self.x - dspeed >= 0) then
    self.x = self.x - dspeed
  end
end







