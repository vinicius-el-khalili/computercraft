-- wget run https://raw.githubusercontent.com/vinicius-el-khalili/computercraft/refs/heads/master/main.lua

local n = 9

local function organizeInventory()
    print("organizeInventory")
    for slot=1,16,1 do
        if(turtle.getItemDetail(slot)) then
            if(turtle.getItemDetail(slot).name=="minecraft:wheat_seeds") then
                turtle.select(slot)
                turtle.transferTo(1)
            end
        end
    end
    turtle.select(1)
end

local function verifySeedCount()
    if(turtle.getItemCount(1)==0) then
        organizeInventory()
    end
end

local function moveForwardLine(number)
    for i=1,number,1 do
        turtle.forward()
    end
end


local function farmBlock()
    verifySeedCount()
    turtle.digDown()
    turtle.placeDown()
end

local function farmLine()
    for i=1,n,1 do
        farmBlock()
        if(i<n) then
            turtle.forward()
        end
    end
end

local function isOdd(number)
    return number%2==1
end

local function main()
    organizeInventory()
    for i=1,n,1 do
        farmLine()
        if (i<n-1) then
            if(isOdd(i)) then
                turtle.turnLeft()
                turtle.forward()
                turtle.turnLeft()
            else
                turtle.turnRight()
                turtle.forward()
                turtle.turnRight()
            end
        end
    end
end

main()
