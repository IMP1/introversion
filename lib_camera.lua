if not math.clamp then
    function math.clamp(x, lower, upper)
      return x < lower and lower or (x > upper and upper or x)
    end
end

local camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0

function camera:set()
    love.graphics.push()
    love.graphics.rotate(-self.rotation)
    love.graphics.scale(self.scaleX, self.scaleY)
    love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
    love.graphics.pop()
end

function camera:move(dx, dy)
    self:setX(self.x + (dx or 0))
    self:setY(self.y + (dy or 0))
end

function camera:rotate(dr)
    self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
    sx = sx or 1
    self.scaleX = self.scaleX * sx
    self.scaleY = self.scaleY * (sy or sx)
end

function camera:setX(value)
    if self._bounds then
        self.x = math.clamp(value, self._bounds.x1, self._bounds.x2)
    else
        self.x = value
    end
end

function camera:setY(value)
    if self._bounds then
        self.y = math.clamp(value, self._bounds.y1, self._bounds.y2)
    else
        self.y = value
    end
end

function camera:setPosition(x, y)
    if x then self:setX(x) end
    if y then self:setY(y) end
end

function camera:centreOn(x, y)
    local viewWidth = love.window.getWidth() / self.scaleX
    local viewHeight = love.window.getHeight() / self.scaleY
    self:setPosition(x - viewWidth / 2, y - viewHeight / 2)
end

function camera:setScale(sx, sy)
    self.scaleX = sx or self.scaleX
    self.scaleY = sy or self.scaleY
end

function camera:getBounds()
    return unpack(self._bounds)
end

function camera:setBounds(x1, y1, x2, y2)
    self._bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end

function camera:mousePosition(mx, my)
    return (mx or love.mouse.getX()) * math.abs(self.scaleX) + self.x, (my or love.mouse.getY()) * math.abs(self.scaleY) + self.y
end

function camera:mouseTilePosition(mx, my)
    local x, y = self:mousePosition(mx, my)
    return math.ceil(x / TILE_SIZE), math.ceil(y / TILE_SIZE)
end

function camera:mouseMapPosition(mx, my)
    local x, y = self:mouseTilePosition(mx, my)
    return (x-1) * TILE_SIZE - self.x, (y-1) * TILE_SIZE - self.y
end

return camera