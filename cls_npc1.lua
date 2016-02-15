local NPC = {}
NPC.__index = NPC

NPC.image = love.graphics.newImage("gfx_park.png")
NPC.quad = love.graphics.newQuad(0, 0, 12, 16, NPC.image:getWidth(), NPC.image:getHeight())
NPC.collisionBox = {2, 10, 8, 6}
NPC.name = "NPC"
NPC.speechFont = love.graphics.newImageFont("gfx_pixel_font.png", "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,-!?:()[]{}_|")
NPC.speechSpeed = 0.1 -- seconds per character
NPC.speechWait = 1.5 -- seconds to wait having said their line

function NPC.new(x, y)
    local this = {}
    setmetatable(this, NPC)
    this.x = x
    this.y = y
    local _, _, w, h = NPC.quad:getViewport()
    this.width = w
    this.height = h
    this.isTalking = true
    this.currentMessage = "" -- what they're in the process of saying
    this.currentText = ""    -- what they've gotten out so far
    this.currentMessage = "Hey there. How's it going?" -- DEBUG
    this.textPauseTimer = 0
    this.textTimer = 0
    return this
end

function NPC:update(dt)
    -- check people around
    -- if we're talking
        -- update talking
        -- mention the player if we're not and he's joined us
    -- if nobody's talking, respond or initiate a conversation (with random chance)
    -- if nobody's around, wander or stand/sit here.
    self:updateSpeech(dt)
end

function NPC:updateSpeech(dt)
    if self.currentText == self.currentMessage then
        self.textPauseTimer = self.textPauseTimer + dt
        if self.textPauseTimer > NPC.speechWait then
            self.isTalking = false
        end
    else
        self.textTimer = self.textTimer + dt
        while self.textTimer >= NPC.speechSpeed do
            local index = math.min(self.currentText:len() + 1, self.currentMessage:len())
            self.currentText = self.currentMessage:sub(1, index)
            self.textTimer = self.textTimer - NPC.speechSpeed
        end
    end
end

function NPC:getCollisionBox()
    local _, _, w, h = self.quad:getViewport()
    local cox, coy, cw, ch = unpack(self.collisionBox)
    local cx, cy = self.x + cox - w / 2, self.y + coy - h
    return cx, cy, cw, ch
end

function NPC:draw()
    love.graphics.setColor(255, 255, 255)
    local _, _, w, h = NPC.quad:getViewport()
    love.graphics.draw(NPC.image, NPC.quad, self.x - w / 2, self.y - h)
    if DEBUG and drawCollisions then
        love.graphics.setColor(128, 0, 0, 128)
        local cx, cy, cw, ch = self:getCollisionBox()
        love.graphics.rectangle("fill", cx, cy, cw, ch)
    end
    if self.isTalking then
        self:drawSpeech()
    end
end

function NPC:drawSpeech()
    local unscale = scene.camera.scaleX
    local padding = 8   -- distance between edge of bubble and text
    local gap = 8       -- distance between edge of bubble and NPC
    local w = love.graphics.getFont():getWidth(self.currentMessage) + padding * 2
    local h = love.graphics.getFont():getHeight() + padding * 2
    local x = self.x - (w / unscale) / 2
    local y = self.y - (h / unscale) - self.height - gap
    local roundedness = 4
    love.graphics.push()
    love.graphics.scale(1 / unscale)
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", x * unscale, y * unscale, w, h, roundedness)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", x * unscale, y * unscale, w, h, roundedness)
    love.graphics.setFont(NPC.speechFont)
    love.graphics.print(self.currentText, x * unscale + padding, y * unscale + padding)
    love.graphics.pop()
end

return NPC