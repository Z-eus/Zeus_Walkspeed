local VORPcore = exports.vorp_core:GetCore()
local VORPMenu = {}

TriggerEvent("vorp_menu:getData", function(cb)
    VORPMenu = cb
end)

local function SetPlayerSpeed(speed)
    local playerPed = PlayerPedId()
    if speed then
        SetPedMaxMoveBlendRatio(playerPed, speed)
    end
end

local currentSpeed = nil
local isSpeedChanged = false

local function WalkSpeedMenu()
    VORPMenu.CloseAll()

    local walkSpeedMenu = {
        {label = "Default Speed", value = nil},  -- DONT TOUCH
        {label = "Speed 0.2", value = 0.2}, -- Default 0.2
        {label = "Speed 0.4", value = 0.4}, -- Default 0.4
        {label = "Speed 0.6", value = 0.6}, -- Default 0.6
        {label = "Speed 0.8", value = 0.8} -- Default 0.8
        -- See above and you can add more (Max value = 3.0) --
    }

    VORPMenu.Open("default", GetCurrentResourceName(), "zeus_walkspeed_menu",
        {
            title = "Change Walk Speed",
            subtext = "Select a speed:",
            align = Config.MenuAlign,
            elements = walkSpeedMenu
        },
        function(data, menu)
            local selectedSpeed = data.current.value
            currentSpeed = selectedSpeed
            isSpeedChanged = true
            if currentSpeed then
                VORPcore.NotifyRightTip("Character walking speed changed: " .. tostring(currentSpeed), 4000)
            else
                VORPcore.NotifyRightTip("Character walking speed reset to default", 4000)
            end
            menu.close()
        end,
        function(data, menu)
            menu.close()
        end
    )
end

CreateThread(function()
    while true do
        Wait(0)

        if isSpeedChanged then
            if currentSpeed then
                SetPlayerSpeed(currentSpeed)
            else
                --DONT TOUCH
            end
        end
    end
end)

RegisterCommand(Config.Command, function()
    if Config.OpenMenuWithCommand then
        WalkSpeedMenu()
    end
end, false)

CreateThread(function()
    while Config.OpenMenuWithKey do
        Wait(0)
        if IsControlJustPressed(0, Config.Key1) and IsControlJustPressed(0, Config.Key2) then
            WalkSpeedMenu()
        end
    end
end)