local Scene = { Name = "introversion" }
Scene.__index = Scene

Scene.bgm = love.audio.newSource("sfx_ddgroove.mp3", "stream")

function Scene.new()
    local this = {}
    setmetatable(this, Scene)
    this:setup()
    this:createMap()
    this:populateMap()
    return this
end

function Scene:setup()
    self.fadingIn = true
    self.fadeIn = 0
    self.fadeInSpeed = 128
    self.drawables = {}
    self.needRefreshDrawables = true
end

function Scene:createMap()
    self.map = love.filesystem.load("map_introvert.lua")()
    table.sort(self.map.items, function(a, b) return a[3] < b[3] end)
    self.camera = require("lib_camera")
    self.camera:setBounds(0, 0, self.map.width, self.map.height)
    self.camera:centreOn(256, 256)
    self.camera:scale(2)
    self.saturation = 100 -- percent
    self.brightness = 100 -- percent
end

function Scene:populateMap()
    self.player = Player.new(200, 200)
    self.npcs = {}
    -- local n = math.floor(math.random() * 100)
    local n = 1
    for i = 1, n do
        local npc = NPC1.new(300, 200)
        table.insert(self.npcs, npc)
    end
    -- ~TODO: add peeps
end

function Scene:update(dt)
    if self.fadingIn then
        self.fadeIn = math.min(255, self.fadeIn + dt * self.fadeInSpeed)
    end
    self:updatePlayer(dt)
    self.camera:centreOn(self.player.x, self.player.y)
    if self.needRefreshDrawables then
        self:refreshDrawables()
    end
end

function Scene:refreshDrawables()
    self.drawables = {}
    for _, obj in pairs(self.map.items) do
        table.insert(self.drawables, self:tileToDrawable(obj))
    end
    for _, npc in pairs(self.npcs) do
        table.insert(self.drawables, npc)
    end
    table.insert(self.drawables, self.player)
    table.sort(self.drawables, function(a, b) return a.y < b.y end)
    self.needRefreshDrawables = false
end

function Scene:tileToDrawable(obj)
    return {
        name = obj[1],
        x = obj[2],
        y = obj[3],
        draw = function(this) 
            love.graphics.setColor(255, 255, 255)
            local _, _, w, h = this.quad:getViewport()
            love.graphics.draw(scene.map.tileImage, this.quad, this.x - w/2, this.y - h)
            if DEBUG and drawCollisions then
                love.graphics.setColor(128, 0, 0, 128)
                local cx, cy, cw, ch = scene:getObjectCollisionBox(this)
                love.graphics.rectangle("fill", cx, cy, cw, ch)
            end
        end,
        quad = scene.map.tiles[obj[1]],
    }
end

function Scene:updatePlayer(dt)
    local dx, dy = 0, 0
    if love.keyboard.isDown("w") then dy = dy - dt * self.player.WALK_SPEED end
    if love.keyboard.isDown("a") then dx = dx - dt * self.player.WALK_SPEED end
    if love.keyboard.isDown("s") then dy = dy + dt * self.player.WALK_SPEED end
    if love.keyboard.isDown("d") then dx = dx + dt * self.player.WALK_SPEED end
    if dx ~= 0 and dy ~= 0 then
        dx = dx / ROOT_2
        dy = dy / ROOT_2
    end
    self.player:update(dt)
    self.player:move(dx, dy, self.map)
    if self.player.justMoved then
        self.needRefreshDrawables = true
    end
end

function Scene:draw()
    self.camera:set()
    self:drawMap()
    self.camera:unset()
    if self.fadingIn then
        love.graphics.setColor(255, 255, 255, 255 - self.fadeIn)
        love.graphics.rectangle("fill", 0, 0, love.window.getWidth(), love.window.getHeight())
    end
end

function Scene:getObjectCollisionBox(obj)
    local _, _, ow, oh = self.map.tiles[obj[1]]:getViewport()
    local cox, coy, cw, ch = unpack(self.map.collisionBoxes[obj[1]])
    local cx, cy = obj[2] + cox - ow / 2, obj[3] + coy - oh
    return cx, cy, cw, ch
end

function Scene:drawMap()
    love.graphics.setColor(self.map.bgColour)
    love.graphics.rectangle("fill", 0, 0, self.map.width, self.map.height)
    love.graphics.setColor(255, 255, 255)
    for _, obj in pairs(self.drawables) do
        obj:draw()
    end
end

return Scene