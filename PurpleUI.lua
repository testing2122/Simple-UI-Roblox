--[[
    Reactive Midnight Purple UI Library for Roblox
    Features: Animated gradients, reactive hover effects, smooth transitions
    
    Usage:
    local Library = loadstring(game:HttpGet("YOUR_GITHUB_URL"))()
    local UI = Library:CreateWindow("Reactive UI", "v1.0.0")
]]

local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Midnight Purple Color Palette
Library.Colors = {
    -- Primary Colors (Black/Grey)
    Primary = Color3.fromRGB(0, 0, 0),              -- Pure Black
    PrimaryLight = Color3.fromRGB(18, 18, 18),      -- Dark Grey
    PrimaryMedium = Color3.fromRGB(32, 32, 32),     -- Medium Grey
    PrimaryDark = Color3.fromRGB(8, 8, 8),          -- Almost Black
    
    -- Secondary Colors (Midnight Purple)
    Secondary = Color3.fromRGB(75, 0, 130),         -- Midnight Purple
    SecondaryLight = Color3.fromRGB(138, 43, 226),  -- Blue Violet
    SecondaryDark = Color3.fromRGB(48, 25, 52),     -- Dark Purple
    SecondaryGlow = Color3.fromRGB(186, 85, 211),   -- Medium Orchid
    
    -- Accent Colors
    Accent = Color3.fromRGB(147, 112, 219),         -- Medium Purple
    AccentBright = Color3.fromRGB(221, 160, 221),   -- Plum
    AccentDim = Color3.fromRGB(72, 61, 139),        -- Dark Slate Blue
    
    -- Text Colors
    Text = Color3.fromRGB(255, 255, 255),           -- White
    TextSecondary = Color3.fromRGB(200, 200, 200),  -- Light Grey
    TextMuted = Color3.fromRGB(150, 150, 150),      -- Muted Grey
    TextDark = Color3.fromRGB(100, 100, 100),       -- Dark Grey
    
    -- State Colors
    Success = Color3.fromRGB(0, 255, 127),          -- Spring Green
    Warning = Color3.fromRGB(255, 215, 0),          -- Gold
    Error = Color3.fromRGB(220, 20, 60),            -- Crimson
    Info = Color3.fromRGB(0, 191, 255),             -- Deep Sky Blue
    
    -- Interactive States
    Hover = Color3.fromRGB(45, 45, 45),             -- Hover Grey
    Active = Color3.fromRGB(60, 60, 60),            -- Active Grey
    Focus = Color3.fromRGB(138, 43, 226),           -- Focus Purple
    
    -- Outline Colors
    OutlinePrimary = Color3.fromRGB(75, 0, 130),    -- Purple Outline
    OutlineSecondary = Color3.fromRGB(100, 100, 100), -- Grey Outline
    OutlineGlow = Color3.fromRGB(186, 85, 211),     -- Glowing Purple
}

-- Animation Presets
Library.Animations = {
    Fast = 0.15,
    Normal = 0.25,
    Slow = 0.4,
    VeryFast = 0.1,
    VerySlow = 0.6
}

-- Utility Functions
function Library:Tween(object, properties, duration, style, direction, callback)
    local tweenInfo = TweenInfo.new(
        duration or self.Animations.Normal,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    return tween
end

function Library:CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    return instance
end

function Library:CreateCorner(parent, radius)
    return self:CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or 12),
        Parent = parent
    })
end

function Library:CreateStroke(parent, color, thickness, transparency)
    return self:CreateInstance("UIStroke", {
        Color = color or self.Colors.OutlinePrimary,
        Thickness = thickness or 2,
        Transparency = transparency or 0,
        Parent = parent
    })
end

function Library:CreateGradient(parent, colors, rotation, animated)
    local gradient = self:CreateInstance("UIGradient", {
        Color = ColorSequence.new(colors or {
            ColorSequenceKeypoint.new(0, self.Colors.Secondary),
            ColorSequenceKeypoint.new(1, self.Colors.SecondaryLight)
        }),
        Rotation = rotation or 0,
        Parent = parent
    })
    
    if animated then
        self:AnimateGradient(gradient)
    end
    
    return gradient
end

function Library:AnimateGradient(gradient)
    local rotationTween = TweenService:Create(gradient, 
        TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), 
        {Rotation = 360}
    )
    rotationTween:Play()
    return rotationTween
end

function Library:CreateGlow(parent, color, size)
    local glow = self:CreateInstance("Frame", {
        Name = "Glow",
        Parent = parent.Parent,
        BackgroundColor3 = color or self.Colors.SecondaryGlow,
        BackgroundTransparency = 0.7,
        Position = UDim2.new(0, -size, 0, -size),
        Size = UDim2.new(1, size * 2, 1, size * 2),
        ZIndex = parent.ZIndex - 1,
        BorderSizePixel = 0
    })
    
    self:CreateCorner(glow, (parent:FindFirstChild("UICorner") and parent.UICorner.CornerRadius.Offset or 12) + size)
    
    return glow
end

function Library:CreateRipple(parent, position)
    local ripple = self:CreateInstance("Frame", {
        Name = "Ripple",
        Parent = parent,
        BackgroundColor3 = self.Colors.SecondaryGlow,
        BackgroundTransparency = 0.5,
        Position = UDim2.new(0, position.X - 10, 0, position.Y - 10),
        Size = UDim2.new(0, 20, 0, 20),
        ZIndex = parent.ZIndex + 1,
        BorderSizePixel = 0
    })
    
    self:CreateCorner(ripple, 10)
    
    local expandTween = self:Tween(ripple, {
        Size = UDim2.new(0, 100, 0, 100),
        Position = UDim2.new(0, position.X - 50, 0, position.Y - 50),
        BackgroundTransparency = 1
    }, 0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, function()
        ripple:Destroy()
    end)
    
    return ripple
end

-- Main Window Creation
function Library:CreateWindow(title, version)
    local window = {}
    setmetatable(window, self)
    
    -- Create ScreenGui
    window.ScreenGui = self:CreateInstance("ScreenGui", {
        Name = "ReactiveUI_" .. math.random(1000, 9999),
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Main Container
    window.MainFrame = self:CreateInstance("Frame", {
        Name = "MainFrame",
        Parent = window.ScreenGui,
        BackgroundColor3 = self.Colors.Primary,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 1000, 0, 700),
        BorderSizePixel = 0,
        ClipsDescendants = false
    })
    
    self:CreateCorner(window.MainFrame, 20)
    self:CreateStroke(window.MainFrame, self.Colors.OutlinePrimary, 3, 0.2)
    
    -- Main glow effect
    window.MainGlow = self:CreateGlow(window.MainFrame, self.Colors.SecondaryGlow, 8)
    
    -- Animated background gradient
    window.BackgroundGradient = self:CreateGradient(window.MainFrame, {
        ColorSequenceKeypoint.new(0, self.Colors.Primary),
        ColorSequenceKeypoint.new(0.5, self.Colors.PrimaryLight),
        ColorSequenceKeypoint.new(1, self.Colors.Primary)
    }, 45, true)
    
    -- Sidebar
    window.Sidebar = self:CreateInstance("Frame", {
        Name = "Sidebar",
        Parent = window.MainFrame,
        BackgroundColor3 = self.Colors.PrimaryDark,
        Size = UDim2.new(0, 250, 1, 0),
        BorderSizePixel = 0
    })
    
    self:CreateCorner(window.Sidebar, 20)
    self:CreateStroke(window.Sidebar, self.Colors.OutlineSecondary, 2, 0.5)
    
    -- Sidebar gradient
    window.SidebarGradient = self:CreateGradient(window.Sidebar, {
        ColorSequenceKeypoint.new(0, self.Colors.PrimaryDark),
        ColorSequenceKeypoint.new(1, self.Colors.PrimaryMedium)
    }, 90)
    
    -- Header Section
    window.Header = self:CreateInstance("Frame", {
        Name = "Header",
        Parent = window.Sidebar,
        BackgroundColor3 = self.Colors.Secondary,
        Size = UDim2.new(1, 0, 0, 100),
        BorderSizePixel = 0
    })
    
    self:CreateCorner(window.Header, 20)
    self:CreateStroke(window.Header, self.Colors.OutlinePrimary, 2)
    
    -- Header animated gradient
    window.HeaderGradient = self:CreateGradient(window.Header, {
        ColorSequenceKeypoint.new(0, self.Colors.Secondary),
        ColorSequenceKeypoint.new(0.5, self.Colors.SecondaryLight),
        ColorSequenceKeypoint.new(1, self.Colors.Secondary)
    }, 0, true)
    
    -- Logo
    window.Logo = self:CreateInstance("TextLabel", {
        Name = "Logo",
        Parent = window.Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 20),
        Size = UDim2.new(1, -40, 0, 35),
        Font = Enum.Font.GothamBold,
        Text = "🌙 " .. (title or "Reactive UI"),
        TextColor3 = self.Colors.Text,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextStrokeTransparency = 0.5,
        TextStrokeColor3 = self.Colors.Primary
    })
    
    -- Version
    window.Version = self:CreateInstance("TextLabel", {
        Name = "Version",
        Parent = window.Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 55),
        Size = UDim2.new(1, -40, 0, 25),
        Font = Enum.Font.Gotham,
        Text = version or "v1.0.0",
        TextColor3 = self.Colors.AccentBright,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Navigation Container
    window.NavContainer = self:CreateInstance("ScrollingFrame", {
        Name = "NavContainer",
        Parent = window.Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 120),
        Size = UDim2.new(1, 0, 1, -120),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = self.Colors.Secondary,
        BorderSizePixel = 0
    })
    
    local navLayout = self:CreateInstance("UIListLayout", {
        Parent = window.NavContainer,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        window.NavContainer.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Content Area
    window.ContentArea = self:CreateInstance("Frame", {
        Name = "ContentArea",
        Parent = window.MainFrame,
        BackgroundColor3 = self.Colors.PrimaryLight,
        Position = UDim2.new(0, 250, 0, 0),
        Size = UDim2.new(1, -250, 1, 0),
        BorderSizePixel = 0
    })
    
    self:CreateCorner(window.ContentArea, 20)
    self:CreateStroke(window.ContentArea, self.Colors.OutlineSecondary, 2, 0.5)
    
    -- Content gradient
    window.ContentGradient = self:CreateGradient(window.ContentArea, {
        ColorSequenceKeypoint.new(0, self.Colors.PrimaryLight),
        ColorSequenceKeypoint.new(1, self.Colors.PrimaryMedium)
    }, 135)
    
    -- Content Header
    window.ContentHeader = self:CreateInstance("Frame", {
        Name = "ContentHeader",
        Parent = window.ContentArea,
        BackgroundColor3 = self.Colors.PrimaryMedium,
        Size = UDim2.new(1, 0, 0, 80),
        BorderSizePixel = 0
    })
    
    self:CreateCorner(window.ContentHeader, 20)
    self:CreateStroke(window.ContentHeader, self.Colors.OutlinePrimary, 2, 0.3)
    
    -- Window Controls
    window.WindowControls = self:CreateInstance("Frame", {
        Name = "WindowControls",
        Parent = window.ContentHeader,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -100, 0, 20),
        Size = UDim2.new(0, 80, 0, 40),
        BorderSizePixel = 0
    })
    
    -- Minimize Button
    window.MinimizeBtn = self:CreateInstance("TextButton", {
        Name = "MinimizeBtn",
        Parent = window.WindowControls,
        BackgroundColor3 = self.Colors.PrimaryMedium,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 35, 0, 35),
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = self.Colors.Text,
        TextSize = 18,
        BorderSizePixel = 0,
        AutoButtonColor = false
    })
    
    self:CreateCorner(window.MinimizeBtn, 10)
    self:CreateStroke(window.MinimizeBtn, self.Colors.OutlineSecondary, 2, 0.5)
    
    -- Close Button
    window.CloseBtn = self:CreateInstance("TextButton", {
        Name = "CloseBtn",
        Parent = window.WindowControls,
        BackgroundColor3 = self.Colors.PrimaryMedium,
        Position = UDim2.new(0, 40, 0, 0),
        Size = UDim2.new(0, 35, 0, 35),
        Font = Enum.Font.GothamBold,
        Text = "✕",
        TextColor3 = self.Colors.Text,
        TextSize = 16,
        BorderSizePixel = 0,
        AutoButtonColor = false
    })
    
    self:CreateCorner(window.CloseBtn, 10)
    self:CreateStroke(window.CloseBtn, self.Colors.OutlineSecondary, 2, 0.5)
    
    -- Enhanced button hover effects
    local function setupButtonHover(button, hoverColor, clickColor)
        local originalColor = button.BackgroundColor3
        local glow = nil
        
        button.MouseEnter:Connect(function()
            glow = self:CreateGlow(button, hoverColor, 4)
            self:Tween(button, {BackgroundColor3 = hoverColor}, self.Animations.Fast)
            self:Tween(button.UIStroke, {Color = hoverColor, Thickness = 3}, self.Animations.Fast)
            self:Tween(button, {Size = UDim2.new(0, 38, 0, 38)}, self.Animations.Fast)
        end)
        
        button.MouseLeave:Connect(function()
            if glow then glow:Destroy() end
            self:Tween(button, {BackgroundColor3 = originalColor}, self.Animations.Fast)
            self:Tween(button.UIStroke, {Color = self.Colors.OutlineSecondary, Thickness = 2}, self.Animations.Fast)
            self:Tween(button, {Size = UDim2.new(0, 35, 0, 35)}, self.Animations.Fast)
        end)
        
        button.MouseButton1Down:Connect(function()
            self:Tween(button, {BackgroundColor3 = clickColor}, self.Animations.VeryFast)
            self:Tween(button, {Size = UDim2.new(0, 33, 0, 33)}, self.Animations.VeryFast)
        end)
        
        button.MouseButton1Up:Connect(function()
            self:Tween(button, {BackgroundColor3 = hoverColor}, self.Animations.VeryFast)
            self:Tween(button, {Size = UDim2.new(0, 38, 0, 38)}, self.Animations.VeryFast)
        end)
    end
    
    setupButtonHover(window.MinimizeBtn, self.Colors.Warning, Color3.fromRGB(255, 165, 0))
    setupButtonHover(window.CloseBtn, self.Colors.Error, Color3.fromRGB(139, 0, 0))
    
    -- Button functionality
    window.MinimizeBtn.MouseButton1Click:Connect(function()
        self:Tween(window.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, self.Animations.Slow, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            window.MainFrame.Visible = false
            
            -- Create restore button
            local restoreBtn = self:CreateInstance("TextButton", {
                Name = "RestoreBtn",
                Parent = window.ScreenGui,
                BackgroundColor3 = self.Colors.Secondary,
                Position = UDim2.new(0, 20, 1, -80),
                Size = UDim2.new(0, 250, 0, 60),
                Font = Enum.Font.GothamSemibold,
                Text = "🌙 Restore " .. (title or "UI"),
                TextColor3 = self.Colors.Text,
                TextSize = 16,
                BorderSizePixel = 0,
                AutoButtonColor = false
            })
            
            self:CreateCorner(restoreBtn, 15)
            self:CreateStroke(restoreBtn, self.Colors.OutlinePrimary, 3)
            self:CreateGradient(restoreBtn, nil, 0, true)
            
            restoreBtn.MouseButton1Click:Connect(function()
                window.MainFrame.Visible = true
                self:Tween(window.MainFrame, {Size = UDim2.new(0, 1000, 0, 700)}, self.Animations.Slow, Enum.EasingStyle.Back)
                restoreBtn:Destroy()
            end)
        end)
    end)
    
    window.CloseBtn.MouseButton1Click:Connect(function()
        self:Tween(window.MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }, self.Animations.Slow, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            window.ScreenGui:Destroy()
        end)
    end)
    
    -- Content Title
    window.ContentTitle = self:CreateInstance("TextLabel", {
        Name = "ContentTitle",
        Parent = window.ContentHeader,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 30, 0, 0),
        Size = UDim2.new(1, -150, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "Welcome",
        TextColor3 = self.Colors.Text,
        TextSize = 24,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextStrokeTransparency = 0.7,
        TextStrokeColor3 = self.Colors.Secondary
    })
    
    -- Content Container
    window.ContentContainer = self:CreateInstance("ScrollingFrame", {
        Name = "ContentContainer",
        Parent = window.ContentArea,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 30, 0, 100),
        Size = UDim2.new(1, -60, 1, -120),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 8,
        ScrollBarImageColor3 = self.Colors.Secondary,
        BorderSizePixel = 0
    })
    
    local contentLayout = self:CreateInstance("UIListLayout", {
        Parent = window.ContentContainer,
        Padding = UDim.new(0, 25),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        window.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 40)
    end)
    
    -- Make window draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    window.ContentHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.MainFrame.Position
            
            self:Tween(window.MainFrame, {BackgroundColor3 = self.Colors.PrimaryMedium}, self.Animations.Fast)
            self:Tween(window.MainGlow, {BackgroundTransparency = 0.3}, self.Animations.Fast)
        end
    end)
    
    window.ContentHeader.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            self:Tween(window.MainFrame, {BackgroundColor3 = self.Colors.Primary}, self.Animations.Fast)
            self:Tween(window.MainGlow, {BackgroundTransparency = 0.7}, self.Animations.Fast)
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
            window.MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Store references
    window.Tabs = {}
    window.CurrentTab = nil
    
    -- Tab Creation Function
    function window:CreateTab(name, icon)
        local tab = {}
        
        -- Navigation Button
        tab.NavButton = Library:CreateInstance("TextButton", {
            Name = name .. "NavButton",
            Parent = self.NavContainer,
            BackgroundColor3 = Library.Colors.PrimaryMedium,
            Size = UDim2.new(1, -20, 0, 50),
            Position = UDim2.new(0, 10, 0, 0),
            Font = Enum.Font.GothamSemibold,
            Text = "",
            TextColor3 = Library.Colors.TextSecondary,
            TextSize = 16,
            BorderSizePixel = 0,
            AutoButtonColor = false
        })
        
        Library:CreateCorner(tab.NavButton, 15)
        Library:CreateStroke(tab.NavButton, Library.Colors.OutlineSecondary, 2, 0.5)
        
        -- Tab gradient
        tab.Gradient = Library:CreateGradient(tab.NavButton, {
            ColorSequenceKeypoint.new(0, Library.Colors.PrimaryMedium),
            ColorSequenceKeypoint.new(1, Library.Colors.PrimaryLight)
        }, 45)
        
        -- Selection indicator
        tab.SelectionIndicator = Library:CreateInstance("Frame", {
            Name = "SelectionIndicator",
            Parent = tab.NavButton,
            BackgroundColor3 = Library.Colors.Secondary,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 0, 1, 0),
            BorderSizePixel = 0
        })
        
        Library:CreateCorner(tab.SelectionIndicator, 15)
        
        -- Icon
        tab.Icon = Library:CreateInstance("TextLabel", {
            Name = "Icon",
            Parent = tab.NavButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 20, 0, 0),
            Size = UDim2.new(0, 30, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = icon or "⚙️",
            TextColor3 = Library.Colors.TextSecondary,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Center
        })
        
        -- Label
        tab.Label = Library:CreateInstance("TextLabel", {
            Name = "Label",
            Parent = tab.NavButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 60, 0, 0),
            Size = UDim2.new(1, -60, 1, 0),
            Font = Enum.Font.GothamSemibold,
            Text = name,
            TextColor3 = Library.Colors.TextSecondary,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        -- Content Frame
        tab.Content = Library:CreateInstance("Frame", {
            Name = name .. "Content",
            Parent = self.ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            Visible = false,
            BorderSizePixel = 0
        })
        
        local tabLayout = Library:CreateInstance("UIListLayout", {
            Parent = tab.Content,
            Padding = UDim.new(0, 20),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tab.Content.Size = UDim2.new(1, 0, 0, tabLayout.AbsoluteContentSize.Y)
        end)
        
        -- Enhanced Tab Hover Effects
        local tabGlow = nil
        
        tab.NavButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= tab then
                tabGlow = Library:CreateGlow(tab.NavButton, Library.Colors.SecondaryGlow, 6)
                Library:Tween(tab.NavButton, {BackgroundColor3 = Library.Colors.Hover}, Library.Animations.Fast)
                Library:Tween(tab.Icon, {TextColor3 = Library.Colors.Accent}, Library.Animations.Fast)
                Library:Tween(tab.Label, {TextColor3 = Library.Colors.Accent}, Library.Animations.Fast)
                Library:Tween(tab.NavButton.UIStroke, {Color = Library.Colors.OutlinePrimary, Thickness = 3}, Library.Animations.Fast)
                
                -- Animate gradient
                Library:AnimateGradient(tab.Gradient)
            end
        end)
        
        tab.NavButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= tab then
                if tabGlow then tabGlow:Destroy() end
                Library:Tween(tab.NavButton, {BackgroundColor3 = Library.Colors.PrimaryMedium}, Library.Animations.Fast)
                Library:Tween(tab.Icon, {TextColor3 = Library.Colors.TextSecondary}, Library.Animations.Fast)
                Library:Tween(tab.Label, {TextColor3 = Library.Colors.TextSecondary}, Library.Animations.Fast)
                Library:Tween(tab.NavButton.UIStroke, {Color = Library.Colors.OutlineSecondary, Thickness = 2}, Library.Animations.Fast)
            end
        end)
        
        tab.NavButton.MouseButton1Click:Connect(function()
            -- Create ripple effect
            local mousePos = UserInputService:GetMouseLocation()
            local buttonPos = tab.NavButton.AbsolutePosition
            local relativePos = Vector2.new(mousePos.X - buttonPos.X, mousePos.Y - buttonPos.Y)
            Library:CreateRipple(tab.NavButton, relativePos)
            
            self:SelectTab(tab)
        end)
        
        -- Store tab
        self.Tabs[name] = tab
        
        -- Select first tab
        if not self.CurrentTab then
            self:SelectTab(tab)
        end
        
        -- Component creation functions
        function tab:CreateSection(title)
            local section = {}
            
            section.Frame = Library:CreateInstance("Frame", {
                Name = title .. "Section",
                Parent = self.Content,
                BackgroundColor3 = Library.Colors.PrimaryMedium,
                Size = UDim2.new(1, 0, 0, 0),
                BorderSizePixel = 0
            })
            
            Library:CreateCorner(section.Frame, 18)
            Library:CreateStroke(section.Frame, Library.Colors.OutlinePrimary, 2, 0.3)
            
            -- Section gradient
            section.Gradient = Library:CreateGradient(section.Frame, {
                ColorSequenceKeypoint.new(0, Library.Colors.PrimaryMedium),
                ColorSequenceKeypoint.new(0.5, Library.Colors.PrimaryLight),
                ColorSequenceKeypoint.new(1, Library.Colors.PrimaryMedium)
            }, 90)
            
            -- Section glow
            section.Glow = Library:CreateGlow(section.Frame, Library.Colors.SecondaryDark, 4)
            
            -- Header
            section.Header = Library:CreateInstance("Frame", {
                Name = "Header",
                Parent = section.Frame,
                BackgroundColor3 = Library.Colors.Secondary,
                Size = UDim2.new(1, 0, 0, 60),
                BorderSizePixel = 0
            })
            
            Library:CreateCorner(section.Header, 18)
            Library:CreateStroke(section.Header, Library.Colors.OutlinePrimary, 2)
            
            -- Header gradient
            section.HeaderGradient = Library:CreateGradient(section.Header, {
                ColorSequenceKeypoint.new(0, Library.Colors.Secondary),
                ColorSequenceKeypoint.new(1, Library.Colors.SecondaryLight)
            }, 45, true)
            
            -- Title
            section.Title = Library:CreateInstance("TextLabel", {
                Name = "Title",
                Parent = section.Header,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 25, 0, 0),
                Size = UDim2.new(1, -50, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = title,
                TextColor3 = Library.Colors.Text,
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextStrokeTransparency = 0.5,
                TextStrokeColor3 = Library.Colors.Primary
            })
            
            -- Container
            section.Container = Library:CreateInstance("Frame", {
                Name = "Container",
                Parent = section.Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 25, 0, 80),
                Size = UDim2.new(1, -50, 1, -100),
                BorderSizePixel = 0
            })
            
            local sectionLayout = Library:CreateInstance("UIListLayout", {
                Parent = section.Container,
                Padding = UDim.new(0, 15),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                section.Frame.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y + 100)
            end)
            
            -- Component creation functions
            function section:CreateToggle(name, default, callback)
                local toggle = {}
                
                toggle.Frame = Library:CreateInstance("Frame", {
                    Name = name .. "Toggle",
                    Parent = self.Container,
                    BackgroundColor3 = Library.Colors.PrimaryLight,
                    Size = UDim2.new(1, 0, 0, 45),
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(toggle.Frame, 12)
                Library:CreateStroke(toggle.Frame, Library.Colors.OutlineSecondary, 2, 0.5)
                
                -- Toggle gradient
                toggle.Gradient = Library:CreateGradient(toggle.Frame, {
                    ColorSequenceKeypoint.new(0, Library.Colors.PrimaryLight),
                    ColorSequenceKeypoint.new(1, Library.Colors.PrimaryMedium)
                }, 45)
                
                toggle.Button = Library:CreateInstance("TextButton", {
                    Name = "Button",
                    Parent = toggle.Frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    BorderSizePixel = 0
                })
                
                -- Toggle switch
                toggle.Switch = Library:CreateInstance("Frame", {
                    Name = "Switch",
                    Parent = toggle.Frame,
                    BackgroundColor3 = default and Library.Colors.Secondary or Library.Colors.PrimaryDark,
                    Position = UDim2.new(1, -60, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 50, 0, 25),
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(toggle.Switch, 12)
                Library:CreateStroke(toggle.Switch, default and Library.Colors.OutlinePrimary or Library.Colors.OutlineSecondary, 2)
                
                -- Switch gradient
                toggle.SwitchGradient = Library:CreateGradient(toggle.Switch, default and {
                    ColorSequenceKeypoint.new(0, Library.Colors.Secondary),
                    ColorSequenceKeypoint.new(1, Library.Colors.SecondaryLight)
                } or {
                    ColorSequenceKeypoint.new(0, Library.Colors.PrimaryDark),
                    ColorSequenceKeypoint.new(1, Library.Colors.PrimaryMedium)
                }, 45)
                
                -- Switch circle
                toggle.Circle = Library:CreateInstance("Frame", {
                    Name = "Circle",
                    Parent = toggle.Switch,
                    BackgroundColor3 = Library.Colors.Text,
                    Position = default and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 21, 0, 21),
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(toggle.Circle, 10)
                Library:CreateStroke(toggle.Circle, Library.Colors.OutlineSecondary, 1)
                
                -- Circle glow
                toggle.CircleGlow = Library:CreateGlow(toggle.Circle, Library.Colors.AccentBright, 2)
                
                toggle.Label = Library:CreateInstance("TextLabel", {
                    Name = "Label",
                    Parent = toggle.Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 20, 0, 0),
                    Size = UDim2.new(1, -90, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = Library.Colors.Text,
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                toggle.Value = default or false
                
                -- Enhanced toggle functionality
                toggle.Button.MouseButton1Click:Connect(function()
                    toggle.Value = not toggle.Value
                    
                    -- Create ripple effect
                    local mousePos = UserInputService:GetMouseLocation()
                    local buttonPos = toggle.Frame.AbsolutePosition
                    local relativePos = Vector2.new(mousePos.X - buttonPos.X, mousePos.Y - buttonPos.Y)
                    Library:CreateRipple(toggle.Frame, relativePos)
                    
                    if toggle.Value then
                        Library:Tween(toggle.Switch, {BackgroundColor3 = Library.Colors.Secondary}, Library.Animations.Normal)
                        Library:Tween(toggle.Circle, {Position = UDim2.new(1, -23, 0.5, 0)}, Library.Animations.Normal, Enum.EasingStyle.Back)
                        Library:Tween(toggle.Switch.UIStroke, {Color = Library.Colors.OutlinePrimary}, Library.Animations.Normal)
                        
                        -- Update gradient
                        toggle.SwitchGradient.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Library.Colors.Secondary),
                            ColorSequenceKeypoint.new(1, Library.Colors.SecondaryLight)
                        })
                        Library:AnimateGradient(toggle.SwitchGradient)
                    else
                        Library:Tween(toggle.Switch, {BackgroundColor3 = Library.Colors.PrimaryDark}, Library.Animations.Normal)
                        Library:Tween(toggle.Circle, {Position = UDim2.new(0, 2, 0.5, 0)}, Library.Animations.Normal, Enum.EasingStyle.Back)
                        Library:Tween(toggle.Switch.UIStroke, {Color = Library.Colors.OutlineSecondary}, Library.Animations.Normal)
                        
                        -- Update gradient
                        toggle.SwitchGradient.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Library.Colors.PrimaryDark),
                            ColorSequenceKeypoint.new(1, Library.Colors.PrimaryMedium)
                        })
                    end
                    
                    if callback then
                        callback(toggle.Value)
                    end
                end)
                
                -- Hover effects
                local toggleGlow = nil
                
                toggle.Button.MouseEnter:Connect(function()
                    toggleGlow = Library:CreateGlow(toggle.Frame, Library.Colors.SecondaryGlow, 4)
                    Library:Tween(toggle.Frame, {BackgroundColor3 = Library.Colors.Hover}, Library.Animations.Fast)
                    Library:Tween(toggle.Frame.UIStroke, {Color = Library.Colors.OutlinePrimary, Thickness = 3}, Library.Animations.Fast)
                    Library:AnimateGradient(toggle.Gradient)
                end)
                
                toggle.Button.MouseLeave:Connect(function()
                    if toggleGlow then toggleGlow:Destroy() end
                    Library:Tween(toggle.Frame, {BackgroundColor3 = Library.Colors.PrimaryLight}, Library.Animations.Fast)
                    Library:Tween(toggle.Frame.UIStroke, {Color = Library.Colors.OutlineSecondary, Thickness = 2}, Library.Animations.Fast)
                end)
                
                return toggle
            end
            
            function section:CreateSlider(name, min, max, default, callback)
                local slider = {}
                
                slider.Frame = Library:CreateInstance("Frame", {
                    Name = name .. "Slider",
                    Parent = self.Container,
                    BackgroundColor3 = Library.Colors.PrimaryLight,
                    Size = UDim2.new(1, 0, 0, 70),
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(slider.Frame, 12)
                Library:CreateStroke(slider.Frame, Library.Colors.OutlineSecondary, 2, 0.5)
                
                -- Slider gradient
                slider.Gradient = Library:CreateGradient(slider.Frame, {
                    ColorSequenceKeypoint.new(0, Library.Colors.PrimaryLight),
                    ColorSequenceKeypoint.new(1, Library.Colors.PrimaryMedium)
                }, 45)
                
                slider.Header = Library:CreateInstance("Frame", {
                    Name = "Header",
                    Parent = slider.Frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 35),
                    BorderSizePixel = 0
                })
                
                slider.Label = Library:CreateInstance("TextLabel", {
                    Name = "Label",
                    Parent = slider.Header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 20, 0, 0),
                    Size = UDim2.new(1, -100, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = Library.Colors.Text,
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                slider.ValueLabel = Library:CreateInstance("TextLabel", {
                    Name = "ValueLabel",
                    Parent = slider.Header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -80, 0, 0),
                    Size = UDim2.new(0, 60, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(default),
                    TextColor3 = Library.Colors.Secondary,
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    TextStrokeTransparency = 0.7,
                    TextStrokeColor3 = Library.Colors.Primary
                })
                
                -- Slider track
                slider.Track = Library:CreateInstance("Frame", {
                    Name = "Track",
                    Parent = slider.Frame,
                    BackgroundColor3 = Library.Colors.PrimaryDark,
                    Position = UDim2.new(0, 20, 0, 45),
                    Size = UDim2.new(1, -40, 0, 10),
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(slider.Track, 5)
                Library:CreateStroke(slider.Track, Library.Colors.OutlineSecondary, 1, 0.5)
                
                -- Slider fill
                slider.Fill = Library:CreateInstance("Frame", {
                    Name = "Fill",
                    Parent = slider.Track,
                    BackgroundColor3 = Library.Colors.Secondary,
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(slider.Fill, 5)
                Library:CreateStroke(slider.Fill, Library.Colors.OutlinePrimary, 1)
                
                -- Fill gradient
                slider.FillGradient = Library:CreateGradient(slider.Fill, {
                    ColorSequenceKeypoint.new(0, Library.Colors.Secondary),
                    ColorSequenceKeypoint.new(1, Library.Colors.SecondaryLight)
                }, 0, true)
                
                -- Slider handle
                slider.Handle = Library:CreateInstance("Frame", {
                    Name = "Handle",
                    Parent = slider.Track,
                    BackgroundColor3 = Library.Colors.Text,
                    Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(slider.Handle, 8)
                Library:CreateStroke(slider.Handle, Library.Colors.OutlinePrimary, 2)
                
                -- Handle glow
                slider.HandleGlow = Library:CreateGlow(slider.Handle, Library.Colors.SecondaryGlow, 3)
                
                slider.Button = Library:CreateInstance("TextButton", {
                    Name = "Button",
                    Parent = slider.Track,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    BorderSizePixel = 0
                })
                
                local currentValue = default
                local dragging = false
                
                local function updateSlider(input)
                    local pos = math.clamp((input.Position.X - slider.Track.AbsolutePosition.X) / slider.Track.AbsoluteSize.X, 0, 1)
                    currentValue = math.floor(min + ((max - min) * pos) + 0.5)
                    
                    Library:Tween(slider.Fill, {Size = UDim2.new(pos, 0, 1, 0)}, Library.Animations.VeryFast)
                    Library:Tween(slider.Handle, {Position = UDim2.new(pos, -8, 0.5, -8)}, Library.Animations.VeryFast)
                    slider.ValueLabel.Text = tostring(currentValue)
                    
                    if callback then
                        callback(currentValue)
                    end
                end
                
                slider.Button.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateSlider(input)
                        
                        -- Visual feedback
                        Library:Tween(slider.Handle, {Size = UDim2.new(0, 20, 0, 20)}, Library.Animations.Fast)
                        Library:Tween(slider.HandleGlow, {BackgroundTransparency = 0.3}, Library.Animations.Fast)
                    end
                end)
                
                slider.Button.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                        Library:Tween(slider.Handle, {Size = UDim2.new(0, 16, 0, 16)}, Library.Animations.Fast)
                        Library:Tween(slider.HandleGlow, {BackgroundTransparency = 0.7}, Library.Animations.Fast)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                -- Hover effects
                local sliderGlow = nil
                
                slider.Button.MouseEnter:Connect(function()
                    sliderGlow = Library:CreateGlow(slider.Frame, Library.Colors.SecondaryGlow, 4)
                    Library:Tween(slider.Frame, {BackgroundColor3 = Library.Colors.Hover}, Library.Animations.Fast)
                    Library:Tween(slider.Frame.UIStroke, {Color = Library.Colors.OutlinePrimary, Thickness = 3}, Library.Animations.Fast)
                    Library:AnimateGradient(slider.Gradient)
                end)
                
                slider.Button.MouseLeave:Connect(function()
                    if not dragging then
                        if sliderGlow then sliderGlow:Destroy() end
                        Library:Tween(slider.Frame, {BackgroundColor3 = Library.Colors.PrimaryLight}, Library.Animations.Fast)
                        Library:Tween(slider.Frame.UIStroke, {Color = Library.Colors.OutlineSecondary, Thickness = 2}, Library.Animations.Fast)
                    end
                end)
                
                return slider
            end
            
            function section:CreateDropdown(name, options, default, callback)
                local dropdown = {}
                
                dropdown.Frame = Library:CreateInstance("Frame", {
                    Name = name .. "Dropdown",
                    Parent = self.Container,
                    BackgroundColor3 = Library.Colors.PrimaryLight,
                    Size = UDim2.new(1, 0, 0, 45),
                    ClipsDescendants = true,
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(dropdown.Frame, 12)
                Library:CreateStroke(dropdown.Frame, Library.Colors.OutlineSecondary, 2, 0.5)
                
                -- Dropdown gradient
                dropdown.Gradient = Library:CreateGradient(dropdown.Frame, {
                    ColorSequenceKeypoint.new(0, Library.Colors.PrimaryLight),
                    ColorSequenceKeypoint.new(1, Library.Colors.PrimaryMedium)
                }, 45)
                
                dropdown.Header = Library:CreateInstance("TextButton", {
                    Name = "Header",
                    Parent = dropdown.Frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 45),
                    Font = Enum.Font.Gotham,
                    Text = "",
                    TextColor3 = Library.Colors.Text,
                    TextSize = 16,
                    BorderSizePixel = 0,
                    AutoButtonColor = false
                })
                
                dropdown.Label = Library:CreateInstance("TextLabel", {
                    Name = "Label",
                    Parent = dropdown.Header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 20, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = Library.Colors.Text,
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                dropdown.Selected = Library:CreateInstance("TextLabel", {
                    Name = "Selected",
                    Parent = dropdown.Header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(0.5, -40, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = default or "Select...",
                    TextColor3 = default and Library.Colors.Secondary or Library.Colors.TextMuted,
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                dropdown.Arrow = Library:CreateInstance("TextLabel", {
                    Name = "Arrow",
                    Parent = dropdown.Header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -35, 0, 0),
                    Size = UDim2.new(0, 30, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = "▼",
                    TextColor3 = Library.Colors.Secondary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextStrokeTransparency = 0.7,
                    TextStrokeColor3 = Library.Colors.Primary
                })
                
                dropdown.OptionsContainer = Library:CreateInstance("Frame", {
                    Name = "OptionsContainer",
                    Parent = dropdown.Frame,
                    BackgroundColor3 = Library.Colors.PrimaryMedium,
                    Position = UDim2.new(0, 0, 0, 45),
                    Size = UDim2.new(1, 0, 0, #options * 40),
                    Visible = false,
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(dropdown.OptionsContainer, 12)
                Library:CreateStroke(dropdown.OptionsContainer, Library.Colors.OutlinePrimary, 2, 0.3)
                
                -- Options gradient
                dropdown.OptionsGradient = Library:CreateGradient(dropdown.OptionsContainer, {
                    ColorSequenceKeypoint.new(0, Library.Colors.PrimaryMedium),
                    ColorSequenceKeypoint.new(1, Library.Colors.PrimaryDark)
                }, 90)
                
                local optionsLayout = Library:CreateInstance("UIListLayout", {
                    Parent = dropdown.OptionsContainer,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                dropdown.IsOpen = false
                
                dropdown.Header.MouseButton1Click:Connect(function()
                    dropdown.IsOpen = not dropdown.IsOpen
                    
                    -- Create ripple effect
                    local mousePos = UserInputService:GetMouseLocation()
                    local buttonPos = dropdown.Frame.AbsolutePosition
                    local relativePos = Vector2.new(mousePos.X - buttonPos.X, mousePos.Y - buttonPos.Y)
                    Library:CreateRipple(dropdown.Frame, relativePos)
                    
                    if dropdown.IsOpen then
                        Library:Tween(dropdown.Arrow, {Rotation = 180}, Library.Animations.Normal, Enum.EasingStyle.Back)
                        Library:Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 45 + #options * 40)}, Library.Animations.Normal, Enum.EasingStyle.Quart)
                        dropdown.OptionsContainer.Visible = true
                        Library:AnimateGradient(dropdown.OptionsGradient)
                    else
                        Library:Tween(dropdown.Arrow, {Rotation = 0}, Library.Animations.Normal, Enum.EasingStyle.Back)
                        Library:Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 45)}, Library.Animations.Normal, Enum.EasingStyle.Quart)
                        dropdown.OptionsContainer.Visible = false
                    end
                end)
                
                for i, option in ipairs(options) do
                    local optionBtn = Library:CreateInstance("TextButton", {
                        Name = option .. "Option",
                        Parent = dropdown.OptionsContainer,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 40),
                        Font = Enum.Font.Gotham,
                        Text = option,
                        TextColor3 = Library.Colors.TextSecondary,
                        TextSize = 16,
                        BorderSizePixel = 0,
                        AutoButtonColor = false
                    })
                    
                    local optionGlow = nil
                    
                    optionBtn.MouseEnter:Connect(function()
                        optionGlow = Library:CreateGlow(optionBtn, Library.Colors.SecondaryGlow, 2)
                        Library:Tween(optionBtn, {
                            BackgroundTransparency = 0.8, 
                            BackgroundColor3 = Library.Colors.Secondary,
                            TextColor3 = Library.Colors.Text
                        }, Library.Animations.Fast)
                    end)
                    
                    optionBtn.MouseLeave:Connect(function()
                        if optionGlow then optionGlow:Destroy() end
                        Library:Tween(optionBtn, {
                            BackgroundTransparency = 1,
                            TextColor3 = Library.Colors.TextSecondary
                        }, Library.Animations.Fast)
                    end)
                    
                    optionBtn.MouseButton1Click:Connect(function()
                        dropdown.Selected.Text = option
                        dropdown.Selected.TextColor3 = Library.Colors.Secondary
                        dropdown.IsOpen = false
                        
                        Library:Tween(dropdown.Arrow, {Rotation = 0}, Library.Animations.Normal, Enum.EasingStyle.Back)
                        Library:Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 45)}, Library.Animations.Normal, Enum.EasingStyle.Quart)
                        dropdown.OptionsContainer.Visible = false
                        
                        if callback then
                            callback(option)
                        end
                    end)
                end
                
                -- Hover effects
                local dropdownGlow = nil
                
                dropdown.Header.MouseEnter:Connect(function()
                    dropdownGlow = Library:CreateGlow(dropdown.Frame, Library.Colors.SecondaryGlow, 4)
                    Library:Tween(dropdown.Frame, {BackgroundColor3 = Library.Colors.Hover}, Library.Animations.Fast)
                    Library:Tween(dropdown.Frame.UIStroke, {Color = Library.Colors.OutlinePrimary, Thickness = 3}, Library.Animations.Fast)
                    Library:AnimateGradient(dropdown.Gradient)
                end)
                
                dropdown.Header.MouseLeave:Connect(function()
                    if not dropdown.IsOpen then
                        if dropdownGlow then dropdownGlow:Destroy() end
                        Library:Tween(dropdown.Frame, {BackgroundColor3 = Library.Colors.PrimaryLight}, Library.Animations.Fast)
                        Library:Tween(dropdown.Frame.UIStroke, {Color = Library.Colors.OutlineSecondary, Thickness = 2}, Library.Animations.Fast)
                    end
                end)
                
                return dropdown
            end
            
            function section:CreateButton(name, callback)
                local button = {}
                
                button.Frame = Library:CreateInstance("TextButton", {
                    Name = name .. "Button",
                    Parent = self.Container,
                    BackgroundColor3 = Library.Colors.Secondary,
                    Size = UDim2.new(1, 0, 0, 45),
                    Font = Enum.Font.GothamSemibold,
                    Text = name,
                    TextColor3 = Library.Colors.Text,
                    TextSize = 16,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    TextStrokeTransparency = 0.7,
                    TextStrokeColor3 = Library.Colors.Primary
                })
                
                Library:CreateCorner(button.Frame, 12)
                Library:CreateStroke(button.Frame, Library.Colors.OutlinePrimary, 2)
                
                -- Button gradient
                button.Gradient = Library:CreateGradient(button.Frame, {
                    ColorSequenceKeypoint.new(0, Library.Colors.Secondary),
                    ColorSequenceKeypoint.new(0.5, Library.Colors.SecondaryLight),
                    ColorSequenceKeypoint.new(1, Library.Colors.Secondary)
                }, 45, true)
                
                -- Button glow
                button.Glow = Library:CreateGlow(button.Frame, Library.Colors.SecondaryGlow, 4)
                
                button.Frame.MouseEnter:Connect(function()
                    Library:Tween(button.Frame, {BackgroundColor3 = Library.Colors.SecondaryLight}, Library.Animations.Fast)
                    Library:Tween(button.Frame.UIStroke, {Color = Library.Colors.OutlineGlow, Thickness = 3}, Library.Animations.Fast)
                    Library:Tween(button.Frame, {Size = UDim2.new(1, 0, 0, 48)}, Library.Animations.Fast)
                    Library:Tween(button.Glow, {BackgroundTransparency = 0.4}, Library.Animations.Fast)
                end)
                
                button.Frame.MouseLeave:Connect(function()
                    Library:Tween(button.Frame, {BackgroundColor3 = Library.Colors.Secondary}, Library.Animations.Fast)
                    Library:Tween(button.Frame.UIStroke, {Color = Library.Colors.OutlinePrimary, Thickness = 2}, Library.Animations.Fast)
                    Library:Tween(button.Frame, {Size = UDim2.new(1, 0, 0, 45)}, Library.Animations.Fast)
                    Library:Tween(button.Glow, {BackgroundTransparency = 0.7}, Library.Animations.Fast)
                end)
                
                button.Frame.MouseButton1Down:Connect(function()
                    Library:Tween(button.Frame, {Size = UDim2.new(1, -4, 0, 41)}, Library.Animations.VeryFast)
                    Library:Tween(button.Frame, {BackgroundColor3 = Library.Colors.SecondaryDark}, Library.Animations.VeryFast)
                end)
                
                button.Frame.MouseButton1Up:Connect(function()
                    Library:Tween(button.Frame, {Size = UDim2.new(1, 0, 0, 48)}, Library.Animations.VeryFast)
                    Library:Tween(button.Frame, {BackgroundColor3 = Library.Colors.SecondaryLight}, Library.Animations.VeryFast)
                end)
                
                button.Frame.MouseButton1Click:Connect(function()
                    -- Create ripple effect
                    local mousePos = UserInputService:GetMouseLocation()
                    local buttonPos = button.Frame.AbsolutePosition
                    local relativePos = Vector2.new(mousePos.X - buttonPos.X, mousePos.Y - buttonPos.Y)
                    Library:CreateRipple(button.Frame, relativePos)
                    
                    if callback then
                        callback()
                    end
                end)
                
                return button
            end
            
            function section:CreateTextBox(name, placeholder, callback)
                local textbox = {}
                
                textbox.Frame = Library:CreateInstance("Frame", {
                    Name = name .. "TextBox",
                    Parent = self.Container,
                    BackgroundColor3 = Library.Colors.PrimaryLight,
                    Size = UDim2.new(1, 0, 0, 45),
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(textbox.Frame, 12)
                Library:CreateStroke(textbox.Frame, Library.Colors.OutlineSecondary, 2, 0.5)
                
                -- TextBox gradient
                textbox.Gradient = Library:CreateGradient(textbox.Frame, {
                    ColorSequenceKeypoint.new(0, Library.Colors.PrimaryLight),
                    ColorSequenceKeypoint.new(1, Library.Colors.PrimaryMedium)
                }, 45)
                
                textbox.Label = Library:CreateInstance("TextLabel", {
                    Name = "Label",
                    Parent = textbox.Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 20, 0, 0),
                    Size = UDim2.new(0.4, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = Library.Colors.Text,
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                textbox.TextBox = Library:CreateInstance("TextBox", {
                    Name = "TextBox",
                    Parent = textbox.Frame,
                    BackgroundColor3 = Library.Colors.PrimaryDark,
                    Position = UDim2.new(0.4, 10, 0, 8),
                    Size = UDim2.new(0.6, -30, 1, -16),
                    Font = Enum.Font.Gotham,
                    PlaceholderText = placeholder or "Enter text...",
                    PlaceholderColor3 = Library.Colors.TextMuted,
                    Text = "",
                    TextColor3 = Library.Colors.Text,
                    TextSize = 14,
                    BorderSizePixel = 0,
                    ClearButtonOnFocus = false
                })
                
                Library:CreateCorner(textbox.TextBox, 8)
                Library:CreateStroke(textbox.TextBox, Library.Colors.OutlineSecondary, 1, 0.5)
                
                -- TextBox glow
                textbox.TextBoxGlow = Library:CreateGlow(textbox.TextBox, Library.Colors.SecondaryGlow, 2)
                textbox.TextBoxGlow.Visible = false
                
                textbox.TextBox.Focused:Connect(function()
                    textbox.TextBoxGlow.Visible = true
                    Library:Tween(textbox.TextBox, {BackgroundColor3 = Library.Colors.PrimaryMedium}, Library.Animations.Fast)
                    Library:Tween(textbox.TextBox.UIStroke, {Color = Library.Colors.OutlinePrimary, Thickness = 2}, Library.Animations.Fast)
                    Library:Tween(textbox.TextBoxGlow, {BackgroundTransparency = 0.5}, Library.Animations.Fast)
                end)
                
                textbox.TextBox.FocusLost:Connect(function()
                    Library:Tween(textbox.TextBox, {BackgroundColor3 = Library.Colors.PrimaryDark}, Library.Animations.Fast)
                    Library:Tween(textbox.TextBox.UIStroke, {Color = Library.Colors.OutlineSecondary, Thickness = 1}, Library.Animations.Fast)
                    Library:Tween(textbox.TextBoxGlow, {BackgroundTransparency = 1}, Library.Animations.Fast, nil, nil, function()
                        textbox.TextBoxGlow.Visible = false
                    end)
                    
                    if callback then
                        callback(textbox.TextBox.Text)
                    end
                end)
                
                -- Hover effects
                local textboxGlow = nil
                
                textbox.Frame.MouseEnter:Connect(function()
                    textboxGlow = Library:CreateGlow(textbox.Frame, Library.Colors.SecondaryGlow, 4)
                    Library:Tween(textbox.Frame, {BackgroundColor3 = Library.Colors.Hover}, Library.Animations.Fast)
                    Library:Tween(textbox.Frame.UIStroke, {Color = Library.Colors.OutlinePrimary, Thickness = 3}, Library.Animations.Fast)
                    Library:AnimateGradient(textbox.Gradient)
                end)
                
                textbox.Frame.MouseLeave:Connect(function()
                    if textboxGlow then textboxGlow:Destroy() end
                    Library:Tween(textbox.Frame, {BackgroundColor3 = Library.Colors.PrimaryLight}, Library.Animations.Fast)
                    Library:Tween(textbox.Frame.UIStroke, {Color = Library.Colors.OutlineSecondary, Thickness = 2}, Library.Animations.Fast)
                end)
                
                return textbox
            end
            
            return section
        end
        
        return tab
    end
    
    -- Enhanced Tab Selection
    function window:SelectTab(tab)
        -- Deselect current tab
        if self.CurrentTab then
            Library:Tween(self.CurrentTab.NavButton, {BackgroundColor3 = Library.Colors.PrimaryMedium}, Library.Animations.Normal)
            Library:Tween(self.CurrentTab.Icon, {TextColor3 = Library.Colors.TextSecondary}, Library.Animations.Normal)
            Library:Tween(self.CurrentTab.Label, {TextColor3 = Library.Colors.TextSecondary}, Library.Animations.Normal)
            Library:Tween(self.CurrentTab.SelectionIndicator, {Size = UDim2.new(0, 0, 1, 0)}, Library.Animations.Normal)
            Library:Tween(self.CurrentTab.NavButton.UIStroke, {Color = Library.Colors.OutlineSecondary, Thickness = 2}, Library.Animations.Normal)
            
            -- Fade out current content
            Library:Tween(self.CurrentTab.Content, {BackgroundTransparency = 1}, Library.Animations.Fast, nil, nil, function()
                self.CurrentTab.Content.Visible = false
            end)
        end
        
        -- Select new tab
        self.CurrentTab = tab
        Library:Tween(tab.NavButton, {BackgroundColor3 = Library.Colors.Active}, Library.Animations.Normal)
        Library:Tween(tab.Icon, {TextColor3 = Library.Colors.Secondary}, Library.Animations.Normal)
        Library:Tween(tab.Label, {TextColor3 = Library.Colors.Text}, Library.Animations.Normal)
        Library:Tween(tab.SelectionIndicator, {Size = UDim2.new(0, 6, 1, 0)}, Library.Animations.Normal, Enum.EasingStyle.Back)
        Library:Tween(tab.NavButton.UIStroke, {Color = Library.Colors.OutlinePrimary, Thickness = 3}, Library.Animations.Normal)
        
        -- Animate tab gradient
        Library:AnimateGradient(tab.Gradient)
        
        -- Fade in new content
        tab.Content.Visible = true
        tab.Content.BackgroundTransparency = 1
        Library:Tween(tab.Content, {BackgroundTransparency = 0}, Library.Animations.Normal)
        
        -- Update content title with animation
        Library:Tween(self.ContentTitle, {TextTransparency = 1}, Library.Animations.Fast, nil, nil, function()
            self.ContentTitle.Text = tab.Label.Text
            Library:Tween(self.ContentTitle, {TextTransparency = 0}, Library.Animations.Fast)
        end)
    end
    
    function window:CreateNotification(title, message, duration, type)
        local notification = {}
        
        local color = Library.Colors.Secondary
        if type == "success" then color = Library.Colors.Success
        elseif type == "error" then color = Library.Colors.Error
        elseif type == "warning" then color = Library.Colors.Warning
        elseif type == "info" then color = Library.Colors.Info
        end
        
        notification.Frame = Library:CreateInstance("Frame", {
            Name = "Notification",
            Parent = self.ScreenGui,
            BackgroundColor3 = Library.Colors.PrimaryMedium,
            Position = UDim2.new(1, -380, 1, 20),
            Size = UDim2.new(0, 360, 0, 100),
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0, 1)
        })
        
        Library:CreateCorner(notification.Frame, 15)
        Library:CreateStroke(notification.Frame, color, 3)
        
        -- Notification gradient
        notification.Gradient = Library:CreateGradient(notification.Frame, {
            ColorSequenceKeypoint.new(0, Library.Colors.PrimaryMedium),
            ColorSequenceKeypoint.new(1, Library.Colors.PrimaryLight)
        }, 45, true)
        
        -- Notification glow
        notification.Glow = Library:CreateGlow(notification.Frame, color, 6)
        
        notification.ColorBar = Library:CreateInstance("Frame", {
            Name = "ColorBar",
            Parent = notification.Frame,
            BackgroundColor3 = color,
            Size = UDim2.new(0, 6, 1, 0),
            BorderSizePixel = 0
        })
        
        Library:CreateCorner(notification.ColorBar, 3)
        
        notification.Title = Library:CreateInstance("TextLabel", {
            Name = "Title",
            Parent = notification.Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 25, 0, 15),
            Size = UDim2.new(1, -50, 0, 30),
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = color,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextStrokeTransparency = 0.7,
            TextStrokeColor3 = Library.Colors.Primary
        })
        
        notification.Message = Library:CreateInstance("TextLabel", {
            Name = "Message",
            Parent = notification.Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 25, 0, 45),
            Size = UDim2.new(1, -50, 0, 40),
            Font = Enum.Font.Gotham,
            Text = message,
            TextColor3 = Library.Colors.Text,
            TextSize = 14,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })
        
        -- Enhanced entrance animation
        Library:Tween(notification.Frame, {Position = UDim2.new(1, -380, 1, -120)}, Library.Animations.Slow, Enum.EasingStyle.Back)
        Library:Tween(notification.Glow, {BackgroundTransparency = 0.4}, Library.Animations.Slow)
        
        task.delay(duration or 4, function()
            Library:Tween(notification.Frame, {
                Position = UDim2.new(1, -380, 1, 20),
                BackgroundTransparency = 1
            }, Library.Animations.Slow, Enum.EasingStyle.Quart, Enum.EasingDirection.In, function()
                notification.Frame:Destroy()
            end)
        end)
        
        return notification
    end
    
    -- Enhanced entrance animation
    window.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    window.MainFrame.BackgroundTransparency = 1
    
    Library:Tween(window.MainFrame, {
        Size = UDim2.new(0, 1000, 0, 700),
        BackgroundTransparency = 0
    }, Library.Animations.VerySlow, Enum.EasingStyle.Back)
    
    Library:Tween(window.MainGlow, {BackgroundTransparency = 0.7}, Library.Animations.VerySlow)
    
    return window
end

return Library
