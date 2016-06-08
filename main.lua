DEBUG = true
console = false
consoleCommand = ""

ROOT_2 = math.sqrt(2)

love.graphics.setDefaultFilter("nearest", "nearest")

Animation = require("lib_animation")

Player = require("cls_player")
NPC1 = require("cls_npc1")
Bird = require("cls_bird")

SceneSplash = require("scn_splash")
SceneTitle = require("scn_title")
SceneIntrovert = require("scn_introversion")


Fonts = {
    splash = love.graphics.newFont("gfx_hopeless.ttf", 48),
    default = love.graphics.getFont(),
    title = love.graphics.newFont("gfx_crayon.ttf", 96),
    promptBig = love.graphics.newFont("gfx_crayon.ttf", 24)
}

function love.load()
    -- scene = SceneSplash.new(SceneTitle.bgm)
    scene = SceneIntrovert.new()
    nextScene = nil
end

function love.update(dt)
    if DEBUG and console then
        return
    end
    if scene and scene.update then
        scene:update(dt)
    end
    if nextScene then
        scene = nextScene.class.new(unpack(nextScene.params or {}))
        nextScene = nil
    end
end

function love.draw()
    if scene and scene.draw then
        scene:draw()
    end
    if DEBUG then
        if console then
            love.graphics.setColor(0, 0, 0, 128)
            local y = love.window.getHeight() - 32
            love.graphics.rectangle("fill", 0, y, love.window.getWidth(), 32)
            love.graphics.setColor(255, 255, 255, 128)
            local x = 32 + love.graphics.getFont():getWidth(consoleCommand)
            love.graphics.print(consoleCommand, 32, y + 8)
            love.graphics.line(x + 4, y + 4, x + 4, y + 32 - 8)
        end
    end
end

function love.textinput(text)
    if DEBUG and console then
        if text ~= "`" then
            consoleCommand = consoleCommand .. text
        end
    end
end

function love.keyreleased(key)
    if not (DEBUG and console) then
        if scene and scene.keyreleased then
            scene:keyreleased(key)
        end
    end
    if DEBUG then
        if not console and key == "`" then
            console = true
        elseif console then
            if key == "`" then
                console = false
            elseif key == "backspace" then
                consoleCommand = consoleCommand:sub(1, consoleCommand:len() - 1)
            elseif key == "return" then
                local again = false
                local lastChar = consoleCommand:sub(consoleCommand:len(), consoleCommand:len())
                if lastChar == "," then
                    again = true
                    consoleCommand = consoleCommand:sub(1, consoleCommand:len() - 1)
                end
                local f = loadstring(consoleCommand)
                if f ~= nil then f() end
                consoleCommand = ""
                console = again
            end
        end
    end
end