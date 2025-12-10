-- Love Snake

window_width = love.graphics.getWidth()
window_height = love.graphics.getHeight()
cell_size = window_width / 20
snake = {x = window_width / 2, y = window_height / 2, dx = cell_size + 1, dy = 0, cells = {}, length = 1}
apple = {x = 0, y = 0} 
score = 0

function list_iter(t)
    local i = 0
    local n = #t
    return function()
        i = i + 1
        if i <= n then return t[i] end 
    end 
end 

function check_collision(x1, y1, x2, y2)
    -- 1st right edge -> 2nd left edge
    -- 1st left edge <- 2nd right edge 
    -- 1st bottom edge V 2nd top edge 
    -- 1st top edge ^ 2nd bottom edge 
    return ((x1 + cell_size >= x2) and (x1 <= x2 + cell_size) and (y1 + cell_size >= y2) and (y1 <= y2 + cell_size))
end 

function sign(number) 
    if number > 0 then 
        return 1 
    elseif number < 0 then 
        return -1 
    else 
        return 0
    end 
end 

function respawn_apple() 
    apple.x = math.random(window_width - cell_size)
    apple.y = math.random(window_height - cell_size)
    for cell in list_iter(snake.cells) do 
        if check_collision(cell.x, cell.y, apple.x, apple.y) then 
            respawn_apple()
        end 
    end 
end 

function restart_game()
    score = 0
    snake.length = 1 
    snake.x = window_width / 2
    snake.y = window_height / 2
    respawn_apple()
end 

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    respawn_apple()
end 

function love.update(dt)
    if love.timer then love.timer.sleep(1/love.fps) end 

    for i=2,#snake.cells do 
        if check_collision(snake.cells[1].x, snake.cells[1].y, snake.cells[i].x, snake.cells[i].y) then
            restart_game()
        end
    end 

    snake.x = snake.x + snake.dx
    snake.y = snake.y + snake.dy

    if snake.x < (0 - cell_size) then 
        snake.x = window_width - cell_size 
    elseif snake.x >= window_width then 
        snake.x = 0
    end 

    if snake.y < (0 - cell_size) then 
        snake.y = window_height - cell_size
    elseif snake.y >= window_height then 
        snake.y = 0
    end 

    table.insert(snake.cells, 1, {x = snake.x, y = snake.y})
    while #snake.cells > snake.length do 
        table.remove(snake.cells)
    end

    if check_collision(snake.cells[1].x, snake.cells[1].y, apple.x, apple.y) then 
        snake.length = snake.length + 1
        respawn_apple()
        score = score + 1
    end 
end

function love.draw()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill", apple.x, apple.y, cell_size, cell_size)
    love.graphics.setColor(0, 1, 0, 1)
    for cell in list_iter(snake.cells) do 
        love.graphics.rectangle("fill", cell.x, cell.y, cell_size, cell_size)
    end 
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.print(score, 0, 0, 0, 4, 4, 0, 0)
end 

function love.keypressed(key, unicode)
    if key == 'a' or key == 'left' then 
        snake.dx = -(cell_size + 1)
        snake.dy = 0
    elseif key == 'd' or key == 'right' then 
        snake.dx = cell_size + 1
        snake.dy = 0
    elseif key == 'w' or key == 'up' then
        snake.dx = 0
        snake.dy = -(cell_size + 1)
    elseif key == 's' or key == 'down' then 
        snake.dx = 0
        snake.dy = (cell_size + 1)
    end 
end