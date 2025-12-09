-- Love Snake

Grid = {}
Grid_width = 25
Grid_height = 25
Window_width = love.graphics.getWidth()
Window_height = love.graphics.getHeight()
Cell_width = Window_width / Grid_width
Cell_height = Window_height / Grid_height
Head = {["x"] = math.floor(Grid_width / 2), ["y"] = math.floor(Grid_height / 2)}
Directions = {
    ["left"] = false,
    ["right"] = false,
    ["up"] = false,
    ["down"] = false,
}

function love.load()
    for i=0, Grid_height do
        Grid[i] = {}
        for j=0, Grid_width do
            Grid[i][j] = 0
        end
    end
end 

function love.update(dt)
    Grid[Head["x"]][Head["y"]] = 0

    if Directions["left"] then 
        Head["x"] = Head["x"] - 1
    elseif Directions["right"] then 
        Head["x"] = Head["x"] + 1
    end

    if Directions["down"] then 
        Head["y"] = Head["y"] + 1
    elseif Directions["up"] then 
        Head["y"] = Head["y"] - 1
    end 

    if Head["x"] >= Grid_width then 
        Head["x"] = 0
    end 
    if Head["x"] < 0 then 
        Head["x"] = Grid_width - 1
    end 

    if Head["y"] >= Grid_height then 
        Head["y"] = 0
    end
    if Head["y"] < 0 then 
        Head["y"] = Grid_height - 1
    end 

    Directions = {
        ["left"] = love.keyboard.isDown("a"),
        ["right"] = love.keyboard.isDown("d"),
        ["up"] = love.keyboard.isDown("w"),
        ["down"] = love.keyboard.isDown("s"),
    }

    Grid[Head["x"]][Head["y"]] = 1
end

function love.draw()
    for i=0, Grid_width do
        for j=0, Grid_height do
            local draw_mode = (Grid[i][j] == 0 and "line") or "fill"
            love.graphics.rectangle(draw_mode, i * Cell_width, j * Cell_height, Cell_width, Cell_height)
        end
    end
end 