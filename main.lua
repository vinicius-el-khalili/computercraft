-- wget run https://raw.githubusercontent.com/vinicius-el-khalili/computercraft/refs/heads/master/main.lua

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

---------------------------------------------------------------
---------------------------------------------------------------
--- MAIN
---------------------------------------------------------------
---------------------------------------------------------------


function Rabbit:move(number)
    for i=1,number,1 do
        self.forward(self)
    end
end

function Rabbit:organizeInventory()
    if (not self.turtleEnabled) then
        return
    end
    for slot=1,16 do
        if(turtle.getItemDetail(slot)) then
            if(turtle.getItemDetail(slot).name=="minecraft:wheat_seeds") then
                turtle.select(slot)
                turtle.transferTo(1)
            end
        end
    end
    turtle.select(1)
end

function Rabbit:dropInventory()
    if (not self.turtleEnabled) then
        return
    end
    for slot=1,16 do
        turtle.select(slot)
        if(turtle.getItemDetail(slot).name=="minecraft:wheat") then
            turtle.dropDown()
        end
    end
    self.organizeInventory(self)
end

function Rabbit:verifySeedCount()
    if (not self.turtleEnabled) then
        return
    end
    if(turtle.getItemCount(1)==0) then
        self.organizeInventory(self)
    end
end

function Rabbit:farmBlock()
    if (not self.turtleEnabled) then
        self.matrix[self.x][self.y]="w"
        return
    end
    self.verifySeedCount(self)
    turtle.digDown()
    turtle.placeDown()
    self.matrix[self.x][self.y]="w"
end

function Rabbit:farmStraightLine(number)
    for i=1,number,1 do
        self.farmBlock(self)
        if (i<number) then
            self.forward(self)
        end
    end
end

local function main(turtleEnabled)
    local rabbit = Rabbit.new(Rabbit,20)
    rabbit.turtleEnabled = turtleEnabled
    rabbit.organizeInventory(rabbit)
    for i=1,9 do
        rabbit.farmStraightLine(rabbit,9)
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
    rabbit.move(rabbit,9)
    rabbit.turnLeft(rabbit)
    rabbit.move(rabbit,9)
    rabbit.turnLeft(rabbit)
    rabbit.dropInventory(rabbit)
    rabbit.forward(rabbit)
    rabbit.printMatrix(rabbit)
end

main(true)