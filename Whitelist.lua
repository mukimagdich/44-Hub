-- SERVICES
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- FUNKTION ZUR HWID-ERMITTLUNG
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

-- WHITELIST JSON URL (Pastebin RAW oder GitHub RAW)
local whitelistURL = "https://pastebin.com/raw/DEIN_CODE" -- <- Ersetze durch deinen Link

-- WHITELIST PRÜFUNG
local success, result = pcall(function()
    return HttpService:JSONDecode(game:HttpGet(whitelistURL))
end)

if not success or not result[hwid] then
    warn("Zugriff verweigert. HWID: " .. hwid)

    -- DISCORD MELDUNG
    local webhook = "https://discord.com/api/webhooks/DEIN_WEBHOOK"
    local data = {
        ["content"] = "**Nicht Whitelist User**",
        ["embeds"] = {{
            ["title"] = "Zugriffsversuch geblockt",
            ["fields"] = {
                {["name"] = "Name", ["value"] = player.Name},
                {["name"] = "UserId", ["value"] = tostring(player.UserId)},
                {["name"] = "HWID", ["value"] = hwid}
            },
            ["color"] = 16711680
        }}
    }

    pcall(function()
        HttpService:PostAsync(webhook, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Whitelist",
        Text = "Nicht autorisiert.",
        Duration = 6
    })

    return -- Script beenden
end

print("Whitelist-Zugriff erlaubt für " .. player.Name)
