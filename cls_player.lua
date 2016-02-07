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
    return this
end

function Player:move(dx, dy, map)
    local newX = self.x + dx
    local newY = self.y + dy
    -- collision parameters
    local _, _, w, h = self.quad:getViewport()
    local cox, coy, cw, ch = unpack(self.collisionBox)

    local cx, cy = newX + cox - w / 2, self.y + coy - h
    if self:canMoveTo(cx, cy, cw, ch, map) then
        self.x = newX
    end
    cx, cy = self.x + cox - w / 2, newY + coy - h
    if self:canMoveTo(cx, cy, cw, ch, map) then
        self.y = newY
    end
end

function Player:canMoveTo(x, y, w, h, map)
    for _, obj in pairs(map.items) do
        local _, _, ow, oh = map.tiles[obj[1]]:getViewport()
        local cx, cy = obj[2], obj[3]
        local cox, coy, cw, ch = unpack(map.collisionBoxes[obj[1]])
        cx, cy = cx + cox - ow / 2, cy + coy - oh

        local overlap = (cx >= x + w or
                         x >= cx + cw or
                         cy >= y + h or
                         y >= cy + ch)
        if not overlap then return false end
    end
    return true
end

function Player:draw()
    local _, _, w, h = Player.quad:getViewport()
    love.graphics.draw(Player.image, Player.quad, self.x - w / 2, self.y - h)
end

return Player