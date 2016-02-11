local Introversion_NPC = {}
Introversion_NPC.__index = Introversion_NPC

Introversion_NPC.image = love.graphics.newImage("gfx_park.png")
Introversion_NPC.quad = love.graphics.newQuad(0, 0, 12, 16, Introversion_NPC.image:getWidth(), Introversion_NPC.image:getHeight())
Introversion_NPC.collisionBox = {2, 10, 8, 6}
Introversion_NPC.name = "NPC"

function Introversion_NPC.new(x, y)
    local this = {}
    setmetatable(this, Introversion_NPC)
    this.x = x
    this.y = y
    this.isTalking = false
    this.currentMessage = "" -- what they're in the process of saying
    this.currentText = "" -- what they've gotten out so far
    return this
end

function Introversion_NPC:update(dt)
    -- check people around
    -- if we're talking
        -- update talking
        -- mention the player if we're not and he's joined us
    -- if nobody's talking, respond or initiate a conversation (with random chance)
    -- if nobody's around, wander or stand/sit here.
end

function Introversion_NPC:getCollisionBox()
    local _, _, w, h = self.quad:getViewport()
    local cox, coy, cw, ch = unpack(self.collisionBox)
    local cx, cy = self.x + cox - w / 2, self.y + coy - h
    return cx, cy, cw, ch
end

function Introversion_NPC:draw()
    love.graphics.setColor(255, 255, 255)
    local _, _, w, h = Introversion_NPC.quad:getViewport()
    love.graphics.draw(Introversion_NPC.image, Introversion_NPC.quad, self.x - w / 2, self.y - h)
    if DEBUG and drawCollisions then
        love.graphics.setColor(128, 0, 0, 128)
        local cx, cy, cw, ch = self:getCollisionBox()
        love.graphics.rectangle("fill", cx, cy, cw, ch)
    end
    if self.isTalking then
        self:drawSpeech()
    end
end

function Introversion_NPC:drawSpeech()

end

return Introversion_NPC