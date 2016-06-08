local Player = {}
Player.WALK_SPEED = 64
Player.__index = Player

Player.image = love.graphics.newImage("gfx_park.png")
Player.quad = love.graphics.newQuad(0, 0, 12, 16, Player.image:getWidth(), Player.image:getHeight())
Player.collisionBox = {2, 10, 8, 6}

function Player.new(x, y)
    local this = {}
    setmetatable(this, Player)
    this.x = x or 0
    this.y = y or 0
    this.through = false
    this.justMoved = false
    return this
end

function Player:update(dt)
    self.justMoved = false
end

function Player:move(dx, dy, map, objects)
    dx, dy = map.moveGradient(self.x, self.y, dx, dy)
    local newX = self.x + dx
    local newY = self.y + dy
    -- collision parameters
    local cx, cy, cw, ch = self:getCollisionBox()
    if self:canMoveTo(cx + dx, cy, cw, ch, objects) then
        self.x = newX
        self.justMoved = true
    end
    if self:canMoveTo(cx, cy + dy, cw, ch, objects) then
        self.y = newY
        self.justMoved = true
    end
end

function Player:getCollisionBox()
    local _, _, w, h = self.quad:getViewport()
    local cox, coy, cw, ch = unpack(self.collisionBox)
    local cx, cy = self.x + cox - w / 2, self.y + coy - h
    return cx, cy, cw, ch
end

function Player:canMoveTo(x, y, w, h, objects)
    if self.through then return true end
    for _, obj in pairs(objects) do
        if obj ~= self and obj.getCollisionBox then
            local cx, cy, cw, ch = obj:getCollisionBox()
            local overlap = (cx >= x + w or
                             x >= cx + cw or
                             cy >= y + h or
                             y >= cy + ch)
            if not overlap then return false end
        end
    end
    return true
end

function Player:draw()
    love.graphics.setColor(255, 255, 255)
    local _, _, w, h = Player.quad:getViewport()
    love.graphics.draw(Player.image, Player.quad, self.x - w / 2, self.y - h)
    if DEBUG and drawCollisions then
        love.graphics.setColor(128, 0, 0, 128)
        local cx, cy, cw, ch = self:getCollisionBox()
        love.graphics.rectangle("fill", cx, cy, cw, ch)
    end
end

return Player