local component = require("component")
local sides     = require("sides")
local colors    = require("colors")
local term      = require("term")
local keyboard  = require("keyboard")
local event     = require("event")
local internet  = require("internet")

local rs = component.redstone

------------------------Exit function--------------------------------------------------------------

local function Exit()
    term.clear()
    os.exit()
end

------------------------Telegram information & cooldown--------------------------------------------

local TeleInfo = dofile("/alarm/telegram_info.lua")

local BOT_TOKEN = TeleInfo.BOT_TOKEN

local CHAT_ID = TeleInfo.CHAT_ID

------------------------Encodage & send message----------------------------------------------------

local function send(msg)
    local url = ("https://api.telegram.org/bot%s/sendMessage?chat_id=%s&text=%s")
        :format(BOT_TOKEN, CHAT_ID, msg:gsub("\n", "\r\n"):gsub("([^%w%-%.%_%~])", function(c)
            return ("%%%02X"):format(c:byte())
        end))
    for chunk in internet.request(url) do end
end

------------------------Blinking light-------------------------------------------------------------

local blinkTimer = nil
local state = false

local function startBlink()
    if not blinkTimer then
        blinkTimer = event.timer(0.5, function()
            state = not state
            rs.setOutput(sides.top, state and 15 or 0)
        end, math.huge)
    end
end

local function stopBlink()
    if blinkTimer then
        event.cancel(blinkTimer)
        blinkTimer = nil
        rs.setOutput(sides.top, 0)
    end
end

------------------------Function I/O redstone------------------------------------------------------

local function inputB(sides, colors) -- Get the input from the bundle
    local result = rs.getBundledInput(sides, colors)
    return result
end

local function SetBig(sides, value) -- Activate the alarm (Emergency)
    rs.setOutput(sides, value)
    startBlink()
end

local function SetSmall(sides, value) -- Activate the alarm (Warning)
    rs.setOutput(sides, value)
end

------------------------Systheme loop--------------------------------------------------------------

while true do

    -------------------------Colors set-------------------------------------------------------

    local white = inputB(sides.south, colors.white)
    local black = inputB(sides.south, colors.black)
    local lime = inputB(sides.south, colors.lime)
    local yellow = inputB(sides.south, colors.yellow)

    -------------------------Alarm message----------------------------------------------------

    local Cleanroom = ("\n/!\\ Emergency /!\\\nAlarme from Cleanroom !")
    local Benzene_crit = ("\n/!\\ Emergency /!\\\nAlarme from Benzene tank : Critical level reached !")

    -------------------------Display on the screen--------------------------------------------

    term.clear()

    print("\nAlarm list :\n")
    
    if white > 1 then -- Cleanroom
        print(Cleanroom)
        signal_white = 1
    else
        signal_white = 0
    end

    if lime > 1 then -- Tank level of Benzene : critical
        print(Benzene_crit)
        signal_lime = 1
    else
        signal_lime = 0
    end

    if black > 1 then -- Benzene production
        print("\n! Warning !\nAlarme from Benzene production !")
    end

    if yellow > 1 then -- Tank level of Benzene : half
        print("\n! Warning !\nAlarme from Benzene tank : Average level reached !")
    end

    -------------------------Message states---------------------------------------------------

    if signal_white == 1 and send_white ~= 1 then
        send(Cleanroom)
        send_white = 1
    elseif signal_white == 0 and send_white == 1 then
        send_white = 0
    end

    if signal_lime == 1 and send_lime ~= 1 then
        send(Benzene_crit)
        send_lime = 1
    elseif signal_lime == 0 and send_lime == 1 then
        send_lime = 0
    end

    -------------------------Alarm states-----------------------------------------------------

    if white > 1 or lime > 1 then -- Turn ON the big alarm
        SetBig(sides.north, 15)
        SetSmall(sides.east, 0)
    elseif black > 1 or yellow > 1 then -- Turn ON the small alarm
        stopBlink()
        SetSmall(sides.east, 15)
        rs.setOutput(sides.top, 15)
        rs.setOutput(sides.north, 0)
    else -- Turn OFF all alarm
        SetBig(sides.north, 0)
        stopBlink()
        SetSmall(sides.east, 0)
        rs.setOutput(sides.top, 0)
    end

    -------------------------Exit-------------------------------------------------------------

    if keyboard.isShiftDown() and keyboard.isControlDown() then
        signal_white = 0
        signal_lime = 0
        break
    end

    ------------------------------------------------------------------------------------------
    
    os.sleep(2)

end

---------------------------------------------------------------------------------------------------

Exit()