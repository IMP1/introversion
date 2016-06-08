local Scene = { Name = "title" }
Scene.__index = Scene

Scene.bgm = love.audio.newSource("sfx_ddgroove.mp3", "stream")

function Scene.new()
    love.audio.play(Scene.bgm)
    local this = {}
    setmetatable(this, Scene)
    this.timer = 0
    this.bg = 0
    this.fg = 255
    this.promptTimer = 0
    this.promptOpacity = 0
    this.fadingOut = false
    this.fadeSpeed = 64
    this.fadeOut = 0
    return this
end

function Scene:update(dt)
    self.timer = self.timer + dt
    if self.timer > 1 then
        self.bg = math.min(self.bg + dt * 128, 255)
    end
    if self.bg == 255 then
        self.fg = math.max(0, self.fg - dt * 128)
    end
    if self.fg == 0 then
        self.promptTimer = self.promptTimer + dt * 2
        self.promptOpacity = math.min(255, (math.sin(self.promptTimer - math.pi / 2) + 1) * 128)
    end
    if self.fadingOut then
        self.fadeOut = math.min(255, self.fadeOut + dt * self.fadeSpeed)
        if self.fadeOut == 255 then
            nextScene = { class=SceneIntrovert }
        end
    end
end

function Scene:draw()
    love.graphics.setBackgroundColor(self.bg, self.bg, self.bg)
    love.graphics.setColor(self.fg, self.fg, self.fg, 255 - self.fg)
    love.graphics.setFont(Fonts.title)
    love.graphics.printf("Re Ov So AL", 0, 64, love.graphics.getWidth(), "center")
    if self.fg == 0 and not self.fadingOut then
        love.graphics.setColor(0, 0, 0, self.promptOpacity)
        love.graphics.setFont(Fonts.promptBig)
        love.graphics.printf("Press any key to begin", 0, love.graphics.getHeight() - 128, love.graphics.getWidth(), "center")
    end
    if self.fadingOut then
        love.graphics.setColor(255, 255, 255, self.fadeOut)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end
end

function Scene:keyreleased()
    if self.fadingOut then
        self.fadeSpeed = self.fadeSpeed * 2
    elseif self.bg == 255 then
        self.fadingOut = true
    end
end

return Scene