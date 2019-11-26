local Bird = {}
Bird.__index = Bird

local EPSILON = 2

Bird.image = love.graphics.newImage("gfx_bird.png")
Bird.animationQuads = {
    idling = {
        love.graphics.newQuad(0, 0, 8, 8, Bird.image:getWidth(), Bird.image:getHeight()),
    },
    walking = {
        love.graphics.newQuad(0, 8, 8, 8, Bird.image:getWidth(), Bird.image:getHeight()),
        love.graphics.newQuad(8, 8, 8, 8, Bird.image:getWidth(), Bird.image:getHeight()),
    },
    flying = {
        love.graphics.newQuad(0, 16, 8, 8, Bird.image:getWidth(), Bird.image:getHeight()),
        love.graphics.newQuad(8, 16, 8, 8, Bird.image:getWidth(), Bird.image:getHeight()),
    },
    landing = {
        love.graphics.newQuad(0, 24, 8, 8, Bird.image:getWidth(), Bird.image:getHeight()),
        love.graphics.newQuad(8, 24, 8, 8, Bird.image:getWidth(), Bird.image:getHeight()),
        love.graphics.newQuad(16, 24, 8, 8, Bird.image:getWidth(), Bird.image:getHeight()),
        love.graphics.newQuad(24, 24, 8, 8, Bird.image:getWidth(), Bird.image:getHeight()),
    },
    taking_off = {
        love.graphics.newQuad(0, 32, 8, 8, Bird.image:getWidth(), Bird.image:getHeight()),
        love.graphics.newQuad(8, 32, 8, 8, Bird.image:getWidth(), Bird.image:getHeight()),
        love.graphics.newQuad(16, 32, 8, 8, Bird.image:getWidth(), Bird.image:getHeight()),
        love.graphics.newQuad(24, 32, 8, 8, Bird.image:getWidth(), Bird.image:getHeight()),
    },
}
Bird.animationSpeeds = {
    idling = 0.4,
    walking = 0.4,
    flying = 0.4,
    landing = 0.2,
    taking_off = 0.3,
}
Bird.flySpeed = 96 -- pixels per second
Bird.walkSpeed = 16 -- pixels per second

Bird.animationColours = {
    idling     = {0, 0, 0},
    walking    = {0, 0, 1},
    flying     = {1, 1, 0},
    landing    = {1, 0, 0},
    taking_off = {0, 1, 0},
}

local function change_state(bird, new_state)
    bird.state = new_state
    bird.animationFrame = 1
end

function Bird.new(x, y)
    local self = {}
    setmetatable(self, Bird)
    self.x = x
    self.y = y
    self.isFlying = false
    self.isWalking = false
    self.animationTimer = 0
    self.animationFrame = 1
    change_state(self, "idling")
    self.idleTimer = 0
    self.targetX = x
    self.targetY = y
    return self
end

function Bird:update(dt)
    -- Update Animation
    local loop_ended = false
    self.animationTimer = self.animationTimer + dt
    if self.animationTimer >= Bird.animationSpeeds[self.state] then
        self.animationTimer = self.animationTimer - Bird.animationSpeeds[self.state]
        self.animationFrame = self.animationFrame + 1
        if self.animationFrame > #self.animationQuads[self.state] then
            self.animationFrame = 1
            loop_ended = true
        end
    end
    -- Update State and Movement
    local speed = 0
    if self.state == "taking_off" then
        if loop_ended then
            change_state(self, "flying")
        end
        speed = Bird.flySpeed
    elseif self.state == "landing" then
        if loop_ended then
            change_state(self, "idling")
        end
        speed = 0
    elseif self.state == "flying" then
        speed = Bird.flySpeed
    elseif self.state == "walking" then
        speed = Bird.walkSpeed
    end
    if speed ~= 0 then
        local r = math.atan2(self.targetY - self.y, self.targetX - self.x)
        self.x = self.x + math.cos(r) * speed * dt
        self.y = self.y + math.sin(r) * speed * dt
        if math.abs(self.targetX - self.x) < EPSILON then self.x = self.targetX end
        if math.abs(self.targetY - self.y) < EPSILON then self.y = self.targetY end
        if self.x == self.targetX and self.y == self.targetY then
            change_state(self, "landing")
        end
    else
        self.idleTimer = self.idleTimer + dt
    end
    if self.state ~= "flying" and self.state ~= "taking_off" then
        local p = scene:personNearTo(self.x, self.y, 64)
        if p then
            self.targetX = self.x + 2 * (self.x - p.x)
            self.targetY = self.y + 2 * (self.y - p.y)
            change_state(self, "taking_off")
        end
    end
end

function Bird:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(Bird.image, Bird.animationQuads[self.state][self.animationFrame], self.x, self.y)
    love.graphics.setColor(Bird.animationColours[self.state])
    love.graphics.rectangle("fill", self.x, self.y + 10, 6, 6)
end

return Bird