---@class Rabbit
local Rabbit = require("Rabbit")

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
        if(turtle.getItemDetail(slot)) then
            if(turtle.getItemDetail(slot).name=="minecraft:wheat") then
                turtle.dropDown()
            end
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