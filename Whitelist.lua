local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Funktion zur HWID-Ermittlung
local function getHWID()
    if syn and syn.gethwid then
        return "syn_" .. syn.gethwid()
    elseif KRNL_LOADED and gethwid then
        return "krnl_" .. gethwid()
    elseif identifyexecutor then
        return identifyexecutor() .. "_" .. player.UserId
    else
        return "unknown_" .. player.UserId
    end
end

local hwid = getHWID()

-- Whitelist-URL
local whitelistURL = "https://raw.githubusercontent.com/DEIN_USERNAME/44-hub/main/whitelist.json"

local success, result = pcall(function()
    return HttpService:JSONDecode(game:HttpGet(whitelistURL))
end)

if not success or not result[hwid] then
    warn("Zugriff verweigert. HWID: " .. hwid)
    return
end

print("Zugriff erlaubt für " .. player.Name)
