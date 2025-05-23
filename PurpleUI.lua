-- Modern Purple UI Library for Roblox
-- Load with: loadstring(game:HttpGet("YOUR_GITHUB_RAW_URL"))()

local UILibrary = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Theme Configuration
local Theme = {
    Primary = Color3.fromRGB(138, 43, 226), -- Blue Violet
    Secondary = Color3.fromRGB(75, 0, 130), -- Indigo
    Accent = Color3.fromRGB(186, 85, 211), -- Medium Orchid
    Background = Color3.fromRGB(25, 25, 35), -- Dark Background
    Surface = Color3.fromRGB(35, 35, 50), -- Surface
    Text = Color3.fromRGB(255, 255, 255), -- White Text
    TextSecondary = Color3.fromRGB(200, 200, 220), -- Light Gray
    Success = Color3.fromRGB(76, 175, 80), -- Green
    Warning = Color3.fromRGB(255, 193, 7), -- Amber
    Error = Color3.fromRGB(244, 67, 54), -- Red
    Border = Color3.fromRGB(60, 60, 80), -- Border Color
}

-- Animation Presets
local Animations = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

-- Utility Functions
local function CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    return corner
end

local function CreateStroke(color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    return stroke
end

local function CreateGradient(colors, rotation)
    local gradient = Instance.new("UIGradient")
    local colorSequence = {}
    
    for i, color in ipairs(colors) do
        table.insert(colorSequence, ColorSequenceKeypoint.new((i-1)/(#colors-1), color))
    end
    
    gradient.Color = ColorSequence.new(colorSequence)
    gradient.Rotation = rotation or 0
    return gradient
end

local function CreateShadow(parent, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = parent
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.8
    shadow.Size = UDim2.new(1, size or 10, 1, size or 10)
    shadow.Position = UDim2.new(0, (size or 10)/2, 0, (size or 10)/2)
    shadow.ZIndex = parent.ZIndex - 1
    CreateCorner(8).Parent = shadow
    return shadow
end

local function AnimateHover(element, hoverColor, normalColor)
    local connection1, connection2
    
    connection1 = element.MouseEnter:Connect(function()
        TweenService:Create(element, Animations.Fast, {BackgroundColor3 = hoverColor}):Play()
    end)
    
    connection2 = element.MouseLeave:Connect(function()
        TweenService:Create(element, Animations.Fast, {BackgroundColor3 = normalColor}):Play()
    end)
    
    return {connection1, connection2}
end

-- Main Window Class
function UILibrary:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "UI Library"
    local windowSize = config.Size or UDim2.new(0, 500, 0, 400)
    
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernUILibrary"
    screenGui.Parent = PlayerGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.Size = windowSize
    mainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    mainFrame.ClipsDescendants = true
    CreateCorner(12).Parent = mainFrame
    CreateStroke(Theme.Border, 2).Parent = mainFrame
    CreateShadow(mainFrame, 20, 0.7)
    
    -- Gradient Background
    local bgGradient = CreateGradient({Theme.Background, Theme.Surface}, 45)
    bgGradient.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = mainFrame
    titleBar.BackgroundColor3 = Theme.Primary
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    CreateCorner(12).Parent = titleBar
    
    local titleGradient = CreateGradient({Theme.Primary, Theme.Secondary}, 90)
    titleGradient.Parent = titleBar
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Parent = titleBar
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.Text = windowTitle
    titleText.TextColor3 = Theme.Text
    titleText.TextSize = 16
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = titleBar
    closeButton.BackgroundColor3 = Theme.Error
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -35, 0.5, -12.5)
    closeButton.Text = "×"
    closeButton.TextColor3 = Theme.Text
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    CreateCorner(6).Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        TweenService:Create(mainFrame, Animations.Medium, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        wait(0.3)
        screenGui:Destroy()
    end)
    
    AnimateHover(closeButton, Color3.fromRGB(255, 100, 100), Theme.Error)
    
    -- Minimize Button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Parent = titleBar
    minimizeButton.BackgroundColor3 = Theme.Warning
    minimizeButton.Size = UDim2.new(0, 25, 0, 25)
    minimizeButton.Position = UDim2.new(1, -65, 0.5, -12.5)
    minimizeButton.Text = "−"
    minimizeButton.TextColor3 = Theme.Text
    minimizeButton.TextSize = 18
    minimizeButton.Font = Enum.Font.GothamBold
    CreateCorner(6).Parent = minimizeButton
    
    local isMinimized = false
    local originalSize = windowSize
    
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.new(0, originalSize.X.Offset, 0, 40) or originalSize
        TweenService:Create(mainFrame, Animations.Medium, {Size = targetSize}):Play()
    end)
    
    AnimateHover(minimizeButton, Color3.fromRGB(255, 220, 50), Theme.Warning)
    
    -- Content Area
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Parent = mainFrame
    contentFrame.BackgroundTransparency = 1
    contentFrame.Size = UDim2.new(1, -20, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.ScrollBarThickness = 6
    contentFrame.ScrollBarImageColor3 = Theme.Primary
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    -- Layout for content
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = contentFrame
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    
    -- Dragging functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Window object
    local Window = {
        Frame = mainFrame,
        Content = contentFrame,
        ScreenGui = screenGui
    }
    
    -- Add Button Method
    function Window:AddButton(config)
        config = config or {}
        local buttonText = config.Text or "Button"
        local callback = config.Callback or function() end
        
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Parent = contentFrame
        button.BackgroundColor3 = Theme.Primary
        button.Size = UDim2.new(1, -20, 0, 35)
        button.Text = buttonText
        button.TextColor3 = Theme.Text
        button.TextSize = 14
        button.Font = Enum.Font.Gotham
        CreateCorner(8).Parent = button
        
        local buttonGradient = CreateGradient({Theme.Primary, Theme.Secondary}, 45)
        buttonGradient.Parent = button
        
        button.MouseButton1Click:Connect(function()
            -- Click animation
            TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, -25, 0, 32)}):Play()
            wait(0.1)
            TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, -20, 0, 35)}):Play()
            callback()
        end)
        
        AnimateHover(button, Theme.Accent, Theme.Primary)
        
        return button
    end
    
    -- Add Toggle Method
    function Window:AddToggle(config)
        config = config or {}
        local toggleText = config.Text or "Toggle"
        local defaultValue = config.Default or false
        local callback = config.Callback or function() end
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "ToggleFrame"
        toggleFrame.Parent = contentFrame
        toggleFrame.BackgroundColor3 = Theme.Surface
        toggleFrame.Size = UDim2.new(1, -20, 0, 40)
        CreateCorner(8).Parent = toggleFrame
        CreateStroke(Theme.Border).Parent = toggleFrame
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Name = "ToggleLabel"
        toggleLabel.Parent = toggleFrame
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Size = UDim2.new(1, -60, 1, 0)
        toggleLabel.Position = UDim2.new(0, 15, 0, 0)
        toggleLabel.Text = toggleText
        toggleLabel.TextColor3 = Theme.Text
        toggleLabel.TextSize = 14
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Font = Enum.Font.Gotham
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Name = "ToggleButton"
        toggleButton.Parent = toggleFrame
        toggleButton.BackgroundColor3 = defaultValue and Theme.Primary or Theme.Border
        toggleButton.Size = UDim2.new(0, 40, 0, 20)
        toggleButton.Position = UDim2.new(1, -50, 0.5, -10)
        toggleButton.Text = ""
        CreateCorner(10).Parent = toggleButton
        
        local toggleIndicator = Instance.new("Frame")
        toggleIndicator.Name = "ToggleIndicator"
        toggleIndicator.Parent = toggleButton
        toggleIndicator.BackgroundColor3 = Theme.Text
        toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
        toggleIndicator.Position = defaultValue and UDim2.new(0, 22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        CreateCorner(8).Parent = toggleIndicator
        
        local isToggled = defaultValue
        
        toggleButton.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            
            local buttonColor = isToggled and Theme.Primary or Theme.Border
            local indicatorPos = isToggled and UDim2.new(0, 22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            
            TweenService:Create(toggleButton, Animations.Fast, {BackgroundColor3 = buttonColor}):Play()
            TweenService:Create(toggleIndicator, Animations.Fast, {Position = indicatorPos}):Play()
            
            callback(isToggled)
        end)
        
        return toggleFrame
    end
    
    -- Add Slider Method
    function Window:AddSlider(config)
        config = config or {}
        local sliderText = config.Text or "Slider"
        local minValue = config.Min or 0
        local maxValue = config.Max or 100
        local defaultValue = config.Default or 50
        local callback = config.Callback or function() end
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "SliderFrame"
        sliderFrame.Parent = contentFrame
        sliderFrame.BackgroundColor3 = Theme.Surface
        sliderFrame.Size = UDim2.new(1, -20, 0, 50)
        CreateCorner(8).Parent = sliderFrame
        CreateStroke(Theme.Border).Parent = sliderFrame
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Name = "SliderLabel"
        sliderLabel.Parent = sliderFrame
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Size = UDim2.new(1, -20, 0, 20)
        sliderLabel.Position = UDim2.new(0, 10, 0, 5)
        sliderLabel.Text = sliderText
        sliderLabel.TextColor3 = Theme.Text
        sliderLabel.TextSize = 14
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Font = Enum.Font.Gotham
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "ValueLabel"
        valueLabel.Parent = sliderFrame
        valueLabel.BackgroundTransparency = 1
        valueLabel.Size = UDim2.new(0, 50, 0, 20)
        valueLabel.Position = UDim2.new(1, -60, 0, 5)
        valueLabel.Text = tostring(defaultValue)
        valueLabel.TextColor3 = Theme.Primary
        valueLabel.TextSize = 14
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Font = Enum.Font.GothamBold
        
        local sliderTrack = Instance.new("Frame")
        sliderTrack.Name = "SliderTrack"
        sliderTrack.Parent = sliderFrame
        sliderTrack.BackgroundColor3 = Theme.Border
        sliderTrack.Size = UDim2.new(1, -20, 0, 4)
        sliderTrack.Position = UDim2.new(0, 10, 1, -15)
        CreateCorner(2).Parent = sliderTrack
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Name = "SliderFill"
        sliderFill.Parent = sliderTrack
        sliderFill.BackgroundColor3 = Theme.Primary
        sliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
        sliderFill.Position = UDim2.new(0, 0, 0, 0)
        CreateCorner(2).Parent = sliderFill
        
        local sliderHandle = Instance.new("Frame")
        sliderHandle.Name = "SliderHandle"
        sliderHandle.Parent = sliderTrack
        sliderHandle.BackgroundColor3 = Theme.Text
        sliderHandle.Size = UDim2.new(0, 12, 0, 12)
        sliderHandle.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -6, 0.5, -6)
        CreateCorner(6).Parent = sliderHandle
        
        local dragging = false
        local currentValue = defaultValue
        
        sliderTrack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativePos = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                currentValue = math.floor(minValue + (maxValue - minValue) * relativePos)
                
                valueLabel.Text = tostring(currentValue)
                sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                sliderHandle.Position = UDim2.new(relativePos, -6, 0.5, -6)
                
                callback(currentValue)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        return sliderFrame
    end
    
    -- Add Textbox Method
    function Window:AddTextbox(config)
        config = config or {}
        local textboxText = config.Text or "Textbox"
        local placeholder = config.Placeholder or "Enter text..."
        local callback = config.Callback or function() end
        
        local textboxFrame = Instance.new("Frame")
        textboxFrame.Name = "TextboxFrame"
        textboxFrame.Parent = contentFrame
        textboxFrame.BackgroundColor3 = Theme.Surface
        textboxFrame.Size = UDim2.new(1, -20, 0, 60)
        CreateCorner(8).Parent = textboxFrame
        CreateStroke(Theme.Border).Parent = textboxFrame
        
        local textboxLabel = Instance.new("TextLabel")
        textboxLabel.Name = "TextboxLabel"
        textboxLabel.Parent = textboxFrame
        textboxLabel.BackgroundTransparency = 1
        textboxLabel.Size = UDim2.new(1, -20, 0, 20)
        textboxLabel.Position = UDim2.new(0, 10, 0, 5)
        textboxLabel.Text = textboxText
        textboxLabel.TextColor3 = Theme.Text
        textboxLabel.TextSize = 14
        textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        textboxLabel.Font = Enum.Font.Gotham
        
        local textbox = Instance.new("TextBox")
        textbox.Name = "Textbox"
        textbox.Parent = textboxFrame
        textbox.BackgroundColor3 = Theme.Background
        textbox.Size = UDim2.new(1, -20, 0, 25)
        textbox.Position = UDim2.new(0, 10, 0, 30)
        textbox.PlaceholderText = placeholder
        textbox.PlaceholderColor3 = Theme.TextSecondary
        textbox.Text = ""
        textbox.TextColor3 = Theme.Text
        textbox.TextSize = 14
        textbox.Font = Enum.Font.Gotham
        textbox.ClearButtonOnFocus = false
        CreateCorner(6).Parent = textbox
        CreateStroke(Theme.Border).Parent = textbox
        
        textbox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                callback(textbox.Text)
            end
        end)
        
        return textboxFrame
    end
    
    -- Add Dropdown Method
    function Window:AddDropdown(config)
        config = config or {}
        local dropdownText = config.Text or "Dropdown"
        local options = config.Options or {"Option 1", "Option 2", "Option 3"}
        local callback = config.Callback or function() end
        
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Name = "DropdownFrame"
        dropdownFrame.Parent = contentFrame
        dropdownFrame.BackgroundColor3 = Theme.Surface
        dropdownFrame.Size = UDim2.new(1, -20, 0, 40)
        dropdownFrame.ClipsDescendants = true
        CreateCorner(8).Parent = dropdownFrame
        CreateStroke(Theme.Border).Parent = dropdownFrame
        
        local dropdownLabel = Instance.new("TextLabel")
        dropdownLabel.Name = "DropdownLabel"
        dropdownLabel.Parent = dropdownFrame
        dropdownLabel.BackgroundTransparency = 1
        dropdownLabel.Size = UDim2.new(1, -40, 1, 0)
        dropdownLabel.Position = UDim2.new(0, 15, 0, 0)
        dropdownLabel.Text = dropdownText .. ": " .. options[1]
        dropdownLabel.TextColor3 = Theme.Text
        dropdownLabel.TextSize = 14
        dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropdownLabel.Font = Enum.Font.Gotham
        
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Name = "DropdownButton"
        dropdownButton.Parent = dropdownFrame
        dropdownButton.BackgroundTransparency = 1
        dropdownButton.Size = UDim2.new(0, 30, 1, 0)
        dropdownButton.Position = UDim2.new(1, -30, 0, 0)
        dropdownButton.Text = "▼"
        dropdownButton.TextColor3 = Theme.Primary
        dropdownButton.TextSize = 12
        dropdownButton.Font = Enum.Font.Gotham
        
        local optionsFrame = Instance.new("Frame")
        optionsFrame.Name = "OptionsFrame"
        optionsFrame.Parent = dropdownFrame
        optionsFrame.BackgroundColor3 = Theme.Background
        optionsFrame.Size = UDim2.new(1, 0, 0, #options * 30)
        optionsFrame.Position = UDim2.new(0, 0, 1, 0)
        optionsFrame.Visible = false
        CreateCorner(8).Parent = optionsFrame
        CreateStroke(Theme.Border).Parent = optionsFrame
        
        local optionsLayout = Instance.new("UIListLayout")
        optionsLayout.Parent = optionsFrame
        optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local isOpen = false
        local selectedOption = options[1]
        
        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Name = "Option" .. i
            optionButton.Parent = optionsFrame
            optionButton.BackgroundColor3 = Theme.Background
            optionButton.Size = UDim2.new(1, 0, 0, 30)
            optionButton.Text = option
            optionButton.TextColor3 = Theme.Text
            optionButton.TextSize = 14
            optionButton.Font = Enum.Font.Gotham
            
            optionButton.MouseButton1Click:Connect(function()
                selectedOption = option
                dropdownLabel.Text = dropdownText .. ": " .. option
                
                -- Close dropdown
                isOpen = false
                dropdownButton.Text = "▼"
                TweenService:Create(dropdownFrame, Animations.Fast, {Size = UDim2.new(1, -20, 0, 40)}):Play()
                optionsFrame.Visible = false
                
                callback(option)
            end)
            
            AnimateHover(optionButton, Theme.Surface, Theme.Background)
        end
        
        dropdownButton.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            
            if isOpen then
                dropdownButton.Text = "▲"
                dropdownFrame.Size = UDim2.new(1, -20, 0, 40 + #options * 30)
                optionsFrame.Visible = true
                TweenService:Create(dropdownFrame, Animations.Fast, {Size = UDim2.new(1, -20, 0, 40 + #options * 30)}):Play()
            else
                dropdownButton.Text = "▼"
                TweenService:Create(dropdownFrame, Animations.Fast, {Size = UDim2.new(1, -20, 0, 40)}):Play()
                wait(0.15)
                optionsFrame.Visible = false
            end
        end)
        
        return dropdownFrame
    end
    
    -- Add Label Method
    function Window:AddLabel(config)
        config = config or {}
        local labelText = config.Text or "Label"
        local textSize = config.Size or 14
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Parent = contentFrame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -20, 0, 25)
        label.Text = labelText
        label.TextColor3 = Theme.TextSecondary
        label.TextSize = textSize
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.TextWrapped = true
        
        return label
    end
    
    -- Add Separator Method
    function Window:AddSeparator()
        local separator = Instance.new("Frame")
        separator.Name = "Separator"
        separator.Parent = contentFrame
        separator.BackgroundColor3 = Theme.Border
        separator.Size = UDim2.new(1, -40, 0, 1)
        separator.Position = UDim2.new(0, 20, 0, 0)
        
        return separator
    end
    
    -- Entrance Animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(mainFrame, Animations.Bounce, {
        Size = windowSize,
        Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    }):Play()
    
    return Window
end

-- Notification System
function UILibrary:CreateNotification(config)
    config = config or {}
    local title = config.Title or "Notification"
    local description = config.Description or "This is a notification"
    local duration = config.Duration or 3
    local notificationType = config.Type or "info" -- info, success, warning, error
    
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "NotificationGui"
    notificationGui.Parent = PlayerGui
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Parent = notificationGui
    notification.BackgroundColor3 = Theme.Surface
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, 10, 0, 50)
    CreateCorner(10).Parent = notification
    CreateStroke(Theme.Border, 2).Parent = notification
    CreateShadow(notification, 15, 0.6)
    
    -- Notification color based on type
    local typeColors = {
        info = Theme.Primary,
        success = Theme.Success,
        warning = Theme.Warning,
        error = Theme.Error
    }
    
    local colorBar = Instance.new("Frame")
    colorBar.Name = "ColorBar"
    colorBar.Parent = notification
    colorBar.BackgroundColor3 = typeColors[notificationType] or Theme.Primary
    colorBar.Size = UDim2.new(0, 4, 1, 0)
    colorBar.Position = UDim2.new(0, 0, 0, 0)
    CreateCorner(2).Parent = colorBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Parent = notification
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -50, 0, 25)
    titleLabel.Position = UDim2.new(0, 15, 0, 10)
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "DescLabel"
    descLabel.Parent = notification
    descLabel.BackgroundTransparency = 1
    descLabel.Size = UDim2.new(1, -50, 0, 35)
    descLabel.Position = UDim2.new(0, 15, 0, 35)
    descLabel.Text = description
    descLabel.TextColor3 = Theme.TextSecondary
    descLabel.TextSize = 14
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextWrapped = true
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Parent = notification
    closeBtn.BackgroundTransparency = 1
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -25, 0, 5)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Theme.TextSecondary
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    
    -- Slide in animation
    TweenService:Create(notification, Animations.Medium, {
        Position = UDim2.new(1, -310, 0, 50)
    }):Play()
    
    -- Auto close
    local closeNotification = function()
        TweenService:Create(notification, Animations.Medium, {
            Position = UDim2.new(1, 10, 0, 50)
        }):Play()
        wait(0.3)
        notificationGui:Destroy()
    end
    
    closeBtn.MouseButton1Click:Connect(closeNotification)
    
    spawn(function()
        wait(duration)
        closeNotification()
    end)
    
    return notification
end

-- Return the library
return UILibrary
