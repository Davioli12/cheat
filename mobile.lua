-- Mobile Cheat Hub - Versão otimizada para dispositivos móveis
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Variáveis globais
local GUI = {}
local currentTab = "main"
local isGUIVisible = true

-- Configurações dos cheats
local Settings = {
    fly = false,
    esp = false,
    noclip = false,
    godmode = true,
    speed = 0,
    aimbot = false,
    showPing = false
}

-- Função para criar a GUI principal
local function CreateMobileGUI()
    -- ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MobileCheatHub"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 320, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    -- Cantos arredondados
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    header.BorderSizePixel = 0
    header.Parent = mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header

    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "📱 Mobile Cheat Hub"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = header

    -- Botão minimizar
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
    minimizeBtn.Position = UDim2.new(1, -45, 0, 5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextScaled = true
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = header

    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 8)
    minimizeCorner.Parent = minimizeBtn

    -- Container de abas
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, 0, 0, 40)
    tabContainer.Position = UDim2.new(0, 0, 0, 50)
    tabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame

    -- ScrollingFrame para o conteúdo
    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Name = "ContentScroll"
    contentScroll.Size = UDim2.new(1, 0, 1, -90)
    contentScroll.Position = UDim2.new(0, 0, 0, 90)
    contentScroll.BackgroundTransparency = 1
    contentScroll.ScrollBarThickness = 6
    contentScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    contentScroll.BorderSizePixel = 0
    contentScroll.Parent = mainFrame

    -- Layout para o conteúdo
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 5)
    contentLayout.Parent = contentScroll

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.Parent = contentScroll

    GUI.ScreenGui = screenGui
    GUI.MainFrame = mainFrame
    GUI.ContentScroll = contentScroll
    GUI.TabContainer = tabContainer
    GUI.MinimizeBtn = minimizeBtn

    return GUI
end

-- Função para criar abas
local function CreateTab(name, displayName, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "Tab"
    tabBtn.Size = UDim2.new(0.25, -5, 1, -10)
    tabBtn.Position = UDim2.new(0, 0, 0, 5)
    tabBtn.BackgroundColor3 = currentTab == name and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
    tabBtn.Text = icon .. " " .. displayName
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.TextScaled = true
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = GUI.TabContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tabBtn

    -- Layout das abas
    local layout = GUI.TabContainer:FindFirstChild("UIListLayout")
    if not layout then
        layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 5)
        layout.Parent = GUI.TabContainer

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 5)
        padding.Parent = GUI.TabContainer
    end

    tabBtn.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)

    return tabBtn
end

-- Função para criar botões
local function CreateButton(text, callback, parent)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    button.BorderSizePixel = 0
    button.Parent = parent or GUI.ContentScroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    button.MouseButton1Click:Connect(callback)

    -- Efeito hover
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)

    return button
end

-- Função para criar toggles
local function CreateToggle(text, default, callback, parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    frame.BorderSizePixel = 0
    frame.Parent = parent or GUI.ContentScroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    toggle.Text = default and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextScaled = true
    toggle.Font = Enum.Font.GothamBold
    toggle.BorderSizePixel = 0
    toggle.Parent = frame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggle

    local isOn = default
    toggle.MouseButton1Click:Connect(function()
        isOn = not isOn
        toggle.Text = isOn and "ON" or "OFF"
        toggle.BackgroundColor3 = isOn and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        callback(isOn)
    end)

    return frame, toggle
end

-- Função para criar sliders
local function CreateSlider(text, min, max, default, callback, parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    frame.BorderSizePixel = 0
    frame.Parent = parent or GUI.ContentScroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 15)
    sliderFrame.Position = UDim2.new(0, 10, 0, 28)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = frame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 7)
    sliderCorner.Parent = sliderFrame

    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 1, 0)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -10, 0, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    sliderButton.Text = ""
    sliderButton.BorderSizePixel = 0
    sliderButton.Parent = sliderFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 7)
    buttonCorner.Parent = sliderButton

    local dragging = false
    local currentValue = default

    local function updateSlider(input)
        local relativePos = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(min + (max - min) * relativePos)
        sliderButton.Position = UDim2.new(relativePos, -10, 0, 0)
        label.Text = text .. ": " .. currentValue
        callback(currentValue)
    end

    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    -- Suporte para toque móvel
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input)
        end
    end)

    return frame
end

-- Função para trocar abas
function SwitchTab(tabName)
    currentTab = tabName
    
    -- Limpar conteúdo atual
    for _, child in pairs(GUI.ContentScroll:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    -- Atualizar cores das abas
    for _, tab in pairs(GUI.TabContainer:GetChildren()) do
        if tab:IsA("TextButton") then
            tab.BackgroundColor3 = tab.Name == tabName .. "Tab" and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
        end
    end

    -- Carregar conteúdo da aba
    LoadTabContent(tabName)
end

-- Função para carregar conteúdo das abas
function LoadTabContent(tabName)
    if tabName == "main" then
        CreateButton("🚪 Sair do Jogo", function()
            LocalPlayer:Kick("Você foi desconectado!")
        end)

        CreateButton("🔄 Re-entrar no Servidor", function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)

        CreateToggle("✈️ Fly (Voar)", Settings.fly, function(state)
            Settings.fly = state
            ToggleFly(state)
        end)

        CreateToggle("👁️ ESP (Ver jogadores)", Settings.esp, function(state)
            Settings.esp = state
            ToggleESP(state)
        end)

        CreateToggle("👻 Noclip (Atravessar paredes)", Settings.noclip, function(state)
            Settings.noclip = state
            ToggleNoclip(state)
        end)

        CreateToggle("🛡️ GodMode (Imortal)", Settings.godmode, function(state)
            Settings.godmode = state
            ToggleGodmode(state)
        end)

    elseif tabName == "player" then
        CreateSlider("🏃 Velocidade Extra", 0, 500, Settings.speed, function(value)
            Settings.speed = value
            SetWalkSpeed(value)
        end)

        CreateToggle("📶 Mostrar Ping", Settings.showPing, function(state)
            Settings.showPing = state
            TogglePingDisplay(state)
        end)

    elseif tabName == "combat" then
        CreateToggle("🎯 Aimbot", Settings.aimbot, function(state)
            Settings.aimbot = state
            ToggleAimbot(state)
        end)

        CreateSlider("📏 Raio do Aimbot", 50, 500, 150, function(value)
            if aimbotInstance then
                aimbotInstance.SetRadius(value)
            end
        end)

    elseif tabName == "misc" then
        CreateButton("🔄 Infinite Yield", function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Infinite-yeild-fe-14386"))()
        end)

        CreateButton("🚗 Universal Car Speed", function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Documantation12/Universal-Vehicle-Script/main/Main.lua'))()
        end)

        if game.PlaceId == 4924922222 then
            CreateButton("🎮 Rael-Hub (Brookhaven)", function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Laelmano24/Rael-Hub/main/main.txt"))()
            end)
        end
    end

    -- Atualizar o tamanho do scroll
    GUI.ContentScroll.CanvasSize = UDim2.new(0, 0, 0, GUI.ContentScroll.UIListLayout.AbsoluteContentSize.Y + 20)
end

-- FUNÇÕES DOS CHEATS

-- Fly System
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil

function ToggleFly(enabled)
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end

    if enabled then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Parent = rootPart

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.CFrame = rootPart.CFrame
        bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
        bodyGyro.Parent = rootPart

        humanoid.PlatformStand = true

        flyConnection = RunService.RenderStepped:Connect(function()
            local camera = workspace.CurrentCamera
            local moveDirection = Vector3.new(0, 0, 0)
            
            -- Controles para mobile usando thumbstick virtual (será implementado em versão futura)
            -- Por enquanto, usa WASD para teste em computador
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end

            bodyVelocity.Velocity = moveDirection * 50
            bodyGyro.CFrame = camera.CFrame
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        
        humanoid.PlatformStand = false
    end
end

-- ESP System
local espObjects = {}

function ToggleESP(enabled)
    if enabled then
        CreateESPForAllPlayers()
    else
        ClearESP()
    end
end

function CreateESPForAllPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESPForPlayer(player)
        end
    end
end

function CreateESPForPlayer(player)
    if not player.Character then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "MobileESP"
    highlight.Adornee = player.Character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = player.TeamColor.Color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = player.Character

    espObjects[player] = highlight
end

function ClearESP()
    for player, highlight in pairs(espObjects) do
        if highlight then
            highlight:Destroy()
        end
    end
    espObjects = {}
end

-- Noclip System
local noclipConnection = nil

function ToggleNoclip(enabled)
    if enabled then
        noclipConnection = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- GodMode System
local godmodeConnection = nil
local GOD_HEALTH = 1000000

function ToggleGodmode(enabled)
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if enabled then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        humanoid.MaxHealth = GOD_HEALTH
        humanoid.Health = GOD_HEALTH

        godmodeConnection = RunService.RenderStepped:Connect(function()
            if humanoid.Health < GOD_HEALTH then
                humanoid.Health = GOD_HEALTH
            end
        end)
    else
        if godmodeConnection then
            godmodeConnection:Disconnect()
            godmodeConnection = nil
        end
        
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end
end

-- Speed System
function SetWalkSpeed(speed)
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    humanoid.WalkSpeed = 16 + speed
end

-- Aimbot System (versão simplificada)
local aimbotInstance = nil

function ToggleAimbot(enabled)
    if enabled then
        aimbotInstance = CreateAimbot()
    else
        if aimbotInstance then
            aimbotInstance.Destroy()
            aimbotInstance = nil
        end
    end
end

function CreateAimbot()
    local aimbot = {}
    local connection = nil
    
    function aimbot.Start()
        connection = RunService.RenderStepped:Connect(function()
            local target = GetClosestEnemy()
            if target then
                local camera = workspace.CurrentCamera
                local targetHead = target.Character:FindFirstChild("Head")
                if targetHead then
                    camera.CFrame = CFrame.new(camera.CFrame.Position, targetHead.Position)
                end
            end
        end)
    end
    
    function aimbot.Destroy()
        if connection then
            connection:Disconnect()
        end
    end
    
    aimbot.Start()
    return aimbot
end

function GetClosestEnemy()
    local closest = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.Head.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closest = player
            end
        end
    end
    
    return closest
end

-- Ping Display System
local pingLabel = nil

function TogglePingDisplay(enabled)
    if enabled then
        CreatePingDisplay()
    else
        if pingLabel then
            pingLabel:Destroy()
            pingLabel = nil
        end
    end
end

function CreatePingDisplay()
    pingLabel = Instance.new("TextLabel")
    pingLabel.Size = UDim2.new(0, 150, 0, 30)
    pingLabel.Position = UDim2.new(0, 10, 0, 10)
    pingLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    pingLabel.BackgroundTransparency = 0.5
    pingLabel.Text = "📶 Ping: 0 ms"
    pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    pingLabel.TextScaled = true
    pingLabel.Font = Enum.Font.Gotham
    pingLabel.Parent = GUI.ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = pingLabel

    task.spawn(function()
        while pingLabel do
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            pingLabel.Text = "📶 Ping: " .. ping
            task.wait(1)
        end
    end)
end

-- INICIALIZAÇÃO
local function Initialize()
    -- Criar GUI
    CreateMobileGUI()
    
    -- Criar abas
    CreateTab("main", "Principal", "🏠")
    CreateTab("player", "Jogador", "👤")
    CreateTab("combat", "Combate", "⚔️")
    CreateTab("misc", "Outros", "🔧")
    
    -- Carregar aba inicial
    SwitchTab("main")
    
    -- Configurar botão minimizar
    GUI.MinimizeBtn.MouseButton1Click:Connect(function()
        isGUIVisible = not isGUIVisible
        GUI.MainFrame.Visible = isGUIVisible
        
        if not isGUIVisible then
            -- Criar botão flutuante para reabrir
            local reopenBtn = Instance.new("TextButton")
            reopenBtn.Name = "ReopenBtn"
            reopenBtn.Size = UDim2.new(0, 50, 0, 50)
            reopenBtn.Position = UDim2.new(0, 10, 0.5, -25)
            reopenBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            reopenBtn.Text = "📱"
            reopenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            reopenBtn.TextScaled = true
            reopenBtn.Font = Enum.Font.GothamBold
            reopenBtn.BorderSizePixel = 0
            reopenBtn.Parent = GUI.ScreenGui

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 25)
            corner.Parent = reopenBtn

            reopenBtn.MouseButton1Click:Connect(function()
                isGUIVisible = true
                GUI.MainFrame.Visible = true
                reopenBtn:Destroy()
            end)
        else
            -- Remover botão flutuante se existir
            local reopenBtn = GUI.ScreenGui:FindFirstChild("ReopenBtn")
            if reopenBtn then
                reopenBtn:Destroy()
            end
        end
    end)
    
    -- Eventos de conexão/desconexão de jogadores para ESP
    Players.PlayerAdded:Connect(function(player)
        if Settings.esp then
            player.CharacterAdded:Connect(function()
                task.wait(1)
                CreateESPForPlayer(player)
            end)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        if espObjects[player] then
            espObjects[player]:Destroy()
            espObjects[player] = nil
        end
    end)
    
    -- Recriar ESP quando o jogador spawna
    LocalPlayer.CharacterAdded:Connect(function()
        if Settings.esp then
            task.wait(2)
            CreateESPForAllPlayers()
        end
        
        if Settings.godmode then
            task.wait(1)
            ToggleGodmode(true)
        end
        
        if Settings.speed > 0 then
            task.wait(1)
            SetWalkSpeed(Settings.speed)
        end
        
        if Settings.fly then
            task.wait(1)
            ToggleFly(true)
        end
        
        if Settings.noclip then
            task.wait(1)
            ToggleNoclip(true)
        end
    end)
    
    print("📱 Mobile Cheat Hub carregado com sucesso!")
    print("🔧 Desenvolvido para dispositivos móveis")
    print("⚠️ Use com responsabilidade!")
end

-- Função para detectar se está em dispositivo móvel
local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- Sistema de controles virtuais para mobile (Fly)
local function CreateVirtualControls()
    if not IsMobile() then return end
    
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Name = "VirtualControls"
    controlsFrame.Size = UDim2.new(0, 200, 0, 200)
    controlsFrame.Position = UDim2.new(0, 20, 1, -220)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Visible = false
    controlsFrame.Parent = GUI.ScreenGui
    
    -- Joystick virtual
    local joystickFrame = Instance.new("Frame")
    joystickFrame.Size = UDim2.new(0, 120, 0, 120)
    joystickFrame.Position = UDim2.new(0, 0, 0, 40)
    joystickFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    joystickFrame.BackgroundTransparency = 0.3
    joystickFrame.BorderSizePixel = 0
    joystickFrame.Parent = controlsFrame
    
    local joystickCorner = Instance.new("UICorner")
    joystickCorner.CornerRadius = UDim.new(0.5, 0)
    joystickCorner.Parent = joystickFrame
    
    local joystickButton = Instance.new("TextButton")
    joystickButton.Size = UDim2.new(0, 40, 0, 40)
    joystickButton.Position = UDim2.new(0.5, -20, 0.5, -20)
    joystickButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    joystickButton.Text = ""
    joystickButton.BorderSizePixel = 0
    joystickButton.Parent = joystickFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.5, 0)
    buttonCorner.Parent = joystickButton
    
    -- Botões de subir/descer
    local upButton = Instance.new("TextButton")
    upButton.Size = UDim2.new(0, 60, 0, 30)
    upButton.Position = UDim2.new(1, -70, 0, 0)
    upButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    upButton.Text = "⬆️"
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.TextScaled = true
    upButton.BorderSizePixel = 0
    upButton.Parent = controlsFrame
    
    local downButton = Instance.new("TextButton")
    downButton.Size = UDim2.new(0, 60, 0, 30)
    downButton.Position = UDim2.new(1, -70, 0, 35)
    downButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    downButton.Text = "⬇️"
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.TextScaled = true
    downButton.BorderSizePixel = 0
    downButton.Parent = controlsFrame
    
    -- Arredondar botões
    for _, btn in pairs({upButton, downButton}) do
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn
    end
    
    GUI.VirtualControls = controlsFrame
    GUI.JoystickButton = joystickButton
    GUI.JoystickFrame = joystickFrame
    GUI.UpButton = upButton
    GUI.DownButton = downButton
    
    return controlsFrame
end

-- Sistema de movimento virtual melhorado
local virtualMoveVector = Vector3.new(0, 0, 0)
local isMovingUp = false
local isMovingDown = false

local function SetupVirtualMovement()
    if not GUI.VirtualControls then return end
    
    local joystickButton = GUI.JoystickButton
    local joystickFrame = GUI.JoystickFrame
    local upButton = GUI.UpButton
    local downButton = GUI.DownButton
    
    local isDragging = false
    local originalPosition = joystickButton.Position
    
    -- Sistema de joystick
    joystickButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            joystickButton.Position = originalPosition
            virtualMoveVector = Vector3.new(0, virtualMoveVector.Y, 0)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.Touch then
            local frameCenter = joystickFrame.AbsolutePosition + joystickFrame.AbsoluteSize / 2
            local touchPos = input.Position
            local offset = Vector2.new(touchPos.X - frameCenter.X, touchPos.Y - frameCenter.Y)
            
            local maxDistance = joystickFrame.AbsoluteSize.X / 2 - joystickButton.AbsoluteSize.X / 2
            local distance = math.min(offset.Magnitude, maxDistance)
            local direction = offset.Unit
            
            if offset.Magnitude > 0 then
                local newPos = direction * distance
                joystickButton.Position = UDim2.new(0.5, newPos.X, 0.5, newPos.Y)
                
                local normalizedX = newPos.X / maxDistance
                local normalizedZ = newPos.Y / maxDistance
                
                virtualMoveVector = Vector3.new(normalizedX, virtualMoveVector.Y, normalizedZ)
            end
        end
    end)
    
    -- Botões de subir/descer
    upButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isMovingUp = true
            virtualMoveVector = Vector3.new(virtualMoveVector.X, 1, virtualMoveVector.Z)
        end
    end)
    
    upButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isMovingUp = false
            virtualMoveVector = Vector3.new(virtualMoveVector.X, 0, virtualMoveVector.Z)
        end
    end)
    
    downButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isMovingDown = true
            virtualMoveVector = Vector3.new(virtualMoveVector.X, -1, virtualMoveVector.Z)
        end
    end)
    
    downButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isMovingDown = false
            virtualMoveVector = Vector3.new(virtualMoveVector.X, 0, virtualMoveVector.Z)
        end
    end)
end

-- Atualizar sistema de Fly para mobile
function ToggleFly(enabled)
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end

    if enabled then
        -- Mostrar controles virtuais no mobile
        if GUI.VirtualControls then
            GUI.VirtualControls.Visible = true
        end
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Parent = rootPart

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.CFrame = rootPart.CFrame
        bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
        bodyGyro.Parent = rootPart

        humanoid.PlatformStand = true

        flyConnection = RunService.RenderStepped:Connect(function()
            local camera = workspace.CurrentCamera
            local moveDirection = Vector3.new(0, 0, 0)
            
            if IsMobile() then
                -- Usar controles virtuais
                if virtualMoveVector.Magnitude > 0 then
                    local cameraLook = camera.CFrame.LookVector
                    local cameraRight = camera.CFrame.RightVector
                    
                    moveDirection = (cameraRight * virtualMoveVector.X) + 
                                   (Vector3.new(0, 1, 0) * virtualMoveVector.Y) + 
                                   (cameraLook * -virtualMoveVector.Z)
                end
            else
                -- Controles de teclado para PC
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDirection = moveDirection - Vector3.new(0, 1, 0)
                end
            end

            bodyVelocity.Velocity = moveDirection * 50
            bodyGyro.CFrame = camera.CFrame
        end)
    else
        -- Esconder controles virtuais
        if GUI.VirtualControls then
            GUI.VirtualControls.Visible = false
        end
        
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        
        humanoid.PlatformStand = false
        virtualMoveVector = Vector3.new(0, 0, 0)
    end
end

-- Sistema de notificações
local function CreateNotification(title, message, duration)
    duration = duration or 3
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(0.5, -150, 0, -100)
    notification.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    notification.BorderSizePixel = 0
    notification.Parent = GUI.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0.5, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0.5, -5)
    messageLabel.Position = UDim2.new(0, 10, 0.5, 0)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageLabel.TextScaled = true
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.Parent = notification
    
    -- Animação de entrada
    TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -150, 0, 20)
    }):Play()
    
    -- Animação de saída
    task.spawn(function()
        task.wait(duration)
        TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, -150, 0, -100)
        }):Play()
        task.wait(0.5)
        notification:Destroy()
    end)
end

-- Executar inicialização
task.spawn(function()
    Initialize()
    CreateVirtualControls()
    SetupVirtualMovement()
    
    CreateNotification("Mobile Cheat Hub", "Carregado com sucesso!", 5)
    
    if IsMobile() then
        CreateNotification("Modo Mobile", "Controles virtuais ativados!", 3)
    else
        CreateNotification("Modo Desktop", "Use WASD + Space/Shift para voar", 4)
    end
end)
