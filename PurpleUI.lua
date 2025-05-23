--[[
    Reactive Advanced Purple UI Library for Roblox
    Professional Gaming Interface with Connected Tabs and Modern Dark Theme
    
    Usage:
    local Library = loadstring(game:HttpGet("YOUR_GITHUB_URL"))()
    local UI = Library:CreateWindow("Monolith", "v2.1.0")
]]

local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Enhanced Modern Color Palette
Library.Colors = {
    -- Main Colors
    Primary = Color3.fromRGB(147, 51, 234),        -- Deep Purple
    Secondary = Color3.fromRGB(168, 85, 247),      -- Lighter Purple
    Accent = Color3.fromRGB(196, 181, 253),        -- Light Purple
    
    -- Modern Dark Backgrounds
    Background = Color3.fromRGB(9, 9, 11),         -- Almost Black
    BackgroundSecondary = Color3.fromRGB(15, 15, 17), -- Very Dark
    BackgroundTertiary = Color3.fromRGB(20, 20, 23),  -- Dark
    Sidebar = Color3.fromRGB(12, 12, 14),          -- Sidebar Dark
    ContentArea = Color3.fromRGB(16, 16, 18),      -- Content Background
    
    -- Text Colors
    Text = Color3.fromRGB(255, 255, 255),          -- Pure White
    TextSecondary = Color3.fromRGB(161, 161, 170), -- Light Gray
    TextMuted = Color3.fromRGB(113, 113, 122),     -- Muted Gray
    TextDark = Color3.fromRGB(82, 82, 91),         -- Dark Gray
    
    -- State Colors
    Success = Color3.fromRGB(34, 197, 94),         -- Green
    Warning = Color3.fromRGB(251, 191, 36),        -- Yellow
    Error = Color3.fromRGB(239, 68, 68),           -- Red
    
    -- Border Colors
    Border = Color3.fromRGB(39, 39, 42),           -- Dark Border
    BorderLight = Color3.fromRGB(63, 63, 70),      -- Light Border
    BorderAccent = Color3.fromRGB(147, 51, 234),   -- Purple Border
    
    -- Interactive States
    Hover = Color3.fromRGB(24, 24, 27),            -- Hover State
    Active = Color3.fromRGB(30, 30, 33),           -- Active State
    Selected = Color3.fromRGB(147, 51, 234),       -- Selected State
}

-- Enhanced Icons
Library.Icons = {
    Movement = "🎮",
    Combat = "⚔️",
    Visual = "👁️",
    Settings = "⚙️",
    Skins = "🎨",
    Player = "👤",
    Misc = "📦",
    Home = "🏠",
    Search = "🔍",
    Close = "✕",
    Minimize = "−",
    ChevronRight = "❯",
    ChevronDown = "❯",
    Toggle = "●",
    Slider = "━",
    Check = "✓",
    Cross = "✗",
}

-- Enhanced Utility Functions
function Library:Tween(object, properties, duration, style, direction, callback)
    local tweenInfo = TweenInfo.new(
        duration or 0.25,
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
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

function Library:CreateStroke(parent, color, thickness, transparency)
    return self:CreateInstance("UIStroke", {
        Color = color or self.Colors.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = parent
    })
end

function Library:CreateGradient(parent, colors, rotation)
    return self:CreateInstance("UIGradient", {
        Color = ColorSequence.new(colors or {
            ColorSequenceKeypoint.new(0, self.Colors.Primary),
            ColorSequenceKeypoint.new(1, self.Colors.Secondary)
        }),
        Rotation = rotation or 0,
        Parent = parent
    })
end

function Library:CreateDropShadow(parent, size, intensity)
    local shadow = self:CreateInstance("Frame", {
        Name = "DropShadow",
        Parent = parent.Parent,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1 - (intensity or 0.4),
        Position = UDim2.new(0, size or 6, 0, size or 6),
        Size = parent.Size,
        ZIndex = parent.ZIndex - 1,
        BorderSizePixel = 0
    })
    
    self:CreateCorner(shadow, 12)
    return shadow
end

-- Main Window Creation
function Library:CreateWindow(title, version)
    local window = {}
    setmetatable(window, self)
    
    -- Create ScreenGui
    window.ScreenGui = self:CreateInstance("ScreenGui", {
        Name = "ReactiveAdvancedUI_" .. math.random(1000, 9999),
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Main Container with modern styling
    window.MainFrame = self:CreateInstance("Frame", {
        Name = "MainFrame",
        Parent = window.ScreenGui,
        BackgroundColor3 = self.Colors.Background,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 950, 0, 650),
        BorderSizePixel = 0,
        ClipsDescendants = false
    })
    
    self:CreateCorner(window.MainFrame, 16)
    self:CreateStroke(window.MainFrame, self.Colors.Border, 1, 0.3)
    self:CreateDropShadow(window.MainFrame, 8, 0.6)
    
    -- Sidebar with enhanced styling
    window.Sidebar = self:CreateInstance("Frame", {
        Name = "Sidebar",
        Parent = window.MainFrame,
        BackgroundColor3 = self.Colors.Sidebar,
        Size = UDim2.new(0, 220, 1, 0),
        BorderSizePixel = 0
    })
    
    self:CreateCorner(window.Sidebar, 16)
    
    -- Sidebar right border to separate from content
    window.SidebarBorder = self:CreateInstance("Frame", {
        Name = "SidebarBorder",
        Parent = window.Sidebar,
        BackgroundColor3 = self.Colors.Border,
        Position = UDim2.new(1, -1, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BorderSizePixel = 0
    })
    
    -- Header section in sidebar
    window.Header = self:CreateInstance("Frame", {
        Name = "Header",
        Parent = window.Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 80),
        BorderSizePixel = 0
    })
    
    -- Logo container with background
    window.LogoContainer = self:CreateInstance("Frame", {
        Name = "LogoContainer",
        Parent = window.Header,
        BackgroundColor3 = self.Colors.BackgroundSecondary,
        Position = UDim2.new(0, 15, 0, 15),
        Size = UDim2.new(1, -30, 0, 50),
        BorderSizePixel = 0
    })
    
    self:CreateCorner(window.LogoContainer, 10)
    self:CreateStroke(window.LogoContainer, self.Colors.BorderAccent, 1, 0.5)
    
    -- Logo/Title with icon
    window.Logo = self:CreateInstance("TextLabel", {
        Name = "Logo",
        Parent = window.LogoContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 8),
        Size = UDim2.new(1, -30, 0, 22),
        Font = Enum.Font.GothamBold,
        Text = "🔮 " .. (title or "Advanced UI"),
        TextColor3 = self.Colors.Primary,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Version with better styling
    window.Version = self:CreateInstance("TextLabel", {
        Name = "Version",
        Parent = window.LogoContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 28),
        Size = UDim2.new(1, -30, 0, 14),
        Font = Enum.Font.Gotham,
        Text = version or "v1.0.0",
        TextColor3 = self.Colors.TextMuted,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Navigation Container with enhanced styling
    window.NavContainer = self:CreateInstance("ScrollingFrame", {
        Name = "NavContainer",
        Parent = window.Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 90),
        Size = UDim2.new(1, 0, 1, -90),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.Colors.Primary,
        BorderSizePixel = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y
    })
    
    local navLayout = self:CreateInstance("UIListLayout", {
        Parent = window.NavContainer,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        window.NavContainer.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Main Content Area with modern styling
    window.ContentArea = self:CreateInstance("Frame", {
        Name = "ContentArea",
        Parent = window.MainFrame,
        BackgroundColor3 = self.Colors.ContentArea,
        Position = UDim2.new(0, 220, 0, 0),
        Size = UDim2.new(1, -220, 1, 0),
        BorderSizePixel = 0
    })
    
    -- Content area corner (only right side)
    local contentCorner = self:CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = window.ContentArea
    })
    
    -- Mask to hide left corners
    local contentMask = self:CreateInstance("Frame", {
        Name = "ContentMask",
        Parent = window.ContentArea,
        BackgroundColor3 = self.Colors.ContentArea,
        Position = UDim2.new(0, -8, 0, 0),
        Size = UDim2.new(0, 16, 1, 0),
        BorderSizePixel = 0
    })
    
    -- Enhanced Content Header
    window.ContentHeader = self:CreateInstance("Frame", {
        Name = "ContentHeader",
        Parent = window.ContentArea,
        BackgroundColor3 = self.Colors.BackgroundSecondary,
        Size = UDim2.new(1, 0, 0, 60),
        BorderSizePixel = 0
    })
    
    -- Header bottom border
    window.HeaderBorder = self:CreateInstance("Frame", {
        Name = "HeaderBorder",
        Parent = window.ContentHeader,
        BackgroundColor3 = self.Colors.Border,
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0
    })
    
    -- Window Controls with enhanced styling
    window.WindowControls = self:CreateInstance("Frame", {
        Name = "WindowControls",
        Parent = window.ContentHeader,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -90, 0, 15),
        Size = UDim2.new(0, 80, 0, 30),
        BorderSizePixel = 0
    })
    
    -- Enhanced Minimize Button
    window.MinimizeBtn = self:CreateInstance("TextButton", {
        Name = "MinimizeBtn",
        Parent = window.WindowControls,
        BackgroundColor3 = self.Colors.BackgroundTertiary,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 35, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = self.Icons.Minimize,
        TextColor3 = self.Colors.TextSecondary,
        TextSize = 16,
        BorderSizePixel = 0,
        AutoButtonColor = false
    })
    
    self:CreateCorner(window.MinimizeBtn, 8)
    self:CreateStroke(window.MinimizeBtn, self.Colors.Border, 1, 0.5)
    
    -- Enhanced Close Button
    window.CloseBtn = self:CreateInstance("TextButton", {
        Name = "CloseBtn",
        Parent = window.WindowControls,
        BackgroundColor3 = self.Colors.BackgroundTertiary,
        Position = UDim2.new(0, 40, 0, 0),
        Size = UDim2.new(0, 35, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = self.Icons.Close,
        TextColor3 = self.Colors.TextSecondary,
        TextSize = 14,
        BorderSizePixel = 0,
        AutoButtonColor = false
    })
    
    self:CreateCorner(window.CloseBtn, 8)
    self:CreateStroke(window.CloseBtn, self.Colors.Border, 1, 0.5)
    
    -- Enhanced button hover effects
    window.MinimizeBtn.MouseEnter:Connect(function()
        self:Tween(window.MinimizeBtn, {
            BackgroundColor3 = self.Colors.Warning, 
            TextColor3 = self.Colors.Background
        }, 0.2)
        self:Tween(window.MinimizeBtn.UIStroke, {Color = self.Colors.Warning}, 0.2)
    end)
    
    window.MinimizeBtn.MouseLeave:Connect(function()
        self:Tween(window.MinimizeBtn, {
            BackgroundColor3 = self.Colors.BackgroundTertiary, 
            TextColor3 = self.Colors.TextSecondary
        }, 0.2)
        self:Tween(window.MinimizeBtn.UIStroke, {Color = self.Colors.Border}, 0.2)
    end)
    
    window.CloseBtn.MouseEnter:Connect(function()
        self:Tween(window.CloseBtn, {
            BackgroundColor3 = self.Colors.Error, 
            TextColor3 = self.Colors.Text
        }, 0.2)
        self:Tween(window.CloseBtn.UIStroke, {Color = self.Colors.Error}, 0.2)
    end)
    
    window.CloseBtn.MouseLeave:Connect(function()
        self:Tween(window.CloseBtn, {
            BackgroundColor3 = self.Colors.BackgroundTertiary, 
            TextColor3 = self.Colors.TextSecondary
        }, 0.2)
        self:Tween(window.CloseBtn.UIStroke, {Color = self.Colors.Border}, 0.2)
    end)
    
    -- Button functionality with animations
    window.MinimizeBtn.MouseButton1Click:Connect(function()
        self:Tween(window.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            window.MainFrame.Visible = false
            
            -- Create enhanced restore button
            local restoreBtn = self:CreateInstance("TextButton", {
                Name = "RestoreBtn",
                Parent = window.ScreenGui,
                BackgroundColor3 = self.Colors.Primary,
                Position = UDim2.new(0, 20, 1, -70),
                Size = UDim2.new(0, 220, 0, 50),
                Font = Enum.Font.GothamSemibold,
                Text = "🔮 Restore " .. (title or "UI"),
                TextColor3 = self.Colors.Text,
                TextSize = 14,
                BorderSizePixel = 0,
                AutoButtonColor = false
            })
            
            self:CreateCorner(restoreBtn, 12)
            self:CreateGradient(restoreBtn)
            
            restoreBtn.MouseButton1Click:Connect(function()
                window.MainFrame.Visible = true
                self:Tween(window.MainFrame, {Size = UDim2.new(0, 950, 0, 650)}, 0.3, Enum.EasingStyle.Back)
                restoreBtn:Destroy()
            end)
        end)
    end)
    
    window.CloseBtn.MouseButton1Click:Connect(function()
        self:Tween(window.MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            window.ScreenGui:Destroy()
        end)
    end)
    
    -- Enhanced Content Title with breadcrumb
    window.ContentTitle = self:CreateInstance("TextLabel", {
        Name = "ContentTitle",
        Parent = window.ContentHeader,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 25, 0, 0),
        Size = UDim2.new(1, -140, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "Welcome",
        TextColor3 = self.Colors.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Content Container with enhanced styling
    window.ContentContainer = self:CreateInstance("ScrollingFrame", {
        Name = "ContentContainer",
        Parent = window.ContentArea,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 25, 0, 80),
        Size = UDim2.new(1, -50, 1, -100),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = self.Colors.Primary,
        BorderSizePixel = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y
    })
    
    local contentLayout = self:CreateInstance("UIListLayout", {
        Parent = window.ContentContainer,
        Padding = UDim.new(0, 20),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        window.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 30)
    end)
    
    -- Make window draggable with enhanced feedback
    local dragging = false
    local dragInput, dragStart, startPos
    
    window.ContentHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.MainFrame.Position
            
            -- Visual feedback when dragging starts
            self:Tween(window.MainFrame, {BackgroundColor3 = self.Colors.BackgroundSecondary}, 0.2)
        end
    end)
    
    window.ContentHeader.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            
            -- Reset visual feedback
            self:Tween(window.MainFrame, {BackgroundColor3 = self.Colors.Background}, 0.2)
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
    
    -- Enhanced Tab Creation Function
    function window:CreateTab(name, icon)
        local tab = {}
        
        -- Enhanced Navigation Button
        tab.NavButton = Library:CreateInstance("TextButton", {
            Name = name .. "NavButton",
            Parent = self.NavContainer,
            BackgroundColor3 = Library.Colors.BackgroundTertiary,
            Size = UDim2.new(1, -20, 0, 45),
            Position = UDim2.new(0, 10, 0, 0),
            Font = Enum.Font.GothamSemibold,
            Text = "",
            TextColor3 = Library.Colors.TextSecondary,
            TextSize = 14,
            BorderSizePixel = 0,
            AutoButtonColor = false
        })
        
        Library:CreateCorner(tab.NavButton, 10)
        Library:CreateStroke(tab.NavButton, Library.Colors.Border, 1, 0.5)
        
        -- Selection indicator (left border)
        tab.SelectionIndicator = Library:CreateInstance("Frame", {
            Name = "SelectionIndicator",
            Parent = tab.NavButton,
            BackgroundColor3 = Library.Colors.Primary,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 0, 1, 0),
            BorderSizePixel = 0
        })
        
        Library:CreateCorner(tab.SelectionIndicator, 10)
        
        -- Icon with enhanced styling
        tab.Icon = Library:CreateInstance("TextLabel", {
            Name = "Icon",
            Parent = tab.NavButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 18, 0, 0),
            Size = UDim2.new(0, 25, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = icon or Library.Icons.Settings,
            TextColor3 = Library.Colors.TextSecondary,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Center
        })
        
        -- Label with enhanced styling
        tab.Label = Library:CreateInstance("TextLabel", {
            Name = "Label",
            Parent = tab.NavButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 50, 0, 0),
            Size = UDim2.new(1, -50, 1, 0),
            Font = Enum.Font.GothamSemibold,
            Text = name,
            TextColor3 = Library.Colors.TextSecondary,
            TextSize = 14,
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
            Padding = UDim.new(0, 15),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tab.Content.Size = UDim2.new(1, 0, 0, tabLayout.AbsoluteContentSize.Y)
        end)
        
        -- Enhanced Tab Selection with smooth animations
        tab.NavButton.MouseButton1Click:Connect(function()
            self:SelectTab(tab)
        end)
        
        -- Enhanced Hover Effects
        tab.NavButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= tab then
                Library:Tween(tab.NavButton, {BackgroundColor3 = Library.Colors.Hover}, 0.2)
                Library:Tween(tab.Icon, {TextColor3 = Library.Colors.TextSecondary}, 0.2)
                Library:Tween(tab.Label, {TextColor3 = Library.Colors.TextSecondary}, 0.2)
            end
        end)
        
        tab.NavButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= tab then
                Library:Tween(tab.NavButton, {BackgroundColor3 = Library.Colors.BackgroundTertiary}, 0.2)
                Library:Tween(tab.Icon, {TextColor3 = Library.Colors.TextMuted}, 0.2)
                Library:Tween(tab.Label, {TextColor3 = Library.Colors.TextMuted}, 0.2)
            end
        end)
        
        -- Store tab
        self.Tabs[name] = tab
        
        -- Select first tab
        if not self.CurrentTab then
            self:SelectTab(tab)
        end
        
        -- Enhanced Component creation functions for tabs
        function tab:CreateSection(title)
            local section = {}
            
            section.Frame = Library:CreateInstance("Frame", {
                Name = title .. "Section",
                Parent = self.Content,
                BackgroundColor3 = Library.Colors.BackgroundSecondary,
                Size = UDim2.new(1, 0, 0, 0),
                BorderSizePixel = 0
            })
            
            Library:CreateCorner(section.Frame, 12)
            Library:CreateStroke(section.Frame, Library.Colors.Border, 1, 0.3)
            
            -- Enhanced section header
            section.Header = Library:CreateInstance("Frame", {
                Name = "Header",
                Parent = section.Frame,
                BackgroundColor3 = Library.Colors.BackgroundTertiary,
                Size = UDim2.new(1, 0, 0, 50),
                BorderSizePixel = 0
            })
            
            Library:CreateCorner(section.Header, 12)
            
            -- Header mask to hide bottom corners
            local headerMask = Library:CreateInstance("Frame", {
                Name = "HeaderMask",
                Parent = section.Header,
                BackgroundColor3 = Library.Colors.BackgroundTertiary,
                Position = UDim2.new(0, 0, 0.6, 0),
                Size = UDim2.new(1, 0, 0.4, 0),
                BorderSizePixel = 0
            })
            
            -- Section title with enhanced styling
            section.Title = Library:CreateInstance("TextLabel", {
                Name = "Title",
                Parent = section.Header,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 20, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = title,
                TextColor3 = Library.Colors.Text,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            -- Section container
            section.Container = Library:CreateInstance("Frame", {
                Name = "Container",
                Parent = section.Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 20, 0, 60),
                Size = UDim2.new(1, -40, 1, -70),
                BorderSizePixel = 0
            })
            
            local sectionLayout = Library:CreateInstance("UIListLayout", {
                Parent = section.Container,
                Padding = UDim.new(0, 12),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                section.Frame.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y + 80)
            end)
            
            -- Enhanced Component creation functions
            function section:CreateToggle(name, default, callback)
                local toggle = {}
                
                toggle.Frame = Library:CreateInstance("Frame", {
                    Name = name .. "Toggle",
                    Parent = self.Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40),
                    BorderSizePixel = 0
                })
                
                toggle.Button = Library:CreateInstance("TextButton", {
                    Name = "Button",
                    Parent = toggle.Frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    BorderSizePixel = 0
                })
                
                -- Enhanced toggle indicator
                toggle.Indicator = Library:CreateInstance("Frame", {
                    Name = "Indicator",
                    Parent = toggle.Frame,
                    BackgroundColor3 = default and Library.Colors.Primary or Library.Colors.BackgroundTertiary,
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(toggle.Indicator, 4)
                Library:CreateStroke(toggle.Indicator, default and Library.Colors.Primary or Library.Colors.Border, 1, 0.3)
                
                -- Checkmark with animation
                if default then
                    toggle.Checkmark = Library:CreateInstance("TextLabel", {
                        Name = "Checkmark",
                        Parent = toggle.Indicator,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        Font = Enum.Font.GothamBold,
                        Text = Library.Icons.Check,
                        TextColor3 = Library.Colors.Text,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Center
                    })
                end
                
                toggle.Label = Library:CreateInstance("TextLabel", {
                    Name = "Label",
                    Parent = toggle.Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 30, 0, 0),
                    Size = UDim2.new(1, -30, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = Library.Colors.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                toggle.Value = default or false
                
                -- Enhanced toggle functionality
                toggle.Button.MouseButton1Click:Connect(function()
                    toggle.Value = not toggle.Value
                    
                    if toggle.Value then
                        Library:Tween(toggle.Indicator, {BackgroundColor3 = Library.Colors.Primary}, 0.2)
                        Library:Tween(toggle.Indicator.UIStroke, {Color = Library.Colors.Primary}, 0.2)
                        
                        if not toggle.Checkmark then
                            toggle.Checkmark = Library:CreateInstance("TextLabel", {
                                Name = "Checkmark",
                                Parent = toggle.Indicator,
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, 0, 1, 0),
                                Font = Enum.Font.GothamBold,
                                Text = Library.Icons.Check,
                                TextColor3 = Library.Colors.Text,
                                TextSize = 12,
                                TextXAlignment = Enum.TextXAlignment.Center,
                                TextTransparency = 1
                            })
                            
                            Library:Tween(toggle.Checkmark, {TextTransparency = 0}, 0.2)
                        end
                    else
                        Library:Tween(toggle.Indicator, {BackgroundColor3 = Library.Colors.BackgroundTertiary}, 0.2)
                        Library:Tween(toggle.Indicator.UIStroke, {Color = Library.Colors.Border}, 0.2)
                        
                        if toggle.Checkmark then
                            Library:Tween(toggle.Checkmark, {TextTransparency = 1}, 0.2, nil, nil, function()
                                toggle.Checkmark:Destroy()
                                toggle.Checkmark = nil
                            end)
                        end
                    end
                    
                    if callback then
                        callback(toggle.Value)
                    end
                end)
                
                -- Hover effects
                toggle.Button.MouseEnter:Connect(function()
                    Library:Tween(toggle.Indicator, {Size = UDim2.new(0, 20, 0, 20)}, 0.2)
                end)
                
                toggle.Button.MouseLeave:Connect(function()
                    Library:Tween(toggle.Indicator, {Size = UDim2.new(0, 18, 0, 18)}, 0.2)
                end)
                
                return toggle
            end
            
            function section:CreateSlider(name, min, max, default, callback)
                local slider = {}
                
                slider.Frame = Library:CreateInstance("Frame", {
                    Name = name .. "Slider",
                    Parent = self.Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 55),
                    BorderSizePixel = 0
                })
                
                slider.Header = Library:CreateInstance("Frame", {
                    Name = "Header",
                    Parent = slider.Frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    BorderSizePixel = 0
                })
                
                slider.Label = Library:CreateInstance("TextLabel", {
                    Name = "Label",
                    Parent = slider.Header,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -70, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = Library.Colors.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                slider.ValueLabel = Library:CreateInstance("TextLabel", {
                    Name = "ValueLabel",
                    Parent = slider.Header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -70, 0, 0),
                    Size = UDim2.new(0, 70, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(default),
                    TextColor3 = Library.Colors.Primary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                -- Enhanced slider track
                slider.Track = Library:CreateInstance("Frame", {
                    Name = "Track",
                    Parent = slider.Frame,
                    BackgroundColor3 = Library.Colors.BackgroundTertiary,
                    Position = UDim2.new(0, 0, 0, 35),
                    Size = UDim2.new(1, 0, 0, 8),
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(slider.Track, 4)
                Library:CreateStroke(slider.Track, Library.Colors.Border, 1, 0.3)
                
                -- Enhanced slider fill with gradient
                slider.Fill = Library:CreateInstance("Frame", {
                    Name = "Fill",
                    Parent = slider.Track,
                    BackgroundColor3 = Library.Colors.Primary,
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(slider.Fill, 4)
                Library:CreateGradient(slider.Fill)
                
                -- Slider handle
                slider.Handle = Library:CreateInstance("Frame", {
                    Name = "Handle",
                    Parent = slider.Track,
                    BackgroundColor3 = Library.Colors.Text,
                    Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 12, 0, 12),
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(slider.Handle, 6)
                Library:CreateStroke(slider.Handle, Library.Colors.Primary, 2)
                
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
                    
                    Library:Tween(slider.Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                    Library:Tween(slider.Handle, {Position = UDim2.new(pos, -6, 0.5, -6)}, 0.1)
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
                        Library:Tween(slider.Handle, {Size = UDim2.new(0, 16, 0, 16)}, 0.2)
                    end
                end)
                
                slider.Button.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                        Library:Tween(slider.Handle, {Size = UDim2.new(0, 12, 0, 12)}, 0.2)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                return slider
            end
            
            function section:CreateDropdown(name, options, default, callback)
                local dropdown = {}
                
                dropdown.Frame = Library:CreateInstance("Frame", {
                    Name = name .. "Dropdown",
                    Parent = self.Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40),
                    ClipsDescendants = true,
                    BorderSizePixel = 0
                })
                
                dropdown.Header = Library:CreateInstance("TextButton", {
                    Name = "Header",
                    Parent = dropdown.Frame,
                    BackgroundColor3 = Library.Colors.BackgroundTertiary,
                    Size = UDim2.new(1, 0, 0, 40),
                    Font = Enum.Font.Gotham,
                    Text = "",
                    TextColor3 = Library.Colors.Text,
                    TextSize = 14,
                    BorderSizePixel = 0,
                    AutoButtonColor = false
                })
                
                Library:CreateCorner(dropdown.Header, 10)
                Library:CreateStroke(dropdown.Header, Library.Colors.Border, 1, 0.3)
                
                dropdown.Label = Library:CreateInstance("TextLabel", {
                    Name = "Label",
                    Parent = dropdown.Header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = Library.Colors.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                dropdown.Selected = Library:CreateInstance("TextLabel", {
                    Name = "Selected",
                    Parent = dropdown.Header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(0.5, -35, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = default or "Select...",
                    TextColor3 = default and Library.Colors.Text or Library.Colors.TextMuted,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                dropdown.Arrow = Library:CreateInstance("TextLabel", {
                    Name = "Arrow",
                    Parent = dropdown.Header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -30, 0, 0),
                    Size = UDim2.new(0, 25, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = Library.Icons.ChevronDown,
                    TextColor3 = Library.Colors.Primary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Rotation = 90
                })
                
                dropdown.OptionsContainer = Library:CreateInstance("Frame", {
                    Name = "OptionsContainer",
                    Parent = dropdown.Frame,
                    BackgroundColor3 = Library.Colors.BackgroundTertiary,
                    Position = UDim2.new(0, 0, 0, 40),
                    Size = UDim2.new(1, 0, 0, #options * 35),
                    Visible = false,
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(dropdown.OptionsContainer, 10)
                Library:CreateStroke(dropdown.OptionsContainer, Library.Colors.Border, 1, 0.3)
                
                local optionsLayout = Library:CreateInstance("UIListLayout", {
                    Parent = dropdown.OptionsContainer,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                dropdown.IsOpen = false
                
                dropdown.Header.MouseButton1Click:Connect(function()
                    dropdown.IsOpen = not dropdown.IsOpen
                    
                    if dropdown.IsOpen then
                        Library:Tween(dropdown.Arrow, {Rotation = 270}, 0.3, Enum.EasingStyle.Back)
                        Library:Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 40 + #options * 35)}, 0.3, Enum.EasingStyle.Quart)
                        dropdown.OptionsContainer.Visible = true
                    else
                        Library:Tween(dropdown.Arrow, {Rotation = 90}, 0.3, Enum.EasingStyle.Back)
                        Library:Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.3, Enum.EasingStyle.Quart)
                        dropdown.OptionsContainer.Visible = false
                    end
                end)
                
                for i, option in ipairs(options) do
                    local optionBtn = Library:CreateInstance("TextButton", {
                        Name = option .. "Option",
                        Parent = dropdown.OptionsContainer,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 35),
                        Font = Enum.Font.Gotham,
                        Text = option,
                        TextColor3 = Library.Colors.TextSecondary,
                        TextSize = 14,
                        BorderSizePixel = 0,
                        AutoButtonColor = false
                    })
                    
                    optionBtn.MouseEnter:Connect(function()
                        Library:Tween(optionBtn, {
                            BackgroundTransparency = 0.8, 
                            BackgroundColor3 = Library.Colors.Primary,
                            TextColor3 = Library.Colors.Text
                        }, 0.2)
                    end)
                    
                    optionBtn.MouseLeave:Connect(function()
                        Library:Tween(optionBtn, {
                            BackgroundTransparency = 1,
                            TextColor3 = Library.Colors.TextSecondary
                        }, 0.2)
                    end)
                    
                    optionBtn.MouseButton1Click:Connect(function()
                        dropdown.Selected.Text = option
                        dropdown.Selected.TextColor3 = Library.Colors.Text
                        dropdown.IsOpen = false
                        
                        Library:Tween(dropdown.Arrow, {Rotation = 90}, 0.3, Enum.EasingStyle.Back)
                        Library:Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.3, Enum.EasingStyle.Quart)
                        dropdown.OptionsContainer.Visible = false
                        
                        if callback then
                            callback(option)
                        end
                    end)
                end
                
                return dropdown
            end
            
            function section:CreateButton(name, callback)
                local button = {}
                
                button.Frame = Library:CreateInstance("TextButton", {
                    Name = name .. "Button",
                    Parent = self.Container,
                    BackgroundColor3 = Library.Colors.Primary,
                    Size = UDim2.new(1, 0, 0, 40),
                    Font = Enum.Font.GothamSemibold,
                    Text = name,
                    TextColor3 = Library.Colors.Text,
                    TextSize = 14,
                    BorderSizePixel = 0,
                    AutoButtonColor = false
                })
                
                Library:CreateCorner(button.Frame, 10)
                Library:CreateGradient(button.Frame)
                Library:CreateStroke(button.Frame, Library.Colors.Primary, 1, 0.5)
                
                button.Frame.MouseEnter:Connect(function()
                    Library:Tween(button.Frame, {BackgroundColor3 = Library.Colors.Secondary}, 0.2)
                    Library:Tween(button.Frame, {Size = UDim2.new(1, 0, 0, 42)}, 0.2)
                end)
                
                button.Frame.MouseLeave:Connect(function()
                    Library:Tween(button.Frame, {BackgroundColor3 = Library.Colors.Primary}, 0.2)
                    Library:Tween(button.Frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                end)
                
                button.Frame.MouseButton1Down:Connect(function()
                    Library:Tween(button.Frame, {Size = UDim2.new(1, -4, 0, 36)}, 0.1)
                end)
                
                button.Frame.MouseButton1Up:Connect(function()
                    Library:Tween(button.Frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.1)
                end)
                
                button.Frame.MouseButton1Click:Connect(function()
                    if callback then
                        callback()
                    end
                end)
                
                return button
            end
            
            return section
        end
        
        return tab
    end
    
    -- Enhanced Tab Selection with smooth connection animation
    function window:SelectTab(tab)
        -- Deselect current tab
        if self.CurrentTab then
            Library:Tween(self.CurrentTab.NavButton, {BackgroundColor3 = Library.Colors.BackgroundTertiary}, 0.3)
            Library:Tween(self.CurrentTab.Icon, {TextColor3 = Library.Colors.TextMuted}, 0.3)
            Library:Tween(self.CurrentTab.Label, {TextColor3 = Library.Colors.TextMuted}, 0.3)
            Library:Tween(self.CurrentTab.SelectionIndicator, {Size = UDim2.new(0, 0, 1, 0)}, 0.3)
            Library:Tween(self.CurrentTab.NavButton.UIStroke, {Color = Library.Colors.Border}, 0.3)
            
            -- Fade out current content
            Library:Tween(self.CurrentTab.Content, {BackgroundTransparency = 1}, 0.2, nil, nil, function()
                self.CurrentTab.Content.Visible = false
            end)
        end
        
        -- Select new tab with enhanced animation
        self.CurrentTab = tab
        Library:Tween(tab.NavButton, {BackgroundColor3 = Library.Colors.Active}, 0.3)
        Library:Tween(tab.Icon, {TextColor3 = Library.Colors.Primary}, 0.3)
        Library:Tween(tab.Label, {TextColor3 = Library.Colors.Text}, 0.3)
        Library:Tween(tab.SelectionIndicator, {Size = UDim2.new(0, 4, 1, 0)}, 0.3, Enum.EasingStyle.Back)
        Library:Tween(tab.NavButton.UIStroke, {Color = Library.Colors.Primary}, 0.3)
        
        -- Fade in new content
        tab.Content.Visible = true
        tab.Content.BackgroundTransparency = 1
        Library:Tween(tab.Content, {BackgroundTransparency = 0}, 0.3)
        
        -- Update content title with animation
        Library:Tween(self.ContentTitle, {TextTransparency = 1}, 0.15, nil, nil, function()
            self.ContentTitle.Text = tab.Label.Text
            Library:Tween(self.ContentTitle, {TextTransparency = 0}, 0.15)
        end)
    end
    
    function window:CreateNotification(title, message, duration, type)
        local notification = {}
        
        local color = Library.Colors.Primary
        if type == "success" then color = Library.Colors.Success
        elseif type == "error" then color = Library.Colors.Error
        elseif type == "warning" then color = Library.Colors.Warning
        end
        
        notification.Frame = Library:CreateInstance("Frame", {
            Name = "Notification",
            Parent = self.ScreenGui,
            BackgroundColor3 = Library.Colors.BackgroundSecondary,
            Position = UDim2.new(1, -370, 1, 20),
            Size = UDim2.new(0, 350, 0, 90),
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0, 1)
        })
        
        Library:CreateCorner(notification.Frame, 12)
        Library:CreateStroke(notification.Frame, color, 2)
        Library:CreateDropShadow(notification.Frame, 6, 0.5)
        
        notification.ColorBar = Library:CreateInstance("Frame", {
            Name = "ColorBar",
            Parent = notification.Frame,
            BackgroundColor3 = color,
            Size = UDim2.new(0, 4, 1, 0),
            BorderSizePixel = 0
        })
        
        Library:CreateCorner(notification.ColorBar, 2)
        
        notification.Title = Library:CreateInstance("TextLabel", {
            Name = "Title",
            Parent = notification.Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 20, 0, 15),
            Size = UDim2.new(1, -40, 0, 25),
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = color,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        notification.Message = Library:CreateInstance("TextLabel", {
            Name = "Message",
            Parent = notification.Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 20, 0, 40),
            Size = UDim2.new(1, -40, 0, 35),
            Font = Enum.Font.Gotham,
            Text = message,
            TextColor3 = Library.Colors.Text,
            TextSize = 14,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })
        
        -- Enhanced entrance animation
        Library:Tween(notification.Frame, {Position = UDim2.new(1, -370, 1, -110)}, 0.5, Enum.EasingStyle.Back)
        
        task.delay(duration or 4, function()
            Library:Tween(notification.Frame, {
                Position = UDim2.new(1, -370, 1, 20),
                BackgroundTransparency = 1
            }, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In, function()
                notification.Frame:Destroy()
            end)
        end)
        
        return notification
    end
    
    -- Enhanced entrance animation
    window.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    window.MainFrame.BackgroundTransparency = 1
    
    Library:Tween(window.MainFrame, {
        Size = UDim2.new(0, 950, 0, 650),
        BackgroundTransparency = 0
    }, 0.6, Enum.EasingStyle.Back)
    
    return window
end

return Library
