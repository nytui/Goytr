-- ==========================================
-- GURE.LUA - KEREN HUB (BARISTA UI LOADER)
-- ==========================================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

getgenv().BaristaAutoFarm = false
getgenv().BaristaAntiAfk = false
getgenv().BaristaInstantPrompt = false

local Window = WindUI:CreateWindow({
    Title = "Keren Hub",
    Icon = "gravity:sparkles-fill",
    Author = "Barista Bot",
    Folder = "BaristaBotConfig",
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

local StatsTab = Window:Tab({
    Title = "Stats",
    Icon = "gravity:chart-mixed"
})

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "gravity:play"
})

MainTab:Toggle({
    Title = "Auto Farm Barista",
    Desc = "Aktifkan atau matikan auto farm barista",
    Value = false,
    Callback = function(state)
        getgenv().BaristaAutoFarm = state

        WindUI:Notify({
            Title = "Status Bot",
            Content = state and "Auto Farm Barista diaktifkan!" or "Auto Farm Barista dimatikan!",
            Duration = 2
        })

        if state and getgenv().RunBaristaFarm then
            task.spawn(getgenv().RunBaristaFarm)
        elseif (not state) and getgenv().StopBaristaFarm then
            task.spawn(getgenv().StopBaristaFarm)
        end
    end
})

MainTab:Toggle({
    Title = "Instant Proximity Prompt",
    Desc = "Hilangkan hold duration prompt di sekitar",
    Value = false,
    Callback = function(state)
        getgenv().BaristaInstantPrompt = state
    end
})

local settingsSection = Window:Section({
    Title = "Settings",
    Icon = "gravity:gear",
    Opened = true,
})

settingsSection:Toggle({
    Title = "Anti-AFK",
    Desc = "Cegah kick karena idle terlalu lama",
    Value = false,
    Callback = function(state)
        getgenv().BaristaAntiAfk = state

        WindUI:Notify({
            Title = "Settings",
            Content = state and "Anti-AFK aktif!" or "Anti-AFK nonaktif!",
            Duration = 2
        })
    end
})

WindUI:Notify({
    Title = "UI Berhasil Dimuat",
    Content = "Menghubungkan logika Barista...",
    Duration = 2
})

local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nytui/Goru/refs/heads/main/Goru.lua"))()
end)

if not success then
    warn("[Keren Hub] Gagal memuat file logika Goru: " .. tostring(err))
end
