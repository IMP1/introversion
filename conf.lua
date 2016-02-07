function love.conf(t)
	local aspectRatio = 16 / 10
    t.window.title = "Re ov so aL"
    t.window.width = 1020
    t.window.height = t.window.width / aspectRatio

    t.modules.joystick = false
    t.modules.math = false
    t.modules.physics = false
    t.modules.touch = false
    t.modules.video = false
end