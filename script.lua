-- Detectar plataforma
local platform = UserInputService.TouchEnabled and "Mobile" or "PC"

-- Função para carregar script remoto
local function loadRemoteScript(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Erro ao carregar script: " .. tostring(result))
    end
end

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Esperar o jogador local estar pronto
local player = Players.LocalPlayer
repeat task.wait() until player

-- Detectar e executar o script correspondente
if UserInputService.TouchEnabled then
    -- MOBILE
    StarterGui:SetCore("SendNotification", {
        Title = "Dispositivo Detectado",
        Text = "Você está usando um dispositivo MOBILE. Executando script mobile...",
        Duration = 5
    })

    -- Executar script mobile
    loadRemoteScript("https://raw.githubusercontent.com/Davioli12/cheat/refs/heads/main/mobile.lua")
else
    -- PC
    loadRemoteScript("https://raw.githubusercontent.com/Davioli12/cheat/refs/heads/main/pc.lua")
end
