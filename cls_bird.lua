local Bird = {}
Bird.__index = Bird

Bird.walkSpeed =  -- pixels per second

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

    elseif self.isWalking then

    end
    if speed == 0 then
        self.idleTimer = self.idleTimer + dt
    end
end

function Bird:draw()
    if self.isFlying then

    elseif self.isWalking then

    else

    end
end

return Bird