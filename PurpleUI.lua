-- SolisHub UI Library
-- Modern Purple-themed Roblox GUI Library
-- Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/ui-lib/main.lua"))()

local SolisUI = {}
SolisUI.__index = SolisUI

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Theme Configuration
local Theme = {
    Background = Color3.fromRGB(25, 25, 35),
    Secondary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(138, 43, 226),
    AccentHover = Color3.fromRGB(148, 53, 236),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(55, 55, 65),
    Success = Color3.fromRGB(46, 204, 113),
    Warning = Color3.fromRGB(241, 196, 15),
    Error = Color3.fromRGB(231, 76, 60)
}

-- Utility Functions
local function CreateTween(object, properties, duration, easingStyle, easingDirection)
    duration = duration or 0.3
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(object, TweenInfo.new(duration, easingStyle, easingDirection), properties)
    tween:Play()
    return tween
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

-- Main UI Class
function SolisUI.new(title)
    local self = setmetatable({}, SolisUI)
    
    self.Title = title or "SolisHub"
    self.Tabs = {}
    self.CurrentTab = nil
    
    self:CreateMainFrame()
    self:CreateTitleBar()
    self:CreateTabContainer()
    self:CreateContentContainer()
    
    return self
end

function SolisUI:CreateMainFrame()
    -- Destroy existing GUI
    if PlayerGui:FindFirstChild("SolisUI") then
        PlayerGui.SolisUI:Destroy()
    end
    
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "SolisUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = PlayerGui
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 600, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    self.MainFrame.BackgroundColor3 = Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    CreateCorner(self.MainFrame, 12)
    CreateStroke(self.MainFrame, Theme.Border, 2)
    
    -- Make draggable
    self:MakeDraggable(self.MainFrame)
end

function SolisUI:CreateTitleBar()
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = Theme.Secondary
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    CreateCorner(self.TitleBar, 12)
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "← " .. self.Title
    titleText.TextColor3 = Theme.Text
    titleText.TextSize = 16
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = self.TitleBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 5)
    closeButton.BackgroundColor3 = Theme.Error
    closeButton.Text = "×"
    closeButton.TextColor3 = Theme.Text
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = self.TitleBar
    
    CreateCorner(closeButton, 6)
    
    closeButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Hover effect for close button
    closeButton.MouseEnter:Connect(function()
        CreateTween(closeButton, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)})
    end)
    
    closeButton.MouseLeave:Connect(function()
        CreateTween(closeButton, {BackgroundColor3 = Theme.Error})
    end)
end

function SolisUI:CreateTabContainer()
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(0, 150, 1, -50)
    self.TabContainer.Position = UDim2.new(0, 10, 0, 50)
    self.TabContainer.BackgroundColor3 = Theme.Secondary
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.MainFrame
    
    CreateCorner(self.TabContainer, 8)
    
    -- Tab List Layout
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.Parent = self.TabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.PaddingLeft = UDim.new(0, 10)
    tabPadding.PaddingRight = UDim.new(0, 10)
    tabPadding.Parent = self.TabContainer
end

function SolisUI:CreateContentContainer()
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -180, 1, -50)
    self.ContentContainer.Position = UDim2.new(0, 170, 0, 50)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.Parent = self.MainFrame
end

function SolisUI:CreateTab(name)
    local tab = {
        Name = name,
        Elements = {},
        Frame = nil,
        Button = nil
    }
    
    -- Tab Button
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = name .. "Tab"
    tab.Button.Size = UDim2.new(1, 0, 0, 35)
    tab.Button.BackgroundColor3 = Theme.Background
    tab.Button.Text = name
    tab.Button.TextColor3 = Theme.TextSecondary
    tab.Button.TextSize = 14
    tab.Button.Font = Enum.Font.Gotham
    tab.Button.BorderSizePixel = 0
    tab.Button.Parent = self.TabContainer
    
    CreateCorner(tab.Button, 6)
    
    -- Tab Content Frame
    tab.Frame = Instance.new("ScrollingFrame")
    tab.Frame.Name = name .. "Content"
    tab.Frame.Size = UDim2.new(1, 0, 1, 0)
    tab.Frame.Position = UDim2.new(0, 0, 0, 0)
    tab.Frame.BackgroundTransparency = 1
    tab.Frame.BorderSizePixel = 0
    tab.Frame.ScrollBarThickness = 6
    tab.Frame.ScrollBarImageColor3 = Theme.Accent
    tab.Frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Frame.Visible = false
    tab.Frame.Parent = self.ContentContainer
    
    -- Content Layout
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = tab.Frame
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    contentPadding.Parent = tab.Frame
    
    -- Auto-resize canvas
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Frame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Tab Button Click
    tab.Button.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)
    
    -- Hover effects
    tab.Button.MouseEnter:Connect(function()
        if self.CurrentTab ~= name then
            CreateTween(tab.Button, {BackgroundColor3 = Theme.Border})
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if self.CurrentTab ~= name then
            CreateTween(tab.Button, {BackgroundColor3 = Theme.Background})
        end
    end)
    
    self.Tabs[name] = tab
    
    -- Auto-select first tab
    if not self.CurrentTab then
        self:SwitchTab(name)
    end
    
    return tab
end

function SolisUI:SwitchTab(name)
    if not self.Tabs[name] then return end
    
    -- Hide current tab
    if self.CurrentTab and self.Tabs[self.CurrentTab] then
        self.Tabs[self.CurrentTab].Frame.Visible = false
        CreateTween(self.Tabs[self.CurrentTab].Button, {
            BackgroundColor3 = Theme.Background,
            TextColor3 = Theme.TextSecondary
        })
    end
    
    -- Show new tab
    self.CurrentTab = name
    self.Tabs[name].Frame.Visible = true
    CreateTween(self.Tabs[name].Button, {
        BackgroundColor3 = Theme.Accent,
        TextColor3 = Theme.Text
    })
end

-- UI Elements
function SolisUI:CreateSection(tab, title)
    if not self.Tabs[tab] then return end
    
    local section = Instance.new("Frame")
    section.Name = title .. "Section"
    section.Size = UDim2.new(1, 0, 0, 40)
    section.BackgroundColor3 = Theme.Secondary
    section.BorderSizePixel = 0
    section.Parent = self.Tabs[tab].Frame
    
    CreateCorner(section, 8)
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "SectionTitle"
    sectionTitle.Size = UDim2.new(1, -20, 1, 0)
    sectionTitle.Position = UDim2.new(0, 15, 0, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title
    sectionTitle.TextColor3 = Theme.Text
    sectionTitle.TextSize = 16
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.Parent = section
    
    return section
end

function SolisUI:CreateToggle(tab, text, default, callback)
    if not self.Tabs[tab] then return end
    
    local toggle = Instance.new("Frame")
    toggle.Name = text .. "Toggle"
    toggle.Size = UDim2.new(1, 0, 0, 40)
    toggle.BackgroundColor3 = Theme.Secondary
    toggle.BorderSizePixel = 0
    toggle.Parent = self.Tabs[tab].Frame
    
    CreateCorner(toggle, 8)
    
    local toggleText = Instance.new("TextLabel")
    toggleText.Name = "ToggleText"
    toggleText.Size = UDim2.new(1, -80, 1, 0)
    toggleText.Position = UDim2.new(0, 15, 0, 0)
    toggleText.BackgroundTransparency = 1
    toggleText.Text = text
    toggleText.TextColor3 = Theme.Text
    toggleText.TextSize = 14
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.Font = Enum.Font.Gotham
    toggleText.Parent = toggle
    
    -- Toggle Switch
    local toggleSwitch = Instance.new("Frame")
    toggleSwitch.Name = "ToggleSwitch"
    toggleSwitch.Size = UDim2.new(0, 50, 0, 25)
    toggleSwitch.Position = UDim2.new(1, -65, 0.5, -12.5)
    toggleSwitch.BackgroundColor3 = default and Theme.Accent or Theme.Border
    toggleSwitch.BorderSizePixel = 0
    toggleSwitch.Parent = toggle
    
    CreateCorner(toggleSwitch, 12)
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 21, 0, 21)
    toggleButton.Position = default and UDim2.new(0, 27, 0, 2) or UDim2.new(0, 2, 0, 2)
    toggleButton.BackgroundColor3 = Theme.Text
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleSwitch
    
    CreateCorner(toggleButton, 10)
    
    local isToggled = default or false
    
    local function updateToggle()
        CreateTween(toggleSwitch, {BackgroundColor3 = isToggled and Theme.Accent or Theme.Border})
        CreateTween(toggleButton, {Position = isToggled and UDim2.new(0, 27, 0, 2) or UDim2.new(0, 2, 0, 2)})
        
        if callback then
            callback(isToggled)
        end
    end
    
    local toggleClickDetector = Instance.new("TextButton")
    toggleClickDetector.Size = UDim2.new(1, 0, 1, 0)
    toggleClickDetector.BackgroundTransparency = 1
    toggleClickDetector.Text = ""
    toggleClickDetector.Parent = toggle
    
    toggleClickDetector.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateToggle()
    end)
    
    return {
        Frame = toggle,
        SetValue = function(value)
            isToggled = value
            updateToggle()
        end,
        GetValue = function()
            return isToggled
        end
    }
end

function SolisUI:CreateButton(tab, text, callback)
    if not self.Tabs[tab] then return end
    
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Theme.Accent
    button.Text = text
    button.TextColor3 = Theme.Text
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.Parent = self.Tabs[tab].Frame
    
    CreateCorner(button, 8)
    
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    button.MouseEnter:Connect(function()
        CreateTween(button, {BackgroundColor3 = Theme.AccentHover})
    end)
    
    button.MouseLeave:Connect(function()
        CreateTween(button, {BackgroundColor3 = Theme.Accent})
    end)
    
    return button
end

function SolisUI:CreateDropdown(tab, text, options, default, callback)
    if not self.Tabs[tab] then return end
    
    local dropdown = Instance.new("Frame")
    dropdown.Name = text .. "Dropdown"
    dropdown.Size = UDim2.new(1, 0, 0, 40)
    dropdown.BackgroundColor3 = Theme.Secondary
    dropdown.BorderSizePixel = 0
    dropdown.Parent = self.Tabs[tab].Frame
    
    CreateCorner(dropdown, 8)
    
    local dropdownText = Instance.new("TextLabel")
    dropdownText.Name = "DropdownText"
    dropdownText.Size = UDim2.new(0.5, -10, 1, 0)
    dropdownText.Position = UDim2.new(0, 15, 0, 0)
    dropdownText.BackgroundTransparency = 1
    dropdownText.Text = text
    dropdownText.TextColor3 = Theme.Text
    dropdownText.TextSize = 14
    dropdownText.TextXAlignment = Enum.TextXAlignment.Left
    dropdownText.Font = Enum.Font.Gotham
    dropdownText.Parent = dropdown
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(0.5, -15, 0, 30)
    dropdownButton.Position = UDim2.new(0.5, 0, 0, 5)
    dropdownButton.BackgroundColor3 = Theme.Background
    dropdownButton.Text = default or options[1] or "Select"
    dropdownButton.TextColor3 = Theme.Text
    dropdownButton.TextSize = 12
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Parent = dropdown
    
    CreateCorner(dropdownButton, 6)
    
    local currentValue = default or options[1]
    
    dropdownButton.MouseButton1Click:Connect(function()
        -- Create dropdown menu (simplified version)
        if callback then
            callback(currentValue)
        end
    end)
    
    return {
        Frame = dropdown,
        SetValue = function(value)
            currentValue = value
            dropdownButton.Text = value
        end,
        GetValue = function()
            return currentValue
        end
    }
end

function SolisUI:CreateSlider(tab, text, min, max, default, callback)
    if not self.Tabs[tab] then return end
    
    local slider = Instance.new("Frame")
    slider.Name = text .. "Slider"
    slider.Size = UDim2.new(1, 0, 0, 60)
    slider.BackgroundColor3 = Theme.Secondary
    slider.BorderSizePixel = 0
    slider.Parent = self.Tabs[tab].Frame
    
    CreateCorner(slider, 8)
    
    local sliderText = Instance.new("TextLabel")
    sliderText.Name = "SliderText"
    sliderText.Size = UDim2.new(1, -20, 0, 25)
    sliderText.Position = UDim2.new(0, 15, 0, 5)
    sliderText.BackgroundTransparency = 1
    sliderText.Text = text .. ": " .. (default or min)
    sliderText.TextColor3 = Theme.Text
    sliderText.TextSize = 14
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    sliderText.Font = Enum.Font.Gotham
    sliderText.Parent = slider
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "SliderTrack"
    sliderTrack.Size = UDim2.new(1, -30, 0, 6)
    sliderTrack.Position = UDim2.new(0, 15, 0, 35)
    sliderTrack.BackgroundColor3 = Theme.Border
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = slider
    
    CreateCorner(sliderTrack, 3)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    CreateCorner(sliderFill, 3)
    
    local sliderHandle = Instance.new("Frame")
    sliderHandle.Name = "SliderHandle"
    sliderHandle.Size = UDim2.new(0, 16, 0, 16)
    sliderHandle.Position = UDim2.new(0, -8, 0, -5)
    sliderHandle.BackgroundColor3 = Theme.Text
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Parent = sliderTrack
    
    CreateCorner(sliderHandle, 8)
    
    local currentValue = default or min
    local dragging = false
    
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        currentValue = value
        
        local percentage = (value - min) / (max - min)
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderHandle.Position = UDim2.new(percentage, -8, 0, -5)
        sliderText.Text = text .. ": " .. math.floor(value)
        
        if callback then
            callback(value)
        end
    end
    
    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local trackPos = sliderTrack.AbsolutePosition.X
            local trackSize = sliderTrack.AbsoluteSize.X
            local percentage = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
            local value = min + (max - min) * percentage
            updateSlider(value)
        end
    end)
    
    updateSlider(currentValue)
    
    return {
        Frame = slider,
        SetValue = updateSlider,
        GetValue = function()
            return currentValue
        end
    }
end

function SolisUI:MakeDraggable(frame)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function SolisUI:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- Example Usage
local function CreateExampleUI()
    local ui = SolisUI.new("SolisHub Arise Crossover")
    
    -- Main Tab
    local mainTab = ui:CreateTab("Main")
    ui:CreateSection("Main", "Main")
    ui:CreateToggle("Main", "Anti Fling Mode", false, function(value)
        print("Anti Fling Mode:", value)
    end)
    ui:CreateSlider("Main", "Fly Speed", 1, 100, 16, function(value)
        print("Fly Speed:", value)
    end)
    ui:CreateToggle("Main", "Noclip", false, function(value)
        print("Noclip:", value)
    end)
    
    ui:CreateSection("Main", "Teleports")
    ui:CreateDropdown("Main", "World", {"World 1", "World 2", "World 3", "World 4", "World 5"}, "World 5", function(value)
        print("Selected World:", value)
    end)
    ui:CreateButton("Main", "Teleport To World", function()
        print("Teleporting to world...")
    end)
    
    ui:CreateSection("Main", "Player Cheats")
    ui:CreateToggle("Main", "WalkSpeed Toggle", false, function(value)
        print("WalkSpeed Toggle:", value)
    end)
    ui:CreateToggle("Main", "JumpPower Toggle", false, function(value)
        print("JumpPower Toggle:", value)
    end)
    
    ui:CreateSection("Main", "Anti Afk")
    ui:CreateButton("Main", "Reset Character", function()
        if Player.Character then
            Player.Character:BreakJoints()
        end
    end)
    ui:CreateButton("Main", "Rejoin", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end)
    
    -- Settings Tab
    local settingsTab = ui:CreateTab("Settings")
    ui:CreateSection("Settings", "UI Settings")
    ui:CreateToggle("Settings", "Auto Save Config", true, function(value)
        print("Auto Save Config:", value)
    end)
    ui:CreateSlider("Settings", "UI Scale", 0.5, 2, 1, function(value)
        print("UI Scale:", value)
    end)
    ui:CreateButton("Settings", "Reset to Defaults", function()
        print("Resetting to defaults...")
    end)
    
    return ui
end

-- Initialize the UI
SolisUI.Create = CreateExampleUI

return SolisUI
