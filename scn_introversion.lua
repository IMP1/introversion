local Scene = { Name = "introversion" }
Scene.__index = Scene

Scene.bgm = love.audio.newSource("sfx_ddgroove.mp3", "stream")

function Scene.new()
    local this = {}
    setmetatable(this, Scene)
    this.fadingIn = true
    this.fadeIn = 0
    this.fadeInSpeed = 128
    this.map = love.filesystem.load("map_introvert.lua")()
    table.sort(this.map.items, function(a, b) return a[3] < b[3] end)
    this.camera = require("lib_camera")
    this.camera:setBounds(0, 0, this.map.width, this.map.height)
    this.camera:centreOn(256, 256)
    this.camera:scale(2)
    this.player = Player.new(64, 32)
    this.saturation = 100 -- percent
    this.brightness = 100 -- percent
    return this
end

function Scene:update(dt)
    if self.fadingIn then
        self.fadeIn = math.min(255, self.fadeIn + dt * self.fadeInSpeed)
    end
    self:updatePlayer(dt)
    self.camera:centreOn(self.player.x, self.player.y)
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
    self.player:move(dx, dy, self.map)
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

function Scene:drawMap()
    love.graphics.setColor(self.map.bgColour)
    love.graphics.rectangle("fill", 0, 0, self.map.width, self.map.height)
    love.graphics.setColor(255, 255, 255)
    local i = 1
    while i <= #self.map.items and self.map.items[i][3] < self.player.y do
        local t = self.map.items[i]
        local _, _, w, h = self.map.tiles[t[1]]:getViewport()
        love.graphics.draw(self.map.tileImage, self.map.tiles[t[1]], t[2] - w/2, t[3] - h)
        i = i + 1
    end
    self.player:draw()
    while i <= #self.map.items do
        local t = self.map.items[i]
        local _, _, w, h = self.map.tiles[t[1]]:getViewport()
        love.graphics.draw(self.map.tileImage, self.map.tiles[t[1]], t[2] - w/2, t[3] - h)
        i = i + 1
    end
end

return Scene