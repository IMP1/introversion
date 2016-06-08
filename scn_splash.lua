local Scene = { Name = "splash" }
Scene.__index = Scene

Scene.animation = Animation.new(0, love.graphics.getHeight() - 540, 0.1, "gfx_crow.png", 9, 1, true)
Scene.sound = love.audio.newSource("sfx_bird.ogg", "static")
Scene.sound:setPitch(0.8)

function Scene.new(titleMusic)
    local this = {}
    setmetatable(this, Scene)
    this.timer = 0
    this.titleOpacity = 0
    this.sceneOpacity = 255
    this.titleFadeSpeed = 128
    this.fadeSpeed = 64
    this.skippable = true
    this.animation:reset()
    this.titleMusic = titleMusic
    Scene.sound:setVolume(1)
    Scene.sound:play()
    return this
end

function Scene:update(dt)
    self.animation:update(dt)
    self.timer = self.timer + dt
    if self.timer > 1 then
        self.titleOpacity = math.min(self.titleOpacity + dt * self.titleFadeSpeed, 255)
    end
    if self.titleOpacity == 255 then
        self.sceneOpacity = math.max(0, self.sceneOpacity - dt * self.fadeSpeed)
        if self.titleMusic then self.titleMusic:play() end
    end
    if self.sceneOpacity < 128 then
        Scene.sound:setVolume(math.max(0, self.sceneOpacity / 128))
    end
    if Scene.sound:getVolume() == 0 and self.sceneOpacity == 0 then
        nextScene = { class=SceneTitle }
    end
end

function Scene:keyreleased()
    if self.skippable then
        self.timer = 1
        self.titleFadeSpeed = self.titleFadeSpeed * 4
        self.fadeSpeed = self.fadeSpeed * 4
        if self.titleMusic then self.titleMusic:play() end
    end
end

function Scene:draw()
    self.animation:draw()
    if self.timer > 1 then
        love.graphics.setFont(Fonts.splash)
        love.graphics.setColor(255, 255, 255, self.titleOpacity)
        love.graphics.printf("Born for Joy", 500, love.graphics.getHeight() / 2 - 128, love.graphics.getWidth() - 500, "center")
        love.graphics.printf("presents...", 500, love.graphics.getHeight() / 2 - 64, love.graphics.getWidth() - 500, "center")
    end
    if self.titleOpacity == 255 then
        love.graphics.setColor(0, 0, 0, 255 - self.sceneOpacity)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end
end

return Scene