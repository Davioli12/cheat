local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Cheat game", HidePremium = false, SaveConfig = true, ConfigFolder = "savecheat", IntroEnabled=false})

local passcheat = 0

local main = Window:MakeTab({
    Name = "Principal",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local scripts = Window:MakeTab({
    Name = "scripts",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = main:AddSection({
    Name = "Section"
})
OrionLib:MakeNotification({
    Name = "Hub carregado!",
    Content = "Notification: Hub carregado",
    Image = "rbxassetid://4483345998",
    Time = 5
})

main:AddButton({
    Name = "Sair",
    Callback = function()
        game.Players.LocalPlayer:Kick("Você foi desconectado!")
    end
})

main:AddButton({
    Name = "Desligar Hub",
    Callback = function()
        OrionLib:Destroy()
    end
})

-- Fly melhorado para PC e Mobile
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Configurable Variables
local flySpeed = 50 -- Speed at which the player flies
local flying = false

-- Create body movers
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.Velocity = Vector3.new(0, 0, 0)
bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)

local bodyGyro = Instance.new("BodyGyro")
bodyGyro.CFrame = character.HumanoidRootPart.CFrame
bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)

-- Function to start flying
local function startFlying()
    flying = true
    bodyVelocity.Parent = character.HumanoidRootPart
    bodyGyro.Parent = character.HumanoidRootPart
    humanoid.PlatformStand = true
end

local function setupCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
end

setupCharacter()  -- Inicializa o personagem atual

player.CharacterAdded:Connect(function()  -- Reconfigura quando o personagem renasce
    setupCharacter()
    if flying then  -- Se o fly estava ativo antes de morrer, reativa o fly automaticamente
        startFlying()
    end
end)

-- Function to stop flying
local function stopFlying()
    flying = false
    bodyVelocity.Parent = nil
    bodyGyro.Parent = nil
    humanoid.PlatformStand = false
end

local UIS = game:GetService("UserInputService")

-- Fly logic
game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    if flying then
        local moveDirection = Vector3.new(0, 0, 0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + (workspace.CurrentCamera.CFrame.LookVector)
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - (workspace.CurrentCamera.CFrame.LookVector)
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - (workspace.CurrentCamera.CFrame.RightVector)
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + (workspace.CurrentCamera.CFrame.RightVector)
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end

        bodyVelocity.Velocity = moveDirection * flySpeed
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
    end
end)

-- Botão no OrionLib para ativar/desativar o Fly
main:AddToggle({
    Name = "Ativar Fly",
    Default = false,
    Save = true,
    Flag = "fly_toggle",
    Callback = function(State)
        if State then
            startFlying()
        else
            stopFlying()
        end
    end
})

-- Adicionando suporte para toques em dispositivos móveis
local function onTouchInput(touch, gameProcessedEvent)
    if gameProcessedEvent then return end
    if flying then
        local moveDirection = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        local touchPosition = touch.Position

        -- Calcular a direção com base na posição do toque
        local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        local direction = (touchPosition - screenCenter).unit

        -- Ajustar a direção do movimento
        if direction.Y > 0 then
            moveDirection = moveDirection + (camera.CFrame.LookVector)
        elseif direction.Y < 0 then
            moveDirection = moveDirection - (camera.CFrame.LookVector)
        end

        if direction.X < 0 then
            moveDirection = moveDirection - (camera.CFrame.RightVector)
        elseif direction.X > 0 then
            moveDirection = moveDirection + (camera.CFrame.RightVector)
        end

        bodyVelocity.Velocity = moveDirection * flySpeed
        bodyGyro.CFrame = camera.CFrame
    end
end

-- Conectar o evento de toque
UIS.TouchTap:Connect(onTouchInput)

-- ESP HACK
_G.ESPEnabled = false -- Toggle para ativar/desativar ESP

_G.FriendColor = Color3.fromRGB(0, 0, 255)
_G.EnemyColor = Color3.fromRGB(255, 0, 0)
_G.UseTeamColor = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function createESP(player)
    if not player.Character then return end

    -- Criando o Highlight para ESP
    local highlight = player.Character:FindFirstChild("GetReal")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "GetReal"
        highlight.Adornee = player.Character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = player.Character
    end

    -- Define a cor baseada na equipe
    highlight.FillColor = _G.UseTeamColor and player.TeamColor.Color or 
        ((LocalPlayer.TeamColor == player.TeamColor) and _G.FriendColor or _G.EnemyColor)
    highlight.Enabled = _G.ESPEnabled

    -- Criando a tag de nome
    local head = player.Character:FindFirstChild("Head")
    if head then
        local billboard = head:FindFirstChild("NameTag")
        if not billboard then
            billboard = Instance.new("BillboardGui")
            billboard.Name = "NameTag"
            billboard.Adornee = head
            billboard.Size = UDim2.new(0, 75, 0, 15) -- Tamanho menor do nome
            billboard.StudsOffset = Vector3.new(0, 2, 0) -- Posição ajustada acima da cabeça
            billboard.AlwaysOnTop = true
            billboard.Parent = head

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextScaled = true
            nameLabel.Font = Enum.Font.SourceSansBold
            nameLabel.TextColor3 = highlight.FillColor
            nameLabel.TextStrokeTransparency = 0.7 -- Texto menos exagerado
            nameLabel.Text = player.Name
            nameLabel.Parent = billboard
        end
        billboard.Enabled = _G.ESPEnabled
    end
end

-- Atualiza o ESP para todos os jogadores
local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
        end
    end
end

-- Ativação e desativação do ESP
function toggleESP(state)
    _G.ESPEnabled = state

    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("GetReal")
            if highlight then
                highlight.Enabled = state
            end

            local head = player.Character:FindFirstChild("Head")
            if head then
                local billboard = head:FindFirstChild("NameTag")
                if billboard then
                    billboard.Enabled = state
                end
            end
        end
    end
end

-- Monitora jogadores novos
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- Tempo para garantir carregamento
        createESP(player)
    end)
end)

-- Loop otimizado para atualizar o ESP
task.spawn(function()
    while task.wait(1) do
        if _G.ESPEnabled then
            updateESP()
        end
    end
end)

-- Botão no OrionLib
main:AddToggle({
    Name = "Ativar ESP",
    Default = false,
    Save = true,
    Flag = "esp_toggle",
    Callback = function(State)
        toggleESP(State)
    end
})

-- JOIN SERVER SYSTEM
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local placeId = game.PlaceId  -- ID do jogo atual

local serverId = "" -- Variável para armazenar o ID do servidor digitado

-- Função para entrar no servidor pelo ID
function JoinServer()
    if serverId and serverId ~= "" then
        print("Tentando entrar no servidor:", serverId)
        TeleportService:TeleportToPlaceInstance(placeId, serverId, player)
    else
        warn("ID do servidor inválido!")
    end
end

-- Caixa de texto para digitar o ID do servidor
main:AddTextbox({
    Name = "Digite o ID do servidor",
    Default = "",
    TextDisappear = false, -- Mantém o texto visível após perder o foco
    Callback = function(Value)
        serverId = Value -- Armazena o ID digitado
    end
})

-- Botão para teleportar ao servidor digitado
main:AddButton({
    Name = "Entrar no Servidor",
    Callback = function()
        JoinServer()
    end
})

-- Noclip HACK
local Noclip = nil
local Clip = true  -- Inicializando Clip como verdadeiro

function noclip()
    Clip = false
    local function Nocl()
        if Clip == false and game.Players.LocalPlayer.Character ~= nil then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA('BasePart') and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
        wait(0.21) -- Basic optimization
    end
    Noclip = game:GetService('RunService').Stepped:Connect(Nocl)
end

function clip()
    if Noclip then
        Noclip:Disconnect()
    end
    Clip = true
    -- Revertendo a colisão para as partes, se necessário
    for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA('BasePart') then
            v.CanCollide = true
        end
    end
end

main:AddToggle({
    Name = "Noclip",
    Default = false,
    Save = true,
    Flag = "noclip_toggle",
    Callback = function(State)
        if State == true then
            noclip()
        else
            clip()
        end
    end
})

main:AddDropdown({
    Name = "Drop",
    Default = "1",
    Options = {"1", "2", "valor", "cheat", "kick"},
    Callback = function(Value)
        print(Value)
        if Value == "kick" then
            game.Players.LocalPlayer:Kick("Você foi desconectado!")
        elseif Value == "cheat" then
            print("XITADOSSOOOOOOOOOOO")
            passcheat = passcheat + 1
            if passcheat == 3 then
                game.Players.LocalPlayer:Kick("Você foi banido por usar cheats!")
            end
        end
    end    
})

scripts:AddButton({
    Name = "Infinite yeild",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Infinite-yeild-fe-14386"))()
        OrionLib:MakeNotification({
            Name = "Carregando hub",
            Content = "Notification: Infinite yeild carregado",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
})

-- Aimbot
local function LoadAimbot()
    local getrawmetatable, getmetatable, setmetatable, pcall, getgenv, next, tick = getrawmetatable, getmetatable, setmetatable, pcall, getgenv, next, tick
    local Vector2new, Vector3zero, CFramenew, Color3fromRGB, Drawingnew = Vector2.new, Vector3.zero, CFrame.new, Color3.fromRGB, Drawing.new

    local LocalPlayer = game.Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local RequiredDistance = 2000
    local Running = false

    local function GetClosestPlayer()
        local closestPlayer = nil
        local closestDistance = RequiredDistance

        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (Camera.CFrame.Position - player.Character.HumanoidRootPart.Position).magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end

        return closestPlayer
    end

    game:GetService("RunService").RenderStepped:Connect(function()
        if Running then
            local targetPlayer = GetClosestPlayer()
            if targetPlayer and targetPlayer.Character then
                local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
                Camera.CFrame = CFramenew(Camera.CFrame.Position, targetPosition)
            end
        end
    end)

    return {
        Start = function()
            Running = true
        end,
        Stop = function()
            Running = false
        end
    }
end

local aimbot = LoadAimbot()

scripts:AddToggle({
    Name = "Ativar AimBot",
    Default = false,
    Save = true,
    Flag = "aimbot_toggle",
    Callback = function(State)
        if State then
            aimbot.Start()
        else
            aimbot.Stop()
        end
    end
})

scripts:AddButton({
    Name = "Speed car Universal",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Documantation12/Universal-Vehicle-Script/main/Main.lua'))()
    end
})

if game.PlaceId == 4924922222 then
    scripts:AddButton({
        Name = "Rael-Hub",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Laelmano24/Rael-Hub/main/main.txt"))()
        end
    })
end

-- TELEPORTE Players
local teleportTarget = nil  -- Jogador para quem será teleportado

-- Função para teleporte
local function teleportToPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
    else
        warn("O jogador não está disponível para teleporte.")
    end
end

-- Atualiza a lista de jogadores na Dropdown
local function updatePlayerList()
    local players = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end

local teleport_player = Window:MakeTab({
    Name = "Teleportar",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Dropdown para selecionar o jogador
teleport_player:AddDropdown({
    Name = "Selecionar Jogador",
    Default = "",
    Options = updatePlayerList(),
    Callback = function(value)
        teleportTarget = game.Players:FindFirstChild(value)
    end
})

-- Botão para teleporte
teleport_player:AddButton({
    Name = "Teleportar",
    Callback = function()
        if teleportTarget then
            teleportToPlayer(teleportTarget)
        else
            warn("Selecione um jogador válido.")
        end
    end
})

-- Atualiza a lista de jogadores quando novos jogadores entram ou saem do jogo
game.Players.PlayerAdded:Connect(function()
    teleport_player:AddDropdown({
        Name = "Selecionar Jogador",
        Default = "",
        Options = updatePlayerList(),
        Callback = function(value)
            teleportTarget = game.Players:FindFirstChild(value)
        end
    })
end)

game.Players.PlayerRemoving:Connect(function()
    teleport_player:AddDropdown({
        Name = "Selecionar Jogador",
        Default = "",
        Options = updatePlayerList(),
        Callback = function(value)
            teleportTarget = game.Players:FindFirstChild(value)
        end
    })
end)

OrionLib:Init()
