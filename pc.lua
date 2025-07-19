local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Cheat game", HidePremium = false, SaveConfig = false, ConfigFolder = "savecheat", IntroEnabled=false})

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

local vehicleTab = Window:MakeTab({
    Name = "Veículo",
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
        game.Players.LocalPlayer:Kick("Você foi Banido desta experiencia!\nMotivo: Exploiter")
    end
})

main:AddButton({
    Name = "Desligar Hub",
    Callback = function()
        OrionLib:Destroy()
    end
})

local player = game.Players.LocalPlayer

local function rejoin()
    local teleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local jobId = game.JobId

    teleportService:TeleportToPlaceInstance(placeId, jobId, player)
end

-- Example: Call the function when a button is clicked
-- Uncomment the line below to test it manually
-- rejoin()
-- Botão no OrionLib para ativar/desativar o Fly
main:AddButton({
    Name = "Re-entrar",
    Save = true,
    Callback = function()
        rejoin()
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

local speedSection = vehicleTab:AddSection({Name="Aceleração"})

-- Variáveis
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local velocityMult = 0.025
local velocityEnabled = true
local turboKeyCode = Enum.KeyCode.F

-- Slider
vehicleTab:AddSlider({
    Name = "Multiplicador (milésimos)",
    Min = 0,
    Max = 50,
    Default = 25,
    Increment = 1,
    Callback = function(v)
        velocityMult = v / 1000
    end
})

-- Toggle
vehicleTab:AddToggle({
    Name = "Turbo Ativado",
    Default = true,
    Callback = function(v)
        velocityEnabled = v
    end
})

-- Keybind
vehicleTab:AddBind({
    Name = "Ativar Turbo",
    Default = turboKeyCode,
    Hold = true,
    Callback = function()
        if not velocityEnabled then return end
        while UserInputService:IsKeyDown(turboKeyCode) do
            task.wait()

            local Character = LocalPlayer.Character
            if not Character then continue end

            local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
            if not Humanoid then continue end

            local Seat = Humanoid.SeatPart
            local Root = Character:FindFirstChild("HumanoidRootPart")

            -- VehicleSeat
            if Seat and Seat:IsA("VehicleSeat") then
                Seat.AssemblyLinearVelocity *= Vector3.new(1 + velocityMult, 1, 1 + velocityMult)
            end

            -- BodyVelocity, VectorForce, LinearVelocity
            if Root then
                local bv = Root:FindFirstChildWhichIsA("BodyVelocity", true)
                if bv then
                    bv.Velocity *= (1 + velocityMult)
                end

                local vf = Root:FindFirstChildWhichIsA("VectorForce", true)
                if vf then
                    vf.Force *= (1 + velocityMult)
                end

                local lv = Root:FindFirstChildWhichIsA("LinearVelocity", true)
                if lv then
                    lv.VectorVelocity *= (1 + velocityMult)
                end
            end

            if not velocityEnabled then break end
        end
    end
})

-- Slider para controlar força
scripts:AddSlider({
    Name = "⚙️ Multiplicador Turbo",
    Min = 1,
    Max = 100,
    Default = 2,
    Increment = 0.1,
    Flag = "turbo_slider",
    Callback = function(value)
        turboMultiplier = value
    end
})

-- Toggle para ativar/desativar o turbo
scripts:AddToggle({
    Name = "🚀 Turbo Ativado",
    Default = true,
    Save = true,
    Flag = "turbo_toggle",
    Callback = function(state)
        turboEnabled = state
        if not state then
            -- Resetar valores se desligar turbo
            if currentSeat and originalTorque then
                currentSeat.Torque = originalTorque
            end
            if bodyVelocity and originalVelocity then
                bodyVelocity.Velocity = originalVelocity
            end
            if vectorForce and originalForce then
                vectorForce.Force = originalForce
            end
            if linearVelocity and originalLV then
                linearVelocity.VectorVelocity = originalLV
            end
        end
    end
})


-- Aimbot hub
-- Função principal do Aimbot
local function LoadAimbot()
    local Vector2new, CFramenew, Color3fromRGB, Drawingnew =
        Vector2.new, CFrame.new, Color3.fromRGB, Drawing.new

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local RequiredRadius = 150
    local Running = false
    local FilterEnemiesOnly = false
    local Compensation = 0

    local Circle = Drawingnew("Circle")
    Circle.Transparency = 1
    Circle.Thickness = 2
    Circle.Color = Color3fromRGB(255, 255, 255)
    Circle.Filled = false
    Circle.Visible = false
    Circle.Radius = RequiredRadius

    RunService.RenderStepped:Connect(function()
        Circle.Position = Vector2new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        Circle.Radius = RequiredRadius
    end)

    local function IsInCircle(worldPosition)
        local screenPoint, onScreen = Camera:WorldToViewportPoint(worldPosition)
        if not onScreen then return false end
        local center = Vector2new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local distance = (Vector2new(screenPoint.X, screenPoint.Y) - center).Magnitude
        return distance <= RequiredRadius
    end

    local function GetClosestPlayer()
        local closestPlayer = nil
        local closestDistance = math.huge

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if FilterEnemiesOnly and player.Team == LocalPlayer.Team then
                    continue
                end

                local head = player.Character:FindFirstChild("Head")
                if head and IsInCircle(head.Position) then
                    local distance = (Camera.CFrame.Position - head.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end

        return closestPlayer
    end

    local function ApplyCompensation(pos)
        return Vector3.new(pos.X, pos.Y + Compensation * 0.1, pos.Z)
    end

    RunService.RenderStepped:Connect(function()
        if not Running then return end

        local target = GetClosestPlayer()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                local aimPos = ApplyCompensation(head.Position)
                Camera.CFrame = CFramenew(Camera.CFrame.Position, aimPos)
            end
        end
    end)

    return {
        Start = function()
            Running = true
            Circle.Visible = true
        end,
        Stop = function()
            Running = false
            Circle.Visible = false
        end,
        SetRadius = function(val)
            RequiredRadius = val
        end,
        SetCompensation = function(val)
            Compensation = val
        end,
        EnableEnemyOnly = function(val)
            FilterEnemiesOnly = val
        end
    }
end

-- Instancia o Aimbot
local aimbot = LoadAimbot()

-- Toggle: Ativar Aimbot
scripts:AddToggle({
    Name = "🎯 Ativar Aimbot",
    Default = false,
    Save = true,
    Flag = "aimbot_toggle",
    Callback = function(state)
        if state then
            aimbot.Start()
        else
            aimbot.Stop()
        end
    end
})

-- Toggle: Só mirar em inimigos
scripts:AddToggle({
    Name = "🔒 Aimbot só em inimigos",
    Default = true,
    Save = true,
    Flag = "aimbot_enemyonly_toggle",
    Callback = function(state)
        aimbot.EnableEnemyOnly(state)
    end
})

-- Slider: Tamanho da Mira
scripts:AddSlider({
    Name = "📏 Tamanho da Mira",
    Min = 20,
    Max = 500,
    Default = 150,
    Save = true,
    Flag = "aimbot_radius",
    Callback = function(value)
        aimbot.SetRadius(value)
    end
})

-- Slider: Compensação Vertical
scripts:AddSlider({
    Name = "📐 Compensação Vertical",
    Min = 0,
    Max = 100,
    Default = 0,
    Save = true,
    Flag = "aimbot_compensation",
    Callback = function(value)
        aimbot.SetCompensation(value)
    end
})

-- Função para criar o medidor de ping
local function LoadPingPopup()
    local Text = Drawing.new("Text")
    Text.Visible = false
    Text.Center = true
    Text.Outline = true
    Text.Color = Color3.fromRGB(0, 255, 0)
    Text.Size = 20
    Text.Position = Vector2.new(100, 100) -- posição na tela (ajustável)
    Text.Text = "Ping: 0 ms"

    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")

    local Running = false

    -- Loop de atualização do ping
    task.spawn(function()
        while true do
            task.wait(0.5)
            if Running then
                local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
                Text.Text = "📶 Ping: " .. ping
            end
        end
    end)

    return {
        Show = function()
            Running = true
            Text.Visible = true
        end,
        Hide = function()
            Running = false
            Text.Visible = false
        end
    }
end

-- Instancia o componente de ping
local pingDisplay = LoadPingPopup()

-- Adiciona o botão de toggle no painel
scripts:AddToggle({
    Name = "Mostrar Ping",
    Default = false,
    Save = true,
    Flag = "ping_popup",
    Callback = function(State)
        if State then
            pingDisplay.Show()
        else
            pingDisplay.Hide()
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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local character = nil
local humanoid = nil
local godmodeEnabled = true -- ativado por padrão
local healthListenerConnected = false -- evita múltiplos listeners

local GOD_HEALTH = 1e6

-- Função para aplicar godmode
local function applyGodmode()
    if not humanoid then return end

    -- Impede que morra
    pcall(function()
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)

    -- Define MaxHealth e aguarda para setar Health corretamente
    pcall(function()
        humanoid.MaxHealth = GOD_HEALTH
        task.delay(0.05, function() -- aguarda um pequeno intervalo
            if humanoid and godmodeEnabled then
                humanoid.Health = GOD_HEALTH
            end
        end)
    end)

    -- Se ainda não conectou o listener de vida
    if not healthListenerConnected then
        healthListenerConnected = true
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if godmodeEnabled and humanoid.Health < GOD_HEALTH then
                humanoid.Health = GOD_HEALTH
            end
        end)
    end
end


-- Proteção contra morte e destruição do humanoid
task.spawn(function()
    while true do
        if godmodeEnabled and character then
            -- Espera até o humanoid reaparecer naturalmente após respawn
            if not humanoid or not humanoid.Parent then
                humanoid = character:FindFirstChildOfClass("Humanoid")
            end

            if humanoid:GetState() == Enum.HumanoidStateType.Dead then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                humanoid.Health = GOD_HEALTH
            end
        end
        task.wait(0.1)
    end
end)

-- Quando o personagem é adicionado
local function onCharacterAdded(char)
    character = char
    humanoid = nil
    healthListenerConnected = false

    local try = 0
    repeat
        humanoid = char:FindFirstChildOfClass("Humanoid")
        try += 1
        task.wait(0.2)
    until humanoid or try > 25

    if humanoid then
        applyGodmode()
    end
end

-- Detecta respawn
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

-- Atualização por frame (reforço constante)
RunService.RenderStepped:Connect(function()
    if godmodeEnabled and humanoid then
        if humanoid.Health < GOD_HEALTH then
            humanoid.Health = GOD_HEALTH
        end
    end
end)

-- Toggle no painel admin (caso esteja usando UI de exploit)
scripts:AddToggle({
    Name = "🛡️ GodMode (Imortal)",
    Default = true,
    Save = true,
    Flag = "godmode_toggle",
    Callback = function(state)
        godmodeEnabled = state
        if state and humanoid then
            applyGodmode()
        elseif not state and humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
})

-- TELEPORTE Players (otimizado)
local teleportTarget = nil
local dropdownObject = nil
local lastPlayerList = {}
local debounce = false

-- Compara duas listas simples
local function isPlayerListChanged(newList)
    if #newList ~= #lastPlayerList then return true end
    for i, name in ipairs(newList) do
        if lastPlayerList[i] ~= name then
            return true
        end
    end
    return false
end

-- Atualiza a lista de jogadores (exceto o local)
local function getPlayerList()
    local players = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    table.sort(players)
    return players
end

-- Atualiza o dropdown apenas se necessário
local function updateDropdownOptions()
    if debounce then return end
    debounce = true

    local newList = getPlayerList()
    if isPlayerListChanged(newList) and dropdownObject then
        dropdownObject:Refresh(newList, true)
        lastPlayerList = newList
    end

    task.delay(1, function() debounce = false end)
end

-- Teleporte
local function teleportToPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = targetPlayer.Character.HumanoidRootPart.Position
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    else
        warn("O jogador não está disponível para teleporte.")
    end
end

-- UI do painel
local teleportTab = Window:MakeTab({
    Name = "Teleportar",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

dropdownObject = teleportTab:AddDropdown({
    Name = "Selecionar Jogador",
    Default = "",
    Options = getPlayerList(),
    Callback = function(value)
        teleportTarget = game.Players:FindFirstChild(value)
    end
})

teleportTab:AddButton({
    Name = "Teleportar",
    Callback = function()
        if teleportTarget then
            teleportToPlayer(teleportTarget)
        else
            warn("Selecione um jogador válido.")
        end
    end
})

-- Atualização automática a cada 2 minutos, mas leve
task.spawn(function()
    while true do
        task.wait(120) -- A cada 2 min
        updateDropdownOptions()
    end
end)

-- Atualiza ao entrar/sair
game.Players.PlayerAdded:Connect(function()
    task.delay(1, updateDropdownOptions)
end)

game.Players.PlayerRemoving:Connect(function()
    task.delay(1, updateDropdownOptions)
end)

OrionLib:Init()
print("Tudo carregado")
