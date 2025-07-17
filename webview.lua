-- MineFramework - HTML/CSS/JS para Roblox
-- Sistema completo de renderização web para Roblox

local MineFramework = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Configurações globais
local CONFIG = {
    defaultFont = Enum.Font.Roboto,
    defaultTextSize = 14,
    defaultBackgroundColor = Color3.fromRGB(255, 255, 255),
    defaultTextColor = Color3.fromRGB(0, 0, 0),
    animationSpeed = 0.3
}

-- Mapeamento de elementos HTML para Roblox
local ELEMENT_MAP = {
    ["div"] = "Frame",
    ["button"] = "TextButton",
    ["p"] = "TextLabel",
    ["span"] = "TextLabel",
    ["h1"] = "TextLabel",
    ["h2"] = "TextLabel",
    ["h3"] = "TextLabel",
    ["input"] = "TextBox",
    ["img"] = "ImageLabel",
    ["body"] = "Frame",
    ["main"] = "Frame",
    ["section"] = "Frame",
    ["article"] = "Frame",
    ["header"] = "Frame",
    ["footer"] = "Frame",
    ["nav"] = "Frame"
}

-- Mapeamento de propriedades CSS para Roblox
local CSS_MAP = {
    ["background-color"] = "BackgroundColor3",
    ["color"] = "TextColor3",
    ["font-size"] = "TextSize",
    ["font-family"] = "Font",
    ["text-align"] = "TextXAlignment",
    ["border-radius"] = "CornerRadius",
    ["opacity"] = "BackgroundTransparency",
    ["z-index"] = "ZIndex",
    ["display"] = "Visible",
    ["position"] = "Position",
    ["width"] = "SizeX",
    ["height"] = "SizeY",
    ["left"] = "PositionX",
    ["top"] = "PositionY",
    ["padding"] = "Padding",
    ["margin"] = "Margin"
}

-- Sistema de parsing HTML
local HTMLParser = {}

function HTMLParser:new()
    local parser = {
        tokens = {},
        position = 1,
        current_token = nil
    }
    setmetatable(parser, {__index = HTMLParser})
    return parser
end

function HTMLParser:tokenize(html)
    self.tokens = {}
    local i = 1
    while i <= #html do
        local char = html:sub(i, i)
        if char == "<" then
            local endPos = html:find(">", i)
            if endPos then
                local tag = html:sub(i, endPos)
                table.insert(self.tokens, {type = "tag", value = tag})
                i = endPos + 1
            else
                i = i + 1
            end
        else
            local nextTag = html:find("<", i)
            if nextTag then
                local text = html:sub(i, nextTag - 1):gsub("^%s*(.-)%s*$", "%1")
                if text ~= "" then
                    table.insert(self.tokens, {type = "text", value = text})
                end
                i = nextTag
            else
                local text = html:sub(i):gsub("^%s*(.-)%s*$", "%1")
                if text ~= "" then
                    table.insert(self.tokens, {type = "text", value = text})
                end
                break
            end
        end
    end
    return self.tokens
end

function HTMLParser:parse(html)
    self:tokenize(html)
    self.position = 1
    return self:parseElement()
end

function HTMLParser:parseElement()
    local elements = {}
    
    while self.position <= #self.tokens do
        local token = self.tokens[self.position]
        
        if token.type == "tag" then
            local tag = token.value
            if tag:match("^<%s*/%s*") then
                -- Tag de fechamento
                break
            else
                -- Tag de abertura
                local element = self:parseTag(tag)
                if element then
                    table.insert(elements, element)
                end
            end
        elseif token.type == "text" then
            table.insert(elements, {
                type = "text",
                content = token.value
            })
            self.position = self.position + 1
        else
            self.position = self.position + 1
        end
    end
    
    return elements
end

function HTMLParser:parseTag(tag)
    local tagName = tag:match("^<%s*([%w%-]+)")
    if not tagName then return nil end
    
    local attributes = {}
    local attrPattern = '([%w%-]+)%s*=%s*["\']([^"\']*)["\']'
    for attr, value in tag:gmatch(attrPattern) do
        attributes[attr] = value
    end
    
    local element = {
        type = "element",
        tag = tagName:lower(),
        attributes = attributes,
        children = {}
    }
    
    self.position = self.position + 1
    
    -- Se não é uma tag auto-fechante, procurar filhos
    if not tag:match("/%s*>$") then
        element.children = self:parseElement()
        self.position = self.position + 1 -- Pular tag de fechamento
    end
    
    return element
end

-- Sistema de parsing CSS
local CSSParser = {}

function CSSParser:new()
    local parser = {}
    setmetatable(parser, {__index = CSSParser})
    return parser
end

function CSSParser:parse(css)
    local styles = {}
    
    -- Remover comentários
    css = css:gsub("/%*.*%*/", "")
    
    -- Encontrar todas as regras CSS
    for selector, declarations in css:gmatch("([^{]+)%s*{([^}]*)}") do
        selector = selector:gsub("^%s*(.-)%s*$", "%1")
        
        local rules = {}
        for property, value in declarations:gmatch("([^:]+):%s*([^;]+)") do
            property = property:gsub("^%s*(.-)%s*$", "%1")
            value = value:gsub("^%s*(.-)%s*$", "%1")
            rules[property] = value
        end
        
        styles[selector] = rules
    end
    
    return styles
end

-- Sistema de conversão de valores
local ValueConverter = {}

function ValueConverter:convertColor(value)
    -- Converter cores CSS para Color3
    if value:match("^#") then
        local hex = value:sub(2)
        local r = tonumber(hex:sub(1, 2), 16) / 255
        local g = tonumber(hex:sub(3, 4), 16) / 255
        local b = tonumber(hex:sub(5, 6), 16) / 255
        return Color3.fromRGB(r * 255, g * 255, b * 255)
    elseif value:match("^rgb") then
        local r, g, b = value:match("rgb%((%d+),%s*(%d+),%s*(%d+)%)")
        return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
    else
        -- Cores nomeadas básicas
        local colors = {
            ["red"] = Color3.fromRGB(255, 0, 0),
            ["green"] = Color3.fromRGB(0, 128, 0),
            ["blue"] = Color3.fromRGB(0, 0, 255),
            ["white"] = Color3.fromRGB(255, 255, 255),
            ["black"] = Color3.fromRGB(0, 0, 0),
            ["gray"] = Color3.fromRGB(128, 128, 128),
            ["yellow"] = Color3.fromRGB(255, 255, 0),
            ["orange"] = Color3.fromRGB(255, 165, 0),
            ["purple"] = Color3.fromRGB(128, 0, 128),
            ["pink"] = Color3.fromRGB(255, 192, 203)
        }
        return colors[value:lower()] or CONFIG.defaultBackgroundColor
    end
end

function ValueConverter:convertSize(value, parent)
    if value:match("%%$") then
        local percent = tonumber(value:match("(%d+)%%"))
        return percent / 100
    elseif value:match("px$") then
        local pixels = tonumber(value:match("(%d+)px"))
        return pixels
    elseif value == "auto" then
        return 0
    else
        return tonumber(value) or 0
    end
end

function ValueConverter:convertPosition(value)
    if value:match("%%$") then
        local percent = tonumber(value:match("(%d+)%%"))
        return UDim.new(percent / 100, 0)
    elseif value:match("px$") then
        local pixels = tonumber(value:match("(%d+)px"))
        return UDim.new(0, pixels)
    else
        return UDim.new(0, tonumber(value) or 0)
    end
end

function ValueConverter:convertFont(value)
    local fonts = {
        ["arial"] = Enum.Font.Arial,
        ["roboto"] = Enum.Font.Roboto,
        ["gotham"] = Enum.Font.Gotham,
        ["sourcesans"] = Enum.Font.SourceSans,
        ["oswald"] = Enum.Font.Oswald
    }
    return fonts[value:lower()] or CONFIG.defaultFont
end

-- Sistema de renderização
local Renderer = {}

function Renderer:new(parent)
    local renderer = {
        parent = parent,
        elements = {},
        styles = {},
        converter = ValueConverter
    }
    setmetatable(renderer, {__index = Renderer})
    return renderer
end

function Renderer:setStyles(styles)
    self.styles = styles
end

function Renderer:render(ast)
    for _, element in ipairs(ast) do
        self:renderElement(element, self.parent)
    end
end

function Renderer:renderElement(element, parent)
    if element.type == "text" then
        -- Texto simples - adicionar ao elemento pai se for TextLabel
        if parent:IsA("TextLabel") or parent:IsA("TextButton") then
            parent.Text = element.content
        end
        return
    end
    
    if element.type ~= "element" then return end
    
    local robloxType = ELEMENT_MAP[element.tag] or "Frame"
    local guiObject = Instance.new(robloxType)
    
    -- Aplicar estilos padrão
    self:applyDefaultStyles(guiObject, element.tag)
    
    -- Aplicar estilos CSS
    self:applyStyles(guiObject, element)
    
    -- Aplicar atributos HTML
    self:applyAttributes(guiObject, element.attributes)
    
    -- Configurar layout
    self:setupLayout(guiObject, element)
    
    -- Adicionar ao pai
    guiObject.Parent = parent
    
    -- Renderizar filhos
    for _, child in ipairs(element.children) do
        self:renderElement(child, guiObject)
    end
    
    -- Salvar referência
    table.insert(self.elements, {
        element = element,
        guiObject = guiObject
    })
end

function Renderer:applyDefaultStyles(guiObject, tag)
    if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") then
        guiObject.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        guiObject.TextColor3 = CONFIG.defaultTextColor
        guiObject.Font = CONFIG.defaultFont
        guiObject.TextSize = CONFIG.defaultTextSize
        guiObject.BackgroundTransparency = 1
        
        if tag == "h1" then
            guiObject.TextSize = 32
            guiObject.Font = Enum.Font.GothamBold
        elseif tag == "h2" then
            guiObject.TextSize = 24
            guiObject.Font = Enum.Font.GothamBold
        elseif tag == "h3" then
            guiObject.TextSize = 18
            guiObject.Font = Enum.Font.GothamBold
        elseif tag == "button" then
            guiObject.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
            guiObject.TextColor3 = Color3.fromRGB(255, 255, 255)
            guiObject.BackgroundTransparency = 0
            
            -- Adicionar corner radius
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = guiObject
        end
    end
    
    if guiObject:IsA("Frame") then
        guiObject.BackgroundColor3 = CONFIG.defaultBackgroundColor
        guiObject.BackgroundTransparency = 1
        guiObject.BorderSizePixel = 0
    end
    
    if guiObject:IsA("TextBox") then
        guiObject.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        guiObject.TextColor3 = CONFIG.defaultTextColor
        guiObject.Font = CONFIG.defaultFont
        guiObject.TextSize = CONFIG.defaultTextSize
        guiObject.BorderSizePixel = 1
        guiObject.BorderColor3 = Color3.fromRGB(200, 200, 200)
    end
end

function Renderer:applyStyles(guiObject, element)
    local elementStyles = {}
    
    -- Buscar estilos por seletor
    for selector, styles in pairs(self.styles) do
        if self:matchesSelector(element, selector) then
            for property, value in pairs(styles) do
                elementStyles[property] = value
            end
        end
    end
    
    -- Aplicar estilos inline
    if element.attributes.style then
        for property, value in element.attributes.style:gmatch("([^:]+):%s*([^;]+)") do
            property = property:gsub("^%s*(.-)%s*$", "%1")
            value = value:gsub("^%s*(.-)%s*$", "%1")
            elementStyles[property] = value
        end
    end
    
    -- Converter e aplicar estilos
    self:applyStyleProperties(guiObject, elementStyles)
end

function Renderer:matchesSelector(element, selector)
    selector = selector:gsub("^%s*(.-)%s*$", "%1")
    
    -- Seletor por tag
    if selector == element.tag then
        return true
    end
    
    -- Seletor por classe
    if selector:match("^%.") then
        local className = selector:sub(2)
        local elementClass = element.attributes.class or ""
        return elementClass:find(className) ~= nil
    end
    
    -- Seletor por ID
    if selector:match("^#") then
        local id = selector:sub(2)
        return element.attributes.id == id
    end
    
    return false
end

function Renderer:applyStyleProperties(guiObject, styles)
    for property, value in pairs(styles) do
        if property == "background-color" then
            guiObject.BackgroundColor3 = self.converter:convertColor(value)
            guiObject.BackgroundTransparency = 0
        elseif property == "color" then
            if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") or guiObject:IsA("TextBox") then
                guiObject.TextColor3 = self.converter:convertColor(value)
            end
        elseif property == "font-size" then
            if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") or guiObject:IsA("TextBox") then
                guiObject.TextSize = tonumber(value:match("(%d+)")) or CONFIG.defaultTextSize
            end
        elseif property == "font-family" then
            if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") or guiObject:IsA("TextBox") then
                guiObject.Font = self.converter:convertFont(value)
            end
        elseif property == "width" then
            local size = guiObject.Size
            local width = self.converter:convertSize(value)
            if value:match("%%$") then
                guiObject.Size = UDim2.new(width, 0, size.Y.Scale, size.Y.Offset)
            else
                guiObject.Size = UDim2.new(0, width, size.Y.Scale, size.Y.Offset)
            end
        elseif property == "height" then
            local size = guiObject.Size
            local height = self.converter:convertSize(value)
            if value:match("%%$") then
                guiObject.Size = UDim2.new(size.X.Scale, size.X.Offset, height, 0)
            else
                guiObject.Size = UDim2.new(size.X.Scale, size.X.Offset, 0, height)
            end
        elseif property == "opacity" then
            guiObject.BackgroundTransparency = 1 - tonumber(value)
        elseif property == "border-radius" then
            local radius = tonumber(value:match("(%d+)")) or 0
            local corner = guiObject:FindFirstChild("UICorner")
            if not corner then
                corner = Instance.new("UICorner")
                corner.Parent = guiObject
            end
            corner.CornerRadius = UDim.new(0, radius)
        elseif property == "text-align" then
            if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") then
                if value == "center" then
                    guiObject.TextXAlignment = Enum.TextXAlignment.Center
                elseif value == "right" then
                    guiObject.TextXAlignment = Enum.TextXAlignment.Right
                else
                    guiObject.TextXAlignment = Enum.TextXAlignment.Left
                end
            end
        elseif property == "display" then
            guiObject.Visible = value ~= "none"
        elseif property == "position" then
            if value == "absolute" then
                -- Implementar posicionamento absoluto
                guiObject.Position = UDim2.new(0, 0, 0, 0)
            end
        end
    end
end

function Renderer:applyAttributes(guiObject, attributes)
    for attr, value in pairs(attributes) do
        if attr == "id" then
            guiObject.Name = value
        elseif attr == "onclick" then
            if guiObject:IsA("TextButton") then
                guiObject.MouseButton1Click:Connect(function()
                    self:executeJavaScript(value)
                end)
            end
        elseif attr == "placeholder" then
            if guiObject:IsA("TextBox") then
                guiObject.PlaceholderText = value
            end
        elseif attr == "src" then
            if guiObject:IsA("ImageLabel") then
                guiObject.Image = value
            end
        elseif attr == "alt" then
            if guiObject:IsA("ImageLabel") then
                guiObject.Name = value
            end
        end
    end
end

function Renderer:setupLayout(guiObject, element)
    -- Configurar layout automático
    if #element.children > 0 then
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 5)
        layout.Parent = guiObject
        
        -- Adicionar padding
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 5)
        padding.PaddingBottom = UDim.new(0, 5)
        padding.PaddingLeft = UDim.new(0, 5)
        padding.PaddingRight = UDim.new(0, 5)
        padding.Parent = guiObject
    end
end

-- Sistema de execução JavaScript simplificado
function Renderer:executeJavaScript(jsCode)
    -- Implementação básica de JavaScript
    jsCode = jsCode:gsub("alert%(", "print(")
    jsCode = jsCode:gsub("console%.log%(", "print(")
    
    -- Executar código Lua convertido
    local success, result = pcall(function()
        local func = loadstring(jsCode)
        if func then
            func()
        end
    end)
    
    if not success then
        print("Erro na execução do JavaScript:", result)
    end
end

-- Sistema principal do MineFramework
MineFramework.__index = MineFramework

function MineFramework:new(parent)
    local framework = {}
    setmetatable(framework, MineFramework)
    
    framework.parent = parent or game.Players.LocalPlayer.PlayerGui
    framework.htmlParser = HTMLParser:new()
    framework.cssParser = CSSParser:new()
    framework.renderer = Renderer:new(framework.parent)
    framework.document = nil
    
    return framework
end

function MineFramework:loadFromString(htmlContent, cssContent)
    -- Criar container principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MineFramework"
    screenGui.Parent = self.parent
    
    -- Parsear HTML
    local htmlAst = self.htmlParser:parse(htmlContent or "")
    
    -- Parsear CSS
    local styles = {}
    if cssContent then
        styles = self.cssParser:parse(cssContent)
    end
    
    -- Configurar renderer
    self.renderer.parent = screenGui
    self.renderer:setStyles(styles)
    
    -- Renderizar
    self.renderer:render(htmlAst)
    
    return screenGui
end

function MineFramework:load(html, css, js)
    return self:loadFromString(html, css)
end

-- Função de conveniência para uso rápido
function MineFramework.create(parent)
    return MineFramework:new(parent)
end

-- Exemplo de uso
function MineFramework:example()
    local html = [[
        <div class="container">
            <h1>Bem-vindo ao MineFramework</h1>
            <p>Este é um exemplo de HTML renderizado no Roblox!</p>
            <button onclick="print('Botão clicado!')">Clique em mim</button>
            <div class="card">
                <h2>Card de Exemplo</h2>
                <p>Este é um card com estilo CSS.</p>
            </div>
        </div>
    ]]
    
    local css = [[
        .container {
            background-color: #f0f0f0;
            padding: 20px;
        }
        
        h1 {
            color: #333;
            text-align: center;
        }
        
        .card {
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            margin: 10px;
        }
        
        button {
            background-color: #007bff;
            color: white;
            border-radius: 4px;
            padding: 10px;
        }
    ]]
    
    return self:loadFromString(html, css)
end

-- Função para executar automaticamente
function MineFramework.runExample()
    local framework = MineFramework:new()
    print("Framework criado:", framework)
    framework:example()
    print("Exemplo executado com sucesso!")
end

return MineFramework
