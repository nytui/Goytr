-- ==========================================
-- GURE.LUA - KEREN HUB (BARISTA UI LOADER)
-- ==========================================

-- 1. Load WindUI Library Resmi (Latest Version)
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

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

-- 2. Buat Jendela Panel Utama & Menu
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

-- Tab biasa langsung di Window
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
    Desc = "Otomatis jalan & proses order berdasarkan status UI (NPC / Brewing / Order / Good)",
    Value = false,
    Callback = function(state)
        State.AutoFarm = state
        local core = getgenv().GoruCore

        WindUI:Notify({
            Title = "Status Bot",
            Content = state and "Auto Farm Barista diaktifkan!" or "Auto Farm Barista dimatikan!",
            Duration = 2
        })

        if state and core and core.StartFarm then
            task.spawn(core.StartFarm)
        elseif (not state) and core and core.StopFarm then
            task.spawn(core.StopFarm)
        end
    end
})

MainTab:Toggle({
    Title = "Instant Proximity Prompt",
    Desc = "Hilangkan hold duration prompt di sekitar",
    Value = false,
    Callback = function(state)
        State.InstantPrompt = state
        local core = getgenv().GoruCore
        if core and core.SetInstantPrompt then
            core.SetInstantPrompt(state)
        end
    end
})

-- Tab Section Settings di paling bawah (isi Anti-AFK aja)
local settingsSection = Window:Section({
    Title = "Settings",
    Icon = "Solar:settings-bold",
    Opened = true,
})

settingsSection:Toggle({
    Title = "Anti-AFK",
    Desc = "Cegah kick karena idle terlalu lama",
    Value = false,
    Callback = function(state)
        State.AntiAfk = state
        local core = getgenv().GoruCore
        if core and core.SetAntiAfk then
            core.SetAntiAfk(state)
        end

        WindUI:Notify({
            Title = "Settings",
            Content = state and "Anti-AFK aktif!" or "Anti-AFK nonaktif!",
            Duration = 2
        })
    end
})

WindUI:Notify({
    Title = "UI Berhasil Dimuat",
    Content = "Menghubungkan logika Goru...",
    Duration = 2
})

-- 3. Tarik dan jalankan file logika bot (Goru.lua) secara otomatis di baliknya
local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nytui/Goru/refs/heads/main/Goru.lua"))()
end)

if not success then
    warn("[Keren Hub] Gagal memuat file logika Goru: " .. tostring(err))
end
