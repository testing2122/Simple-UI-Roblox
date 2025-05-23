--[[
    Purple UI Library for Roblox - Single File Version
    A sleek, modern UI library with purple aesthetics
    
    Usage:
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/PurpleUI/main/PurpleUI.lua"))()
    local Window = Library:CreateWindow("Title", UDim2.new(0, 500, 0, 350))
]]

local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Colors
Library.Colors = {
    Primary = Color3.fromRGB(125, 95, 255),        -- Main purple
    Secondary = Color3.fromRGB(149, 125, 255),     -- Lighter purple
    Accent = Color3.fromRGB(180, 160, 255),        -- Even lighter purple
    Background = Color3.fromRGB(25, 25, 35),       -- Dark background
    BackgroundLight = Color3.fromRGB(35, 35, 50),  -- Lighter background
    BackgroundDark = Color3.fromRGB(20, 20, 30),   -- Darker background
    Text = Color3.fromRGB(255, 255, 255),          -- White text
    TextDark = Color3.fromRGB(200, 200, 200),      -- Slightly darker text
    TextMuted = Color3.fromRGB(150, 150, 150),     -- Muted text
    Success = Color3.fromRGB(130, 255, 160),       -- Green
    Error = Color3.fromRGB(255, 120, 120),         -- Red
    Warning = Color3.fromRGB(255, 200, 120),       -- Orange
    Border = Color3.fromRGB(60, 60, 80),           -- Border color
}

-- Utility functions
function Library:Tween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    
    return tween
end

function Library:CreateInstance(className, properties)
    local instance = Instance.new(className)
    
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    
    return instance
end

function Library:CreateRoundedCorner(parent, radius)
    local uiCorner = self:CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or 6),
        Parent = parent
    })
    
    return uiCorner
end

function Library:CreateStroke(parent, color, thickness, transparency)
    local uiStroke = self:CreateInstance("UIStroke", {
        Color = color or self.Colors.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = parent
    })
    
    return uiStroke
end

function Library:CreateGradient(parent, colors, rotation)
    local gradient = self:CreateInstance("UIGradient", {
        Color = ColorSequence.new(colors or {
            ColorSequenceKeypoint.new(0, self.Colors.Primary),
            ColorSequenceKeypoint.new(1, self.Colors.Secondary)
        }),
        Rotation = rotation or 0,
        Parent = parent
    })
    
    return gradient
end

-- Create the main UI window
function Library:CreateWindow(title, size)
    local window = {}
    setmetatable(window, self)
    
    -- Create ScreenGui
    window.ScreenGui = self:CreateInstance("ScreenGui", {
        Name = "PurpleUI_" .. math.random(1000, 9999),
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Create main frame
    window.MainFrame = self:CreateInstance("Frame", {
        Name = "MainFrame",
        Parent = window.ScreenGui,
        BackgroundColor3 = self.Colors.Background,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = size or UDim2.new(0, 500, 0, 400),
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    
    self:CreateRoundedCorner(window.MainFrame, 12)
    self:CreateStroke(window.MainFrame, self.Colors.Border, 1, 0.3)
    
    -- Add shadow effect
    local shadow = self:CreateInstance("Frame", {
        Name = "Shadow",
        Parent = window.ScreenGui,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.7,
        Position = UDim2.new(0.5, 3, 0.5, 3),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = size or UDim2.new(0, 500, 0, 400),
        ZIndex = window.MainFrame.ZIndex - 1,
        BorderSizePixel = 0
    })
    
    self:CreateRoundedCorner(shadow, 12)
    
    -- Create title bar
    window.TitleBar = self:CreateInstance("Frame", {
        Name = "TitleBar",
        Parent = window.MainFrame,
        BackgroundColor3 = self.Colors.Primary,
        Size = UDim2.new(1, 0, 0, 35),
        BorderSizePixel = 0
    })
    
    self:CreateRoundedCorner(window.TitleBar, 12)
    self:CreateGradient(window.TitleBar)
    
    -- Fix title bar corners (only round top)
    local titleBarBottom = self:CreateInstance("Frame", {
        Name = "TitleBarBottom",
        Parent = window.TitleBar,
        BackgroundColor3 = self.Colors.Primary,
        Position = UDim2.new(0, 0, 0.7, 0),
        Size = UDim2.new(1, 0, 0.3, 0),
        BorderSizePixel = 0
    })
    
    -- Create title
    window.Title = self:CreateInstance("TextLabel", {
        Name = "Title",
        Parent = window.TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -80, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title or "Purple UI",
        TextColor3 = self.Colors.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Create minimize button
    window.MinimizeButton = self:CreateInstance("TextButton", {
        Name = "MinimizeButton",
        Parent = window.TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -60, 0, 5),
        Size = UDim2.new(0, 25, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = self.Colors.Text,
        TextSize = 18
    })
    
    self:CreateRoundedCorner(window.MinimizeButton, 4)
    
    -- Create close button
    window.CloseButton = self:CreateInstance("TextButton", {
        Name = "CloseButton",
        Parent = window.TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 5),
        Size = UDim2.new(0, 25, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = self.Colors.Text,
        TextSize = 20
    })
    
    self:CreateRoundedCorner(window.CloseButton, 4)
    
    -- Button hover effects
    window.MinimizeButton.MouseEnter:Connect(function()
        self:Tween(window.MinimizeButton, {BackgroundTransparency = 0.8, BackgroundColor3 = self.Colors.Warning}, 0.2)
    end)
    
    window.MinimizeButton.MouseLeave:Connect(function()
        self:Tween(window.MinimizeButton, {BackgroundTransparency = 1}, 0.2)
    end)
    
    window.CloseButton.MouseEnter:Connect(function()
        self:Tween(window.CloseButton, {BackgroundTransparency = 0.8, BackgroundColor3 = self.Colors.Error}, 0.2)
    end)
    
    window.CloseButton.MouseLeave:Connect(function()
        self:Tween(window.CloseButton, {BackgroundTransparency = 1}, 0.2)
    end)
    
    -- Button functionality
    window.MinimizeButton.MouseButton1Click:Connect(function()
        window.MainFrame.Visible = false
        shadow.Visible = false
        
        -- Create restore button
        local restoreButton = self:CreateInstance("TextButton", {
            Name = "RestoreButton",
            Parent = window.ScreenGui,
            BackgroundColor3 = self.Colors.Primary,
            Position = UDim2.new(0, 10, 1, -40),
            Size = UDim2.new(0, 150, 0, 30),
            Font = Enum.Font.GothamSemibold,
            Text = "Restore " .. (title or "Purple UI"),
            TextColor3 = self.Colors.Text,
            TextSize = 12,
            BorderSizePixel = 0
        })
        
        self:CreateRoundedCorner(restoreButton, 6)
        
        restoreButton.MouseButton1Click:Connect(function()
            window.MainFrame.Visible = true
            shadow.Visible = true
            restoreButton:Destroy()
        end)
    end)
    
    window.CloseButton.MouseButton1Click:Connect(function()
        window.ScreenGui:Destroy()
    end)
    
    -- Create content frame
    window.ContentFrame = self:CreateInstance("Frame", {
        Name = "ContentFrame",
        Parent = window.MainFrame,
        BackgroundColor3 = self.Colors.Background,
        Position = UDim2.new(0, 0, 0, 35),
        Size = UDim2.new(1, 0, 1, -35),
        BorderSizePixel = 0
    })
    
    -- Create container for components
    window.Container = self:CreateInstance("ScrollingFrame", {
        Name = "Container",
        Parent = window.ContentFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 15),
        Size = UDim2.new(1, -30, 1, -30),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = self.Colors.Primary,
        BorderSizePixel = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y
    })
    
    local uiListLayout = self:CreateInstance("UIListLayout", {
        Parent = window.Container,
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Vertical
    })
    
    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        window.Container.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Make window draggable
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    window.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.MainFrame.Position
        end
    end)
    
    window.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
            window.MainFrame.Position = newPos
            shadow.Position = UDim2.new(newPos.X.Scale, newPos.X.Offset + 3, newPos.Y.Scale, newPos.Y.Offset + 3)
        end
    end)
    
    -- Component creation methods
    function window:CreateButton(text, callback)
        local button = {}
        
        button.Frame = Library:CreateInstance("Frame", {
            Name = text .. "ButtonFrame",
            Parent = self.Container,
            BackgroundColor3 = Library.Colors.BackgroundLight,
            Size = UDim2.new(1, 0, 0, 45),
            BorderSizePixel = 0
        })
        
        Library:CreateRoundedCorner(button.Frame, 8)
        Library:CreateStroke(button.Frame, Library.Colors.Border, 1, 0.5)
        
        button.Button = Library:CreateInstance("TextButton", {
            Name = text .. "Button",
            Parent = button.Frame,
            BackgroundColor3 = Library.Colors.Primary,
            Position = UDim2.new(0, 3, 0, 3),
            Size = UDim2.new(1, -6, 1, -6),
            Font = Enum.Font.GothamSemibold,
            Text = text,
            TextColor3 = Library.Colors.Text,
            TextSize = 14,
            BorderSizePixel = 0
        })
        
        Library:CreateRoundedCorner(button.Button, 6)
        Library:CreateGradient(button.Button)
        
        -- Button hover effect
        button.Button.MouseEnter:Connect(function()
            Library:Tween(button.Button, {BackgroundColor3 = Library.Colors.Secondary}, 0.2)
        end)
        
        button.Button.MouseLeave:Connect(function()
            Library:Tween(button.Button, {BackgroundColor3 = Library.Colors.Primary}, 0.2)
        end)
        
        -- Button click effect
        button.Button.MouseButton1Down:Connect(function()
            Library:Tween(button.Button, {
                Size = UDim2.new(1, -10, 1, -10), 
                Position = UDim2.new(0, 5, 0, 5)
            }, 0.1)
        end)
        
        button.Button.MouseButton1Up:Connect(function()
            Library:Tween(button.Button, {
                Size = UDim2.new(1, -6, 1, -6), 
                Position = UDim2.new(0, 3, 0, 3)
            }, 0.1)
        end)
        
        -- Button callback
        button.Button.MouseButton1Click:Connect(function()
            if callback then
                callback()
            end
        end)
        
        return button
    end
    
    function window:CreateToggle(text, default, callback)
        local toggle = {}
        
        toggle.Frame = Library:CreateInstance("Frame", {
            Name = text .. "ToggleFrame",
            Parent = self.Container,
            BackgroundColor3 = Library.Colors.BackgroundLight,
            Size = UDim2.new(1, 0, 0, 45),
            BorderSizePixel = 0
        })
        
        Library:CreateRoundedCorner(toggle.Frame, 8)
        Library:CreateStroke(toggle.Frame, Library.Colors.Border, 1, 0.5)
        
        toggle.Label = Library:CreateInstance("TextLabel", {
            Name = "Label",
            Parent = toggle.Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 0),
            Size = UDim2.new(1, -70, 1, 0),
            Font = Enum.Font.GothamSemibold,
            Text = text,
            TextColor3 = Library.Colors.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        toggle.ToggleFrame = Library:CreateInstance("Frame", {
            Name = "ToggleFrame",
            Parent = toggle.Frame,
            BackgroundColor3 = default and Library.Colors.Primary or Library.Colors.BackgroundDark,
            Position = UDim2.new(1, -55, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 45, 0, 22),
            BorderSizePixel = 0
        })
        
        Library:CreateRoundedCorner(toggle.ToggleFrame, 11)
        Library:CreateStroke(toggle.ToggleFrame, Library.Colors.Border, 1, 0.3)
        
        toggle.ToggleCircle = Library:CreateInstance("Frame", {
            Name = "ToggleCircle",
            Parent = toggle.ToggleFrame,
            BackgroundColor3 = Library.Colors.Text,
            Position = default and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 18, 0, 18),
            BorderSizePixel = 0
        })
        
        Library:CreateRoundedCorner(toggle.ToggleCircle, 9)
        
        toggle.Value = default or false
        
        toggle.Frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                toggle.Value = not toggle.Value
                
                if toggle.Value then
                    Library:Tween(toggle.ToggleFrame, {BackgroundColor3 = Library.Colors.Primary}, 0.3)
                    Library:Tween(toggle.ToggleCircle, {Position = UDim2.new(1, -20, 0.5, 0)}, 0.3, Enum.EasingStyle.Back)
                else
                    Library:Tween(toggle.ToggleFrame, {BackgroundColor3 = Library.Colors.BackgroundDark}, 0.3)
                    Library:Tween(toggle.ToggleCircle, {Position = UDim2.new(0, 2, 0.5, 0)}, 0.3, Enum.EasingStyle.Back)
                end
                
                if callback then
                    callback(toggle.Value)
                end
            end
        end)
        
        return toggle
    end
    
    function window:CreateSlider(text, min, max, default, callback)
        local slider = {}
        
        slider.Frame = Library:CreateInstance("Frame", {
            Name = text .. "SliderFrame",
            Parent = self.Container,
            BackgroundColor3 = Library.Colors.BackgroundLight,
            Size = UDim2.new(1, 0, 0, 65),
            BorderSizePixel = 0
        })
        
        Library:CreateRoundedCorner(slider.Frame, 8)
        Library:CreateStroke(slider.Frame, Library.Colors.Border, 1, 0.5)
        
        slider.Label = Library:CreateInstance("TextLabel", {
            Name = "Label",
            Parent = slider.Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 8),
            Size = UDim2.new(1, -30, 0, 20),
            Font = Enum.Font.GothamSemibold,
            Text = text,
            TextColor3 = Library.Colors.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        slider.Value = Library:CreateInstance("TextLabel", {
            Name = "Value",
            Parent = slider.Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -60, 0, 8),
            Size = UDim2.new(0, 45, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = tostring(default),
            TextColor3 = Library.Colors.Primary,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Right
        })
        
        slider.SliderBack = Library:CreateInstance("Frame", {
            Name = "SliderBack",
            Parent = slider.Frame,
            BackgroundColor3 = Library.Colors.BackgroundDark,
            Position = UDim2.new(0, 15, 0, 40),
            Size = UDim2.new(1, -30, 0, 12),
            BorderSizePixel = 0
        })
        
        Library:CreateRoundedCorner(slider.SliderBack, 6)
        Library:CreateStroke(slider.SliderBack, Library.Colors.Border, 1, 0.3)
        
        slider.SliderFill = Library:CreateInstance("Frame", {
            Name = "SliderFill",
            Parent = slider.SliderBack,
            BackgroundColor3 = Library.Colors.Primary,
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
            BorderSizePixel = 0
        })
        
        Library:CreateRoundedCorner(slider.SliderFill, 6)
        Library:CreateGradient(slider.SliderFill)
        
        slider.SliderButton = Library:CreateInstance("TextButton", {
            Name = "SliderButton",
            Parent = slider.SliderBack,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Text = ""
        })
        
        local currentValue = default
        local dragging = false
        
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - slider.SliderBack.AbsolutePosition.X) / slider.SliderBack.AbsoluteSize.X, 0, 1)
            
            Library:Tween(slider.SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
            
            currentValue = math.floor(min + ((max - min) * pos) + 0.5)
            slider.Value.Text = tostring(currentValue)
            
            if callback then
                callback(currentValue)
            end
        end
        
        slider.SliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input)
            end
        end)
        
        slider.SliderButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        return slider
    end
    
    function window:CreateDropdown(text, options, default, callback)
        local dropdown = {}
        
        dropdown.Frame = Library:CreateInstance("Frame", {
            Name = text .. "DropdownFrame",
            Parent = self.Container,
            BackgroundColor3 = Library.Colors.BackgroundLight,
            Size = UDim2.new(1, 0, 0, 45),
            ClipsDescendants = true,
            BorderSizePixel = 0
        })
        
        Library:CreateRoundedCorner(dropdown.Frame, 8)
        Library:CreateStroke(dropdown.Frame, Library.Colors.Border, 1, 0.5)
        
        dropdown.Label = Library:CreateInstance("TextLabel", {
            Name = "Label",
            Parent = dropdown.Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 0),
            Size = UDim2.new(1, -30, 0, 45),
            Font = Enum.Font.GothamSemibold,
            Text = text,
            TextColor3 = Library.Colors.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        dropdown.Selected = Library:CreateInstance("TextLabel", {
            Name = "Selected",
            Parent = dropdown.Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -180, 0, 0),
            Size = UDim2.new(0, 150, 0, 45),
            Font = Enum.Font.Gotham,
            Text = default or "Select...",
            TextColor3 = Library.Colors.TextMuted,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Right
        })
        
        dropdown.Arrow = Library:CreateInstance("TextLabel", {
            Name = "Arrow",
            Parent = dropdown.Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -30, 0, 0),
            Size = UDim2.new(0, 20, 0, 45),
            Font = Enum.Font.GothamBold,
            Text = "▼",
            TextColor3 = Library.Colors.Primary,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Center
        })
        
        dropdown.OptionsFrame = Library:CreateInstance("Frame", {
            Name = "OptionsFrame",
            Parent = dropdown.Frame,
            BackgroundColor3 = Library.Colors.BackgroundDark,
            Position = UDim2.new(0, 0, 0, 45),
            Size = UDim2.new(1, 0, 0, #options * 35),
            Visible = false,
            BorderSizePixel = 0
        })
        
        Library:CreateStroke(dropdown.OptionsFrame, Library.Colors.Border, 1, 0.3)
        
        local uiListLayout = Library:CreateInstance("UIListLayout", {
            Parent = dropdown.OptionsFrame,
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        dropdown.IsOpen = false
        
        dropdown.Frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dropdown.IsOpen = not dropdown.IsOpen
                
                if dropdown.IsOpen then
                    Library:Tween(dropdown.Arrow, {Rotation = 180}, 0.3, Enum.EasingStyle.Back)
                    Library:Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 45 + #options * 35)}, 0.3, Enum.EasingStyle.Quart)
                    dropdown.OptionsFrame.Visible = true
                else
                    Library:Tween(dropdown.Arrow, {Rotation = 0}, 0.3, Enum.EasingStyle.Back)
                    Library:Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 45)}, 0.3, Enum.EasingStyle.Quart)
                    dropdown.OptionsFrame.Visible = false
                end
            end
        end)
        
        for i, option in ipairs(options) do
            local optionButton = Library:CreateInstance("TextButton", {
                Name = option .. "Option",
                Parent = dropdown.OptionsFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 35),
                Font = Enum.Font.Gotham,
                Text = option,
                TextColor3 = Library.Colors.TextDark,
                TextSize = 14
            })
            
            optionButton.MouseEnter:Connect(function()
                Library:Tween(optionButton, {
                    BackgroundTransparency = 0.8, 
                    BackgroundColor3 = Library.Colors.Primary
                }, 0.2)
            end)
            
            optionButton.MouseLeave:Connect(function()
                Library:Tween(optionButton, {BackgroundTransparency = 1}, 0.2)
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                dropdown.Selected.Text = option
                dropdown.Selected.TextColor3 = Library.Colors.Text
                dropdown.IsOpen = false
                Library:Tween(dropdown.Arrow, {Rotation = 0}, 0.3, Enum.EasingStyle.Back)
                Library:Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 45)}, 0.3, Enum.EasingStyle.Quart)
                dropdown.OptionsFrame.Visible = false
                
                if callback then
                    callback(option)
                end
            end)
        end
        
        return dropdown
    end
    
    function window:CreateTextBox(text, placeholder, callback)
        local textbox = {}
        
        textbox.Frame = Library:CreateInstance("Frame", {
            Name = text .. "TextBoxFrame",
            Parent = self.Container,
            BackgroundColor3 = Library.Colors.BackgroundLight,
            Size = UDim2.new(1, 0, 0, 45),
            BorderSizePixel = 0
        })
        
        Library:CreateRoundedCorner(textbox.Frame, 8)
        Library:CreateStroke(textbox.Frame, Library.Colors.Border, 1, 0.5)
        
        textbox.Label = Library:CreateInstance("TextLabel", {
            Name = "Label",
            Parent = textbox.Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 0),
            Size = UDim2.new(0.4, 0, 1, 0),
            Font = Enum.Font.GothamSemibold,
            Text = text,
            TextColor3 = Library.Colors.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        textbox.TextBox = Library:CreateInstance("TextBox", {
            Name = "TextBox",
            Parent = textbox.Frame,
            BackgroundColor3 = Library.Colors.BackgroundDark,
            Position = UDim2.new(0.4, 10, 0, 8),
            Size = UDim2.new(0.6, -25, 1, -16),
            Font = Enum.Font.Gotham,
            PlaceholderText = placeholder or "Enter text...",
            PlaceholderColor3 = Library.Colors.TextMuted,
            Text = "",
            TextColor3 = Library.Colors.Text,
            TextSize = 14,
            BorderSizePixel = 0,
            ClearButtonOnFocus = false
        })
        
        Library:CreateRoundedCorner(textbox.TextBox, 6)
        Library:CreateStroke(textbox.TextBox, Library.Colors.Border, 1, 0.3)
        
        textbox.TextBox.Focused:Connect(function()
            Library:Tween(textbox.TextBox, {BackgroundColor3 = Library.Colors.Background}, 0.2)
        end)
        
        textbox.TextBox.FocusLost:Connect(function()
            Library:Tween(textbox.TextBox, {BackgroundColor3 = Library.Colors.BackgroundDark}, 0.2)
            if callback then
                callback(textbox.TextBox.Text)
            end
        end)
        
        return textbox
    end
    
    function window:CreateNotification(title, text, duration, notificationType)
        local notification = {}
        
        local color = Library.Colors.Primary
        if notificationType == "success" then
            color = Library.Colors.Success
        elseif notificationType == "error" then
            color = Library.Colors.Error
        elseif notificationType == "warning" then
            color = Library.Colors.Warning
        end
        
        notification.Frame = Library:CreateInstance("Frame", {
            Name = "NotificationFrame",
            Parent = self.ScreenGui,
            BackgroundColor3 = Library.Colors.Background,
            Position = UDim2.new(1, -320, 1, 10),
            Size = UDim2.new(0, 300, 0, 90),
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0, 1)
        })
        
        Library:CreateRoundedCorner(notification.Frame, 8)
        Library:CreateStroke(notification.Frame, color, 2)
        
        notification.ColorBar = Library:CreateInstance("Frame", {
            Name = "ColorBar",
            Parent = notification.Frame,
            BackgroundColor3 = color,
            Size = UDim2.new(0, 4, 1, 0),
            BorderSizePixel = 0
        })
        
        Library:CreateRoundedCorner(notification.ColorBar, 2)
        
        notification.Title = Library:CreateInstance("TextLabel", {
            Name = "Title",
            Parent = notification.Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 8),
            Size = UDim2.new(1, -30, 0, 25),
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = color,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        notification.Text = Library:CreateInstance("TextLabel", {
            Name = "Text",
            Parent = notification.Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 35),
            Size = UDim2.new(1, -30, 0, 45),
            Font = Enum.Font.Gotham,
            Text = text,
            TextColor3 = Library.Colors.Text,
            TextSize = 14,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })
        
        Library:Tween(notification.Frame, {Position = UDim2.new(1, -320, 1, -110)}, 0.5, Enum.EasingStyle.Back)
        
        task.delay(duration or 4, function()
            Library:Tween(notification.Frame, {Position = UDim2.new(1, -320, 1, 10)}, 0.5, Enum.EasingStyle.Quart)
            task.delay(0.5, function()
                notification.Frame:Destroy()
            end)
        end)
        
        return notification
    end
    
    function window:CreateLabel(text, size)
        local label = {}
        
        label.Frame = Library:CreateInstance("Frame", {
            Name = "LabelFrame",
            Parent = self.Container,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, size or 30),
            BorderSizePixel = 0
        })
        
        label.Label = Library:CreateInstance("TextLabel", {
            Name = "Label",
            Parent = label.Frame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text = text,
            TextColor3 = Library.Colors.TextDark,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
        
        return label
    end
    
    function window:CreateSeparator()
        local separator = {}
        
        separator.Frame = Library:CreateInstance("Frame", {
            Name = "SeparatorFrame",
            Parent = self.Container,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            BorderSizePixel = 0
        })
        
        separator.Line = Library:CreateInstance("Frame", {
            Name = "Line",
            Parent = separator.Frame,
            BackgroundColor3 = Library.Colors.Border,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 0, 1),
            BorderSizePixel = 0
        })
        
        return separator
    end
    
    return window
end

return Library
