local component = require("component")
local sides     = require("sides")
local colors    = require("colors")
local term      = require("term")
local keyboard  = require("keyboard")

local rs = component.redstone
local tank = component.tank_controller
local proxy = component.proxy

------------------------Exit function--------------------------------------------------------------

local function Exit()
    term.clear()
    os.exit()
end

------------------------Set proxy------------------------------------------------------------------

local REDSTONE_TANK = "996b73d3"

local REDSTONE_SEND = "3c6991e9"

local rsTank = proxy(component.get(REDSTONE_TANK)) -- Redstone I/O tank

local rsSend = proxy(component.get(REDSTONE_SEND)) -- Redstone I/O send 

------------------------Systheme loop--------------------------------------------------------------

while true do

    term.clear()

    -------------------------Get information from tank----------------------------------------

    local inTank = tank.getFluidInTank(sides.east)[1]

    if inTank and inTank.label ~= nil then
        pct = math.floor((inTank.amount / inTank.capacity) * 100)
        print("\n" .. inTank.label .. " : " .. inTank.amount .. " / " .. inTank.capacity .. " mB\n\n" .. pct .. "%")
    else
        print("\nNo fluid in the tank")
    end

    -------------------------Control system---------------------------------------------------

    if pct <= 50 and pct > 25 and inTank.label ~= nil then  -- Warning 50%
        print("\n! Warning !\nAlarme from " ..inTank.label.. " tank : Average level reached !")
        rsSend.setOutput(sides.west, 15)
        rsSend.setOutput(sides.south, 0)
    elseif pct <= 25 and pct > 10 and restartLevel ~= 1 and inTank.label ~= nil then -- Critical 25%
        print("\n/!\\ Emergency /!\\\nAlarme from " ..inTank.label.. " tank : Critical level reached !")
        rsSend.setOutput(sides.west, 0)
        rsSend.setOutput(sides.south, 15)
        rsTank.setOutput(sides.east, 0)
    elseif pct <= 10 or restartLevel == 1 and inTank.label ~= nil then -- Shutdown 10%
        print("\n/!\\ Emergency /!\\\nAlarme from " ..inTank.label.. " tank : Tank almost empty, shutdown of the installation !")
        rsTank.setOutput(sides.east, 15)
        rsSend.setOutput(sides.south, 15)
        restartLevel = 1
    elseif inTank.label ~= nil then -- Normal
        rsSend.setOutput(sides.west, 0)
        rsSend.setOutput(sides.south, 0)
        rsTank.setOutput(sides.east, 0)
    end

    -------------------------Restart system---------------------------------------------------

    if restartLevel == 1 and pct > 15 then -- Restart level
        restartLevel = false
        rsTank.setOutput(sides.east, 0)
    end

    -------------------------Exit-------------------------------------------------------------

    if keyboard.isShiftDown() and keyboard.isControlDown() then
        restartLevel = false
        rsSend.setOutput(sides.west, 0)
        rsSend.setOutput(sides.south, 0)
        break
    end

    ------------------------------------------------------------------------------------------

    os.sleep(2)

end

---------------------------------------------------------------------------------------------------

Exit()