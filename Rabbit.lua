---------------------------------------------------------------
---------------------------------------------------------------
--- RABBIT
---------------------------------------------------------------
---------------------------------------------------------------

local function createMatrix(rows, columns)
    local matrix = {}
    for i = 1, rows do
    matrix[i] = {}
    for j = 1, columns do
        matrix[i][j] = 0
    end
    end
    return matrix
end

local function printMatrix(matrix)
    for i = #matrix, 1, -1 do
        for j = #matrix[i], 1, -1 do
            io.write(matrix[i][j], " ")
        end
        io.write("\n")
    end
end

-- rabbit class

---@class Rabbit
---@field x number
---@field y number
---@field orientation '"N"'|'"E"'|'"S"'|'"W"'
---@field matrix any[][]
---@field turtleEnabled boolean
local Rabbit = {}
Rabbit.__index = Rabbit

---@return Rabbit
function Rabbit:new(matrixSize)
    local obj = setmetatable({
        x = 2,
        y = 2,
        orientation = 'N',
        matrix = createMatrix(matrixSize,matrixSize),
        turtleEnabled = false
    },Rabbit)
    obj.matrix[obj.x][obj.y]='*'
    return obj
end

function Rabbit:printMatrix()
    printMatrix(self.matrix)
end

function Rabbit:printPosition()
    print(string.format("x: %s, y: %s, orientation: %s", self.x, self.y, self.orientation))
end

local orientations = { "N", "E", "S", "W" }

local directionVectors = {
    N = { dx =  1, dy =  0 },
    E = { dx =  0, dy = -1 },
    S = { dx = -1, dy =  0 },
    W = { dx =  0, dy =  1 }
}

function Rabbit:turnLeft()
    for i, dir in ipairs(orientations) do
        if dir == self.orientation then
            local newIndex = (i - 2) % #orientations + 1
            self.orientation = orientations[newIndex]
            if self.turtleEnabled then
                turtle.turnLeft()
            end
            return
        end
    end
end

function Rabbit:turnRight()
    for i, dir in ipairs(orientations) do
        if dir == self.orientation then
            local newIndex = (i % #orientations) + 1
            self.orientation = orientations[newIndex]
            if self.turtleEnabled then
                turtle.turnRight()
            end
            return
        end
    end
end

function Rabbit:isWithinBounds(x, y)
    return x >= 1 and x <= #self.matrix and
           y >= 1 and y <= #self.matrix[1]
end

function Rabbit:forward()
    local dir = directionVectors[self.orientation]
    local newX = self.x + dir.dx
    local newY = self.y + dir.dy

    if self:isWithinBounds(newX, newY) then
        self.x = newX
        self.y = newY
        self.matrix[newX][newY] = '*'
        if self.turtleEnabled then
            turtle.forward()
        end
    else
        print("Cannot move forward: out of bounds.")
    end
end

function Rabbit:back()
    local dir = directionVectors[self.orientation]
    local newX = self.x - dir.dx
    local newY = self.y - dir.dy

    if self:isWithinBounds(newX, newY) then
        self.x = newX
        self.y = newY
        self.matrix[newX][newY] = '*'
        if self.turtleEnabled then
            turtle.back()
        end
    else
        print("Cannot move backward: out of bounds.")
    end
end

return Rabbit