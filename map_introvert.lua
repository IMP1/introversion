local map = {}

map.width = 2000
map.height = 2000
map.tileImage = love.graphics.newImage("gfx_park.png")
map.tiles = {
    bush    = love.graphics.newQuad(13,  0, 14, 17, map.tileImage:getWidth(), map.tileImage:getHeight()),
    tree    = love.graphics.newQuad(28,  0, 26, 45, map.tileImage:getWidth(), map.tileImage:getHeight()),
    bench   = love.graphics.newQuad( 0, 18, 24, 13, map.tileImage:getWidth(), map.tileImage:getHeight()),
    bin     = love.graphics.newQuad( 0, 32,  9, 13, map.tileImage:getWidth(), map.tileImage:getHeight()),
    light   = love.graphics.newQuad(55,  0,  8, 30, map.tileImage:getWidth(), map.tileImage:getHeight()),
    flowers = love.graphics.newQuad(64,  0, 26, 27, map.tileImage:getWidth(), map.tileImage:getHeight()),
}
map.collisionBoxes = {
    bush    = {0, 8, 14, 9},
    tree    = {7, 36, 12, 9},
    bench   = {0, 5, 24, 8},
    bin     = {0, 4, 9, 9},
    light   = {0, 20, 8, 10},
    flowers = {0, 0, 26, 27},
}
map.bgColour = {119, 165, 47}
map.items = {
    {"tree", 32, 32},
    {"tree", 256, 256},
    {"bench", 256, 280},
    {"bin", 280, 280},
    {"bush", 64, 128},
    {"tree", 80, 128},
    {"bush", 96, 128},
    {"tree", 112, 128},
    {"bush", 128, 128},
    {"tree", 144, 128},
    {"bush", 160, 128},
    {"light", 300, 280}
}
map.paths = {

}

return map