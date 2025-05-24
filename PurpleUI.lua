-- Modern Purple UI Library for Roblox (Enhanced Version)
-- Load with: loadstring(game:HttpGet("YOUR_GITHUB_RAW_URL"))()

local PurpleUI = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Theme Configuration
local Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    BackgroundSecondary = Color3.fromRGB(25, 25, 35),
    BackgroundTertiary = Color3.fromRGB(35, 35, 45),
    Primary = Color3.fromRGB(138, 43, 226), -- Purple
    PrimaryHover = Color3.fromRGB(148, 53, 236),
    Secondary = Color3.fromRGB(75, 85, 99),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(156, 163, 175),
    Border = Color3.fromRGB(55, 65, 81),
    Success = Color3.fromRGB(34, 197, 94),
    Warning = Color3.fromRGB(251, 191, 36),
    Error = Color3.fromRGB(239, 68, 68),
    Separator = Color3.fromRGB(45, 55, 75)
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

local function CreateBlur(parent, intensity)
    local blur = Instance.new("BlurEffect")
    blur.Size = intensity or 15
    blur.Parent = parent
    return blur
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Theme.Border
    stroke.Transparency = transparency or 0
    stroke.Parent = parent
    return stroke
end

local function CreateGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colors or ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Primary),
        ColorSequenceKeypoint.new(1, Theme.PrimaryHover)
    }
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

local function AnimateGradient(gradient)
    local rotationTween = TweenService:Create(gradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
        Rotation = 360
    })
    rotationTween:Play()
    return rotationTween
end

-- Main Window Class
function PurpleUI:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "Purple UI"
    local windowSize = config.Size or UDim2.new(0, 700, 0, 500)
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PurpleUI_" .. windowTitle
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui
    
    -- Background Blur
    local blurFrame = Instance.new("Frame")
    blurFrame.Name = "BlurBackground"
    blurFrame.Size = UDim2.new(1, 0, 1, 0)
    blurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blurFrame.BackgroundTransparency = 0.3
    blurFrame.BorderSizePixel = 0
    blurFrame.Parent = screenGui
    
    CreateBlur(game.Lighting, 15)
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = windowSize
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    CreateCorner(mainFrame, 12)
    CreateStroke(mainFrame, 1, Theme.Border, 0.5)
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Theme.BackgroundSecondary
    titleBar.BackgroundTransparency = 0.1
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    CreateCorner(titleBar, 12)
    local titleGradient = CreateGradient(titleBar, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Primary),
        ColorSequenceKeypoint.new(0.5, Theme.BackgroundSecondary),
        ColorSequenceKeypoint.new(1, Theme.Primary)
    }, 45)
    AnimateGradient(titleGradient)
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = windowTitle
    titleText.TextColor3 = Theme.Text
    titleText.TextSize = 14
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.BackgroundColor3 = Theme.Error
    closeButton.BackgroundTransparency = 0.2
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = Theme.Text
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    
    CreateCorner(closeButton, 4)
    
    closeButton.MouseButton1Click:Connect(function()
        CreateTween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        wait(0.3)
        screenGui:Destroy()
    end)
    
    -- Main Container
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(1, 0, 1, -35)
    mainContainer.Position = UDim2.new(0, 0, 0, 35)
    mainContainer.BackgroundTransparency = 1
    mainContainer.Parent = mainFrame
    
    -- Left Sidebar (Tabs)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 180, 1, 0)
    sidebar.BackgroundColor3 = Theme.BackgroundSecondary
    sidebar.BackgroundTransparency = 0.1
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainContainer
    
    CreateCorner(sidebar, 8)
    CreateStroke(sidebar, 1, Theme.Border, 0.7)
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 2)
    sidebarLayout.Parent = sidebar
    
    -- Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -190, 1, 0)
    contentArea.Position = UDim2.new(0, 190, 0, 0)
    contentArea.BackgroundColor3 = Theme.BackgroundTertiary
    contentArea.BackgroundTransparency = 0.1
    contentArea.BorderSizePixel = 0
    contentArea.Parent = mainContainer
    
    CreateCorner(contentArea, 8)
    CreateStroke(contentArea, 1, Theme.Border, 0.7)
    
    -- Content Scroll Frame
    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Name = "ContentScroll"
    contentScroll.Size = UDim2.new(1, -20, 1, -20)
    contentScroll.Position = UDim2.new(0, 10, 0, 10)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 4
    contentScroll.ScrollBarImageColor3 = Theme.Primary
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScroll.Parent = contentArea
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = contentScroll
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentScroll.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
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
        Sidebar = sidebar,
        ContentScroll = contentScroll,
        ScreenGui = screenGui,
        Tabs = {},
        CurrentTab = nil
    }
    
    -- Create Tab function
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or "📁"
        
        -- Tab Button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName
        tabButton.Size = UDim2.new(1, -10, 0, 35)
        tabButton.BackgroundColor3 = Theme.BackgroundTertiary
        tabButton.BackgroundTransparency = 0.3
        tabButton.BorderSizePixel = 0
        tabButton.Text = tabIcon .. " " .. tabName
        tabButton.TextColor3 = Theme.TextSecondary
        tabButton.TextSize = 12
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.Font = Enum.Font.Gotham
        tabButton.Parent = sidebar
        
        CreateCorner(tabButton, 6)
        
        -- Tab Content Frame
        local tabContent = Instance.new("Frame")
        tabContent.Name = tabName .. "_Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = contentScroll
        
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 8)
        tabLayout.Parent = tabContent
        
        -- Tab object
        local Tab = {
            Name = tabName,
            Button = tabButton,
            Content = tabContent,
            Layout = tabLayout,
            Window = Window
        }
        
        -- Tab selection logic
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = Theme.BackgroundTertiary
                tab.Button.TextColor3 = Theme.TextSecondary
            end
            
            -- Show selected tab
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Theme.Primary
            tabButton.TextColor3 = Theme.Text
            Window.CurrentTab = Tab
            
            CreateTween(tabButton, {BackgroundColor3 = Theme.Primary}, 0.2)
        end)
        
        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                CreateTween(tabButton, {BackgroundColor3 = Theme.Secondary}, 0.2)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                CreateTween(tabButton, {BackgroundColor3 = Theme.BackgroundTertiary}, 0.2)
            end
        end)
        
        -- Add separator after tab (except last)
        local separator = Instance.new("Frame")
        separator.Name = "Separator"
        separator.Size = UDim2.new(1, -20, 0, 1)
        separator.BackgroundColor3 = Theme.Separator
        separator.BorderSizePixel = 0
        separator.Parent = sidebar
        
        -- Tab functions
        function Tab:CreateSection(sectionName)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = sectionName
            sectionFrame.Size = UDim2.new(1, 0, 0, 30)
            sectionFrame.BackgroundColor3 = Theme.BackgroundSecondary
            sectionFrame.BackgroundTransparency = 0.2
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Parent = tabContent
            
            CreateCorner(sectionFrame, 6)
            CreateStroke(sectionFrame, 1, Theme.Border, 0.8)
            
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Size = UDim2.new(1, -15, 1, 0)
            sectionLabel.Position = UDim2.new(0, 10, 0, 0)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = sectionName
            sectionLabel.TextColor3 = Theme.Text
            sectionLabel.TextSize = 13
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.Parent = sectionFrame
            
            return sectionFrame
        end
        
        function Tab:CreateButton(config)
            config = config or {}
            local buttonText = config.Text or "Button"
            local callback = config.Callback or function() end
            
            local buttonFrame = Instance.new("TextButton")
            buttonFrame.Name = buttonText
            buttonFrame.Size = UDim2.new(1, 0, 0, 32)
            buttonFrame.BackgroundColor3 = Theme.BackgroundSecondary
            buttonFrame.BackgroundTransparency = 0.2
            buttonFrame.BorderSizePixel = 0
            buttonFrame.Text = buttonText
            buttonFrame.TextColor3 = Theme.Text
            buttonFrame.TextSize = 12
            buttonFrame.Font = Enum.Font.Gotham
            buttonFrame.Parent = tabContent
            
            CreateCorner(buttonFrame, 6)
            
            -- Hover effects
            buttonFrame.MouseEnter:Connect(function()
                CreateTween(buttonFrame, {BackgroundColor3 = Theme.Primary}, 0.2)
            end)
            
            buttonFrame.MouseLeave:Connect(function()
                CreateTween(buttonFrame, {BackgroundColor3 = Theme.BackgroundSecondary}, 0.2)
            end)
            
            buttonFrame.MouseButton1Click:Connect(callback)
            
            return buttonFrame
        end
        
        function Tab:CreateToggle(config)
            config = config or {}
            local toggleText = config.Text or "Toggle"
            local defaultValue = config.Default or false
            local callback = config.Callback or function() end
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = toggleText
            toggleFrame.Size = UDim2.new(1, 0, 0, 32)
            toggleFrame.BackgroundColor3 = Theme.BackgroundSecondary
            toggleFrame.BackgroundTransparency = 0.2
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Parent = tabContent
            
            CreateCorner(toggleFrame, 6)
            CreateStroke(toggleFrame, 1, Theme.Border, 0.8)
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Size = UDim2.new(1, -60, 1, 0)
            toggleLabel.Position = UDim2.new(0, 10, 0, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = toggleText
            toggleLabel.TextColor3 = Theme.Text
            toggleLabel.TextSize = 12
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.Parent = toggleFrame
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(0, 40, 0, 18)
            toggleButton.Position = UDim2.new(1, -45, 0.5, -9)
            toggleButton.BackgroundColor3 = defaultValue and Theme.Primary or Theme.Secondary
            toggleButton.BorderSizePixel = 0
            toggleButton.Text = ""
            toggleButton.Parent = toggleFrame
            
            CreateCorner(toggleButton, 9)
            
            local toggleIndicator = Instance.new("Frame")
            toggleIndicator.Size = UDim2.new(0, 14, 0, 14)
            toggleIndicator.Position = defaultValue and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            toggleIndicator.BackgroundColor3 = Theme.Text
            toggleIndicator.BorderSizePixel = 0
            toggleIndicator.Parent = toggleButton
            
            CreateCorner(toggleIndicator, 7)
            
            local isToggled = defaultValue
            
            toggleButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                
                CreateTween(toggleButton, {BackgroundColor3 = isToggled and Theme.Primary or Theme.Secondary}, 0.2)
                CreateTween(toggleIndicator, {Position = isToggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}, 0.2)
                
                callback(isToggled)
            end)
            
            return toggleFrame
        end
        
        function Tab:CreateSlider(config)
            config = config or {}
            local sliderText = config.Text or "Slider"
            local minValue = config.Min or 0
            local maxValue = config.Max or 100
            local defaultValue = config.Default or 50
            local callback = config.Callback or function() end
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = sliderText
            sliderFrame.Size = UDim2.new(1, 0, 0, 45)
            sliderFrame.BackgroundColor3 = Theme.BackgroundSecondary
            sliderFrame.BackgroundTransparency = 0.2
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Parent = tabContent
            
            CreateCorner(sliderFrame, 6)
            CreateStroke(sliderFrame, 1, Theme.Border, 0.8)
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Size = UDim2.new(1, -60, 0, 20)
            sliderLabel.Position = UDim2.new(0, 10, 0, 3)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = sliderText
            sliderLabel.TextColor3 = Theme.Text
            sliderLabel.TextSize = 12
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.Parent = sliderFrame
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 50, 0, 20)
            valueLabel.Position = UDim2.new(1, -55, 0, 3)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(defaultValue)
            valueLabel.TextColor3 = Theme.Primary
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Parent = sliderFrame
            
            local sliderTrack = Instance.new("Frame")
            sliderTrack.Size = UDim2.new(1, -20, 0, 3)
            sliderTrack.Position = UDim2.new(0, 10, 1, -12)
            sliderTrack.BackgroundColor3 = Theme.Secondary
            sliderTrack.BorderSizePixel = 0
            sliderTrack.Parent = sliderFrame
            
            CreateCorner(sliderTrack, 2)
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
            sliderFill.BackgroundColor3 = Theme.Primary
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderTrack
            
            CreateCorner(sliderFill, 2)
            local fillGradient = CreateGradient(sliderFill)
            AnimateGradient(fillGradient)
            
            local sliderButton = Instance.new("TextButton")
            sliderButton.Size = UDim2.new(0, 12, 0, 12)
            sliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -6, 0.5, -6)
            sliderButton.BackgroundColor3 = Theme.Text
            sliderButton.BorderSizePixel = 0
            sliderButton.Text = ""
            sliderButton.Parent = sliderTrack
            
            CreateCorner(sliderButton, 6)
            
            local currentValue = defaultValue
            local dragging = false
            
            sliderButton.MouseButton1Down:Connect(function()
                dragging = true
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
                    currentValue = math.floor(minValue + (maxValue - minValue) * percentage)
                    
                    valueLabel.Text = tostring(currentValue)
                    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    sliderButton.Position = UDim2.new(percentage, -6, 0.5, -6)
                    
                    callback(currentValue)
                end
            end)
            
            return sliderFrame
        end
        
        function Tab:CreateDropdown(config)
            config = config or {}
            local dropdownText = config.Text or "Dropdown"
            local options = config.Options or {"Option 1", "Option 2", "Option 3"}
            local defaultOption = config.Default or options[1]
            local callback = config.Callback or function() end
            
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Name = dropdownText
            dropdownFrame.Size = UDim2.new(1, 0, 0, 32)
            dropdownFrame.BackgroundColor3 = Theme.BackgroundSecondary
            dropdownFrame.BackgroundTransparency = 0.2
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.Parent = tabContent
            
            CreateCorner(dropdownFrame, 6)
            CreateStroke(dropdownFrame, 1, Theme.Border, 0.8)
            
            local dropdownLabel = Instance.new("TextLabel")
            dropdownLabel.Size = UDim2.new(0.4, -10, 1, 0)
            dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Text = dropdownText
            dropdownLabel.TextColor3 = Theme.Text
            dropdownLabel.TextSize = 12
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.Font = Enum.Font.Gotham
            dropdownLabel.Parent = dropdownFrame
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Size = UDim2.new(0.6, -20, 0, 22)
            dropdownButton.Position = UDim2.new(0.4, 10, 0.5, -11)
            dropdownButton.BackgroundColor3 = Theme.BackgroundTertiary
            dropdownButton.BackgroundTransparency = 0.2
            dropdownButton.BorderSizePixel = 0
            dropdownButton.Text = defaultOption .. " ▼"
            dropdownButton.TextColor3 = Theme.Text
            dropdownButton.TextSize = 11
            dropdownButton.Font = Enum.Font.Gotham
            dropdownButton.Parent = dropdownFrame
            
            CreateCorner(dropdownButton, 4)
            CreateStroke(dropdownButton, 1, Theme.Primary, 0.6)
            
            local currentOption = defaultOption
            local isOpen = false
            
            dropdownButton.MouseButton1Click:Connect(function()
                if not isOpen then
                    isOpen = true
                    dropdownFrame.Size = UDim2.new(1, 0, 0, 32 + (#options * 22))
                    
                    for i, option in ipairs(options) do
                        local optionButton = Instance.new("TextButton")
                        optionButton.Name = "Option_" .. i
                        optionButton.Size = UDim2.new(0.6, -20, 0, 20)
                        optionButton.Position = UDim2.new(0.4, 10, 0, 32 + ((i-1) * 22))
                        optionButton.BackgroundColor3 = Theme.BackgroundTertiary
                        optionButton.BackgroundTransparency = 0.3
                        optionButton.BorderSizePixel = 0
                        optionButton.Text = option
                        optionButton.TextColor3 = Theme.Text
                        optionButton.TextSize = 10
                        optionButton.Font = Enum.Font.Gotham
                        optionButton.Parent = dropdownFrame
                        
                        CreateCorner(optionButton, 3)
                        
                        optionButton.MouseButton1Click:Connect(function()
                            currentOption = option
                            dropdownButton.Text = option .. " ▼"
                            callback(option)
                            
                            -- Close dropdown
                            for _, child in ipairs(dropdownFrame:GetChildren()) do
                                if child.Name:match("Option_") then
                                    child:Destroy()
                                end
                            end
                            dropdownFrame.Size = UDim2.new(1, 0, 0, 32)
                            isOpen = false
                        end)
                        
                        optionButton.MouseEnter:Connect(function()
                            CreateTween(optionButton, {BackgroundColor3 = Theme.Primary}, 0.2)
                        end)
                        
                        optionButton.MouseLeave:Connect(function()
                            CreateTween(optionButton, {BackgroundColor3 = Theme.BackgroundTertiary}, 0.2)
                        end)
                    end
                else
                    -- Close dropdown
                    for _, child in ipairs(dropdownFrame:GetChildren()) do
                        if child.Name:match("Option_") then
                            child:Destroy()
                        end
                    end
                    dropdownFrame.Size = UDim2.new(1, 0, 0, 32)
                    isOpen = false
                end
            end)
            
            return dropdownFrame
        end
        
        function Tab:CreateTextbox(config)
            config = config or {}
            local textboxText = config.Text or "Textbox"
            local placeholder = config.Placeholder or "Enter text..."
            local callback = config.Callback or function() end
            
            local textboxFrame = Instance.new("Frame")
            textboxFrame.Name = textboxText
            textboxFrame.Size = UDim2.new(1, 0, 0, 50)
            textboxFrame.BackgroundColor3 = Theme.BackgroundSecondary
            textboxFrame.BackgroundTransparency = 0.2
            textboxFrame.BorderSizePixel = 0
            textboxFrame.Parent = tabContent
            
            CreateCorner(textboxFrame, 6)
            CreateStroke(textboxFrame, 1, Theme.Border, 0.8)
            
            local textboxLabel = Instance.new("TextLabel")
            textboxLabel.Size = UDim2.new(1, -15, 0, 20)
            textboxLabel.Position = UDim2.new(0, 10, 0, 3)
            textboxLabel.BackgroundTransparency = 1
            textboxLabel.Text = textboxText
            textboxLabel.TextColor3 = Theme.Text
            textboxLabel.TextSize = 12
            textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            textboxLabel.Font = Enum.Font.Gotham
            textboxLabel.Parent = textboxFrame
            
            local textbox = Instance.new("TextBox")
            textbox.Size = UDim2.new(1, -20, 0, 22)
            textbox.Position = UDim2.new(0, 10, 1, -25)
            textbox.BackgroundColor3 = Theme.BackgroundTertiary
            textbox.BackgroundTransparency = 0.2
            textbox.BorderSizePixel = 0
            textbox.PlaceholderText = placeholder
            textbox.PlaceholderColor3 = Theme.TextSecondary
            textbox.Text = ""
            textbox.TextColor3 = Theme.Text
            textbox.TextSize = 11
            textbox.Font = Enum.Font.Gotham
            textbox.Parent = textboxFrame
            
            CreateCorner(textbox, 4)
            CreateStroke(textbox, 1, Theme.Primary, 0.6)
            
            textbox.FocusLost:Connect(function()
                callback(textbox.Text)
            end)
            
            return textboxFrame
        end
        
        Window.Tabs[tabName] = Tab
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            tabButton.MouseButton1Click()
        end
        
        return Tab
    end
    
    -- Entrance animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    CreateTween(mainFrame, {Size = windowSize}, 0.6, Enum.EasingStyle.Back)
    
    return Window
end

-- Notification System (Enhanced)
function PurpleUI:CreateNotification(config)
    config = config or {}
    local title = config.Title or "Notification"
    local description = config.Description or "This is a notification"
    local duration = config.Duration or 3
    local notificationType = config.Type or "info"
    
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "PurpleUI_Notification"
    notificationGui.ResetOnSpawn = false
    notificationGui.Parent = PlayerGui
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 320, 0, 70)
    notification.Position = UDim2.new(1, 10, 0, 50)
    notification.BackgroundColor3 = Theme.BackgroundSecondary
    notification.BackgroundTransparency = 0.05
    notification.BorderSizePixel = 0
    notification.Parent = notificationGui
    
    CreateCorner(notification, 8)
    
    local strokeColor = Theme.Primary
    if notificationType == "success" then strokeColor = Theme.Success
    elseif notificationType == "warning" then strokeColor = Theme.Warning
    elseif notificationType == "error" then strokeColor = Theme.Error end
    
    CreateStroke(notification, 2, strokeColor, 0.2)
    
    local notifGradient = CreateGradient(notification, ColorSequence.new{
        ColorSequenceKeypoint.new(0, strokeColor),
        ColorSequenceKeypoint.new(0.5, Theme.BackgroundSecondary),
        ColorSequenceKeypoint.new(1, strokeColor)
    }, 45)
    AnimateGradient(notifGradient)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -15, 0, 22)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = notification
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -15, 0, 35)
    descLabel.Position = UDim2.new(0, 10, 0, 25)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Theme.TextSecondary
    descLabel.TextSize = 11
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.TextWrapped = true
    descLabel.Font = Enum.Font.Gotham
    descLabel.Parent = notification
    
    -- Slide in animation
    CreateTween(notification, {Position = UDim2.new(1, -330, 0, 50)}, 0.5, Enum.EasingStyle.Back)
    
    -- Auto-close
    wait(duration)
    CreateTween(notification, {Position = UDim2.new(1, 10, 0, 50)}, 0.3)
    wait(0.3)
    notificationGui:Destroy()
end

return PurpleUI
