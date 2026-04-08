-- XSCRIPT ROblOX UI v4.0 | DEVELOPER EDITION
-- Cara jadiin loadstring: 
-- 1. Upload script ini ke pastebin / github raw
-- 2. loadstring(game:HttpGet("URL_RAW_SCRIPT_ANDAA"))()

-- ========== KONFIGURASI ==========
local Library = {
    Name = "XSCRIPT PREMIUM",
    Theme = {
        Background = Color3.fromRGB(15, 15, 25),
        MainColor = Color3.fromRGB(59, 130, 246),
        Secondary = Color3.fromRGB(30, 30, 45),
        Text = Color3.fromRGB(240, 240, 255),
        Accent = Color3.fromRGB(168, 85, 247)
    }
}

-- ========== SERVICE ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ========== FUNGSI UTAMA ==========
local function MakeDraggable(frame, dragBar)
    local dragging = false
    local dragStart
    local startPos
    
    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ========== UI UTAMA ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XScriptUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Background blur
local Blur = Instance.new("BlurEffect")
Blur.Size = 12
Blur.Parent = game:GetService("Lighting")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 420)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
MainFrame.BackgroundColor3 = Library.Theme.Background
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

-- Stroke
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Library.Theme.MainColor
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.5
UIStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Library.Theme.Secondary
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 16)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = Library.Name
Title.TextColor3 = Library.Theme.Text
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0, 9)
CloseBtn.BackgroundColor3 = Library.Theme.MainColor
CloseBtn.BackgroundTransparency = 0.8
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Library.Theme.Text
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    Blur.Enabled = false
end)

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 48)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- Content Container (untuk animasi tab)
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -20, 1, -120)
ContentContainer.Position = UDim2.new(0, 10, 0, 98)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ClipsDescendants = true
ContentContainer.Parent = MainFrame

-- ========== FUNGSI TAB ANIMASI ==========
local tabs = {}
local activeTab = nil

local function CreateTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 100, 1, 0)
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = "   " .. icon .. "  " .. name
    tabBtn.TextColor3 = Library.Theme.Text
    tabBtn.TextSize = 13
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.Parent = TabContainer
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0.9, 0, 0, 3)
    indicator.Position = UDim2.new(0.05, 0, 1, -3)
    indicator.BackgroundColor3 = Library.Theme.MainColor
    indicator.BackgroundTransparency = 1
    indicator.BorderSizePixel = 0
    indicator.Parent = tabBtn
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabContent.Parent = ContentContainer
    tabContent.Visible = false
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 12)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = tabContent
    
    local function onSelect()
        if activeTab == tabContent then return end
        if activeTab then
            activeTab.Visible = false
            local oldIndicator = activeTab.Parent:FindFirstChildWhichIsA("Frame")
            if oldIndicator then
                TweenService:Create(oldIndicator, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            end
        end
        tabContent.Visible = true
        activeTab = tabContent
        TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end
    
    tabBtn.MouseButton1Click:Connect(onSelect)
    
    return {
        AddButton = function(self, text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 40)
            btn.Position = UDim2.new(0, 10, 0, 0)
            btn.BackgroundColor3 = Library.Theme.Secondary
            btn.BackgroundTransparency = 0.5
            btn.Text = text
            btn.TextColor3 = Library.Theme.Text
            btn.TextSize = 14
            btn.Font = Enum.Font.GothamSemibold
            btn.BorderSizePixel = 0
            btn.Parent = tabContent
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(callback)
            
            local layout = tabContent:FindFirstChildWhichIsA("UIListLayout")
            if layout then layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                tabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
            end) end
            return btn
        end,
        
        AddToggle = function(self, text, default, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -20, 0, 44)
            toggleFrame.Position = UDim2.new(0, 10, 0, 0)
            toggleFrame.BackgroundColor3 = Library.Theme.Secondary
            toggleFrame.BackgroundTransparency = 0.5
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Parent = tabContent
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = toggleFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -60, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Library.Theme.Text
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = toggleFrame
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 40, 0, 24)
            toggleBtn.Position = UDim2.new(1, -52, 0.5, -12)
            toggleBtn.BackgroundColor3 = default and Library.Theme.MainColor or Color3.fromRGB(60, 60, 80)
            toggleBtn.BorderSizePixel = 0
            toggleBtn.Parent = toggleFrame
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = toggleBtn
            
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Size = UDim2.new(0, 18, 0, 18)
            toggleCircle.Position = default and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
            toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleCircle.BorderSizePixel = 0
            toggleCircle.Parent = toggleBtn
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = toggleCircle
            
            local state = default
            callback(state)
            
            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                local targetColor = state and Library.Theme.MainColor or Color3.fromRGB(60, 60, 80)
                local targetPos = state and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
                TweenService:Create(toggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
                TweenService:Create(toggleCircle, TweenInfo.new(0.15), {Position = targetPos}):Play()
                callback(state)
            end)
            
            local layout = tabContent:FindFirstChildWhichIsA("UIListLayout")
            if layout then layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                tabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
            end) end
        end,
        
        AddSlider = function(self, text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -20, 0, 70)
            sliderFrame.Position = UDim2.new(0, 10, 0, 0)
            sliderFrame.BackgroundColor3 = Library.Theme.Secondary
            sliderFrame.BackgroundTransparency = 0.5
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Parent = tabContent
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = sliderFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -20, 0, 20)
            label.Position = UDim2.new(0, 12, 0, 8)
            label.BackgroundTransparency = 1
            label.Text = text .. ": " .. default
            label.TextColor3 = Library.Theme.Text
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = sliderFrame
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 50, 0, 20)
            valueLabel.Position = UDim2.new(1, -62, 0, 8)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(default)
            valueLabel.TextColor3 = Library.Theme.MainColor
            valueLabel.TextSize = 12
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Parent = sliderFrame
            
            local slider = Instance.new("Frame")
            slider.Size = UDim2.new(1, -24, 0, 4)
            slider.Position = UDim2.new(0, 12, 0, 48)
            slider.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            slider.BorderSizePixel = 0
            slider.Parent = sliderFrame
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Library.Theme.MainColor
            fill.BorderSizePixel = 0
            fill.Parent = slider
            
            local knob = Instance.new("TextButton")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
            knob.BackgroundColor3 = Library.Theme.MainColor
            knob.BorderSizePixel = 0
            knob.Text = ""
            knob.Parent = sliderFrame
            
            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = knob
            
            local value = default
            callback(value)
            
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                value = min + (max - min) * pos
                value = math.floor(value)
                fill.Size = UDim2.new(pos, 0, 1, 0)
                knob.Position = UDim2.new(pos, -8, 0.5, -8)
                label.Text = text .. ": " .. value
                valueLabel.Text = tostring(value)
                callback(value)
            end
            
            knob.MouseButton1Down:Connect(function()
                local connection
                connection = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        connection:Disconnect()
                    end
                end)
            end)
            
            local layout = tabContent:FindFirstChildWhichIsA("UIListLayout")
            if layout then layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                tabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
            end) end
        end
    }
end

-- ========== BUAT TAB ==========
local tabAimbot = CreateTab("Aimbot", "🎯")
local tabVisual = CreateTab("Visual", "👁️")
local tabPlayer = CreateTab("Player", "👤")
local tabMisc = CreateTab("Misc", "⚙️")

-- ========== FITUR AIMBOT ==========
tabAimbot:AddToggle("Enable Aimbot", false, function(state)
    print("Aimbot enabled:", state)
    -- Lo bisa tambahin logika exploit disini
end)

tabAimbot:AddSlider("Aimbot FOV", 50, 300, 120, function(value)
    print("FOV:", value)
end)

tabAimbot:AddSlider("Smoothness", 1, 20, 5, function(value)
    print("Smooth:", value)
end)

tabAimbot:AddButton("Set Hitbox (Head)", function()
    print("Hitbox set to Head")
end)

-- ========== FITUR VISUAL ==========
tabVisual:AddToggle("ESP Box", false, function(state)
    print("ESP Box:", state)
end)

tabVisual:AddToggle("ESP Line (Tracers)", false, function(state)
    print("Tracers:", state)
end)

tabVisual:AddToggle("Show Health Bar", true, function(state)
    print("Health Bar:", state)
end)

tabVisual:AddSlider("ESP Transparency", 0, 1, 0.5, function(value)
    print("ESP Alpha:", value)
end)

-- ========== FITUR PLAYER ==========
tabPlayer:AddButton("Walkspeed (Super Run)", function()
    LocalPlayer.Character.Humanoid.WalkSpeed = 50
    print("Walkspeed set to 50")
end)

tabPlayer:AddButton("Jump Power (Super Jump)", function()
    LocalPlayer.Character.Humanoid.JumpPower = 80
    print("JumpPower set to 80")
end)

tabPlayer:AddButton("Reset Speed", function()
    LocalPlayer.Character.Humanoid.WalkSpeed = 16
    LocalPlayer.Character.Humanoid.JumpPower = 50
    print("Speed reset")
end)

tabPlayer:AddToggle("No Clip (Beta)", false, function(state)
    print("No Clip:", state)
end)

-- ========== FITUR MISC ==========
tabMisc:AddButton("Rejoin Game", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

tabMisc:AddButton("Server Hop", function()
    local ts = game:GetService("TeleportService")
    ts:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

tabMisc:AddButton("Infinite Yield (Spy)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- ========== DRAG & OPEN ==========
MakeDraggable(MainFrame, Header)

-- Hotkey (Insert) untuk buka/tutup UI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
        Blur.Enabled = MainFrame.Visible
    end
end)

-- ========== LOADSTRING WRAPPER ==========
--[[ 
CARA JADIIN LOADSTRING:
1. COPY SEMUA SCRIPT INI
2. UPLOAD KE PASTEBIN / GITHUB GIST
3. AMBIL RAW URL
4. EKSEKUSI DENGAN:
   loadstring(game:HttpGet("URL_RAW_ANDA"))()
]]

-- Tampilkan notifikasi
MainFrame.Visible = true
Blur.Enabled = true

-- Pilih tab default
tabAimbot:AddButton("✅ UI Loaded Successfully!", function() end)

print("XSCRIPT UI v4.0 - Developer Edition Loaded!")