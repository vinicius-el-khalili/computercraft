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
---@field turtleTurnLeft any
---@field turtleTurnRight any
---@field turtleForward any
---@field turtleBack any
local Rabbit = {}
Rabbit.__index = Rabbit

---@return Rabbit
function Rabbit:new(matrixSize)
    local obj = setmetatable({
        x = 2,
        y = 2,
        orientation = 'N',
        matrix = createMatrix(matrixSize,matrixSize),
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
            if self.turtleTurnLeft then
                self.turtleTurnLeft()
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
            if self.turtleTurnRight then
                self.turtleTurnRight()
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
        if self.turtleForward then
            self.turtleForward()
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
        if self.turtleBack then
            self.turtleBack()
        end
    else
        print("Cannot move backward: out of bounds.")
    end
end

---------------------------------------------------------------
---------------------------------------------------------------
--- MAIN
---------------------------------------------------------------
---------------------------------------------------------------

local rabbit = Rabbit.new(Rabbit,20)

local function move(number)
    for i=1,number,1 do
        rabbit.forward(rabbit)
    end
end

local function farmBlock()
    rabbit.matrix[rabbit.x][rabbit.y]="w"
end

local function farmStraightLine(number)
    for i=1,number,1 do
        farmBlock()
        if (i<number) then
            rabbit.forward(rabbit)
        end
    end
end

local function main()
    for i=1,9 do
        farmStraightLine(8)
        if (i%2==1) then
            rabbit.turnLeft(rabbit)
            rabbit.forward(rabbit)
            rabbit.turnLeft(rabbit)
        else
            rabbit.turnRight(rabbit)
            rabbit.forward(rabbit)
            rabbit.turnRight(rabbit)
        end
    end
    move(9)
    rabbit.turnLeft(rabbit)
    move(9)
    rabbit.turnLeft(rabbit)
end

main()
rabbit.printMatrix(rabbit)
rabbit.printPosition(rabbit)

function Rabbit:wtf ()
    print('wtf kkk lol')
    print(self.orientation)
end

rabbit.wtf(rabbit)
