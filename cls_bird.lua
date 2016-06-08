local Bird = {}
Bird.__index = Bird

Bird.flySpeed = 96 -- pixels per second
Bird.walkSpeed = 16 -- pixels per second

function Bird.new(x, y)
    local this = {}
    setmetatable(this, Bird)
    this.x = x
    this.y = y
    this.isFlying = false
    this.isWalking = false
    this.idleTimer = 0
    this.targetX = x
    this.targetY = y
    return this
end

function Bird:update(dt)
    local speed = 0
    if self.isFlying then
        speed = Bird.flySpeed
    elseif self.isWalking then
        speed = Bird.walkSpeed
    end
    if speed ~= 0 then
        local r = math.atan2(self.targetY - self.y, self.targetX - self.x)
        self.x = self.x + math.cos(r) * speed * dt
        self.y = self.y + math.sin(r) * speed * dt
        if math.abs(self.targetX - self.x) < 2 then self.x = self.targetX end
        if math.abs(self.targetY - self.y) < 2 then self.y = self.targetY end
        if self.x == self.targetX and self.y == self.targetY then
            self.isWalking = false
            self.isFlying = false
        end
    else
        self.idleTimer = self.idleTimer + dt
    end
    if not self.isFlying then
        local p = scene:personNearTo(self.x, self.y, 64)
        if p then
            self.targetX = self.x + 2 * (self.x - p.x)
            self.targetY = self.y + 2 * (self.y - p.y)
            self.isFlying = true
        end
    end
end

function Bird:draw()
    if self.isFlying then
        
    elseif self.isWalking then
        
    else
        
    end
    love.graphics.circle("fill", self.x, self.y, 4)
end

return Bird