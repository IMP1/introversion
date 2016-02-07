ROOT_2 = math.sqrt(2)

love.graphics.setDefaultFilter("nearest", "nearest")

Animation = require("lib_animation")

Player = require("cls_player")

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
end

function love.keyreleased()
	if scene and scene.keyreleased then
        scene:keyreleased(key)
    end
end