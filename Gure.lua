-- ==========================================
-- GURE.LUA - WINDUI INTERFACE
-- ==========================================
local GORU_URL = "https://raw.githubusercontent.com/nytui/Goru/refs/heads/main/Goru.lua"

getgenv().KerenBaristaState = getgenv().KerenBaristaState or {
    CurrentStage = "NO_GUI",
    CurrentText = "",
    SnifferLog = true,
    AntiAfk = false,
    AutoFarm = false,
    InstantPrompt = false,
    LastHandledStage = nil,
}

local State = getgenv().KerenBaristaState

local function resolveGoru()
    if type(getgenv().GoruCore) == "table" then
        return getgenv().GoruCore
    end

    local ok, result = pcall(function()
        return loadstring(game:HttpGet(GORU_URL))()
    end)

    if ok then
        if type(result) == "table" then
            getgenv().GoruCore = result
            return result
        elseif type(getgenv().GoruCore) == "table" then
            return getgenv().GoruCore
        end
    end

    return nil
end

local Goru = resolveGoru()

-- Auto-hook kalau Goru.lua baru ke-load belakangan
task.spawn(function()
    while true do
        if not Goru then
            Goru = resolveGoru()
            if Goru then
                if State.AntiAfk and Goru.SetAntiAfk then
                    pcall(Goru.SetAntiAfk, true)
                end
                if State.InstantPrompt and Goru.SetInstantPrompt then
                    pcall(Goru.SetInstantPrompt, true)
                end
                if State.AutoFarm and Goru.StartFarm then
                    pcall(Goru.StartFarm)
                end
            end
        end
        task.wait(0.5)
    end
end)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Keren Hub",
    Icon = "gravity:sparkles-fill",
    Author = "Drag Drive Simulator",
    Folder = "DDS",
    Size = UDim2.fromOffset(580, 360),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function() end
    }
})

-- 1. Tab Stats
local StatsTab = Window:Tab({
    Title = "Stats",
    Icon = "gravity:chart-mixed"
})

-- 2. Tab Main
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "gravity:play"
})

MainTab:Toggle({
    Title = "Auto Farm Barista",
    Desc = "Otomatis jalan & proses order berdasarkan status UI (NPC / Brewing / Order / Good)",
    Value = State.AutoFarm,
    Callback = function(Value)
        State.AutoFarm = Value
        Goru = Goru or resolveGoru()
        if Value then
            if Goru and Goru.StartFarm then
                Goru.StartFarm()
            else
                warn("[Gure.lua] Menunggu Goru.lua siap...")
            end
        else
            if Goru and Goru.StopFarm then
                Goru.StopFarm()
            end
        end
    end
})

MainTab:Toggle({
    Title = "Instant Proximity Prompt",
    Desc = "Hilangkan hold duration prompt di sekitar",
    Value = State.InstantPrompt,
    Callback = function(Value)
        State.InstantPrompt = Value
        Goru = Goru or resolveGoru()
        if Goru and Goru.SetInstantPrompt then
            Goru.SetInstantPrompt(Value)
        end
    end
})

-- 3. Tab Section Settings di paling bawah (isi Anti-AFK aja)
local settingsSection = Window:Section({
    Title = "Settings",
    Icon = "Solar:settings-bold",
    Opened = true,
})

settingsSection:Toggle({
    Title = "Anti-AFK",
    Desc = "Cegah kick karena idle terlalu lama",
    Value = State.AntiAfk,
    Callback = function(Value)
        State.AntiAfk = Value
        Goru = Goru or resolveGoru()
        if Goru and Goru.SetAntiAfk then
            Goru.SetAntiAfk(Value)
        end
    end
})
