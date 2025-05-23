--[[
    Advanced Purple UI Library for Roblox - Professional Gaming Interface
    Inspired by modern cheat interfaces with sidebar navigation
    
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

-- Enhanced Color Palette
Library.Colors = {
    -- Main Colors
    Primary = Color3.fromRGB(139, 92, 246),      -- Purple
    Secondary = Color3.fromRGB(168, 85, 247),    -- Lighter Purple
    Accent = Color3.fromRGB(196, 181, 253),      -- Light Purple
    
    -- Backgrounds
    Background = Color3.fromRGB(17, 17, 27),     -- Very Dark
    BackgroundLight = Color3.fromRGB(24, 24, 37), -- Dark
    BackgroundLighter = Color3.fromRGB(31, 31, 47), -- Medium Dark
    Sidebar = Color3.fromRGB(20, 20, 30),        -- Sidebar
    
    -- Text
    Text = Color3.fromRGB(255, 255, 255),        -- White
    TextSecondary = Color3.fromRGB(156, 163, 175), -- Gray
    TextMuted = Color3.fromRGB(107, 114, 128),   -- Muted Gray
    
    -- States
    Success = Color3.fromRGB(34, 197, 94),       -- Green
    Warning = Color3.fromRGB(251, 191, 36),      -- Yellow
    Error = Color3.fromRGB(239, 68, 68),         -- Red
    
    -- Borders
    Border = Color3.fromRGB(55, 65, 81),         -- Border
    BorderLight = Color3.fromRGB(75, 85, 99),    -- Light Border
}

-- Icons (using Unicode characters)
Library.Icons = {
    Movement = "🎮",
    Settings = "⚙️",
    Skins = "🎨",
    Player = "👤",
    Combat = "⚔️",
    Visual = "👁️",
    Misc = "📦",
    Home = "🏠",
    Search = "🔍",
    Close = "✕",
    Minimize = "−",
    ChevronRight = "›",
    ChevronDown = "⌄",
    Toggle = "●",
    Slider = "━",
}

-- Utility Functions
function Library:Tween(object, properties, duration, style, direction, callback)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
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

function Library:CreateShadow(parent, size, intensity)
    local shadow = self:CreateInstance("ImageLabel", {
        Name = "Shadow",
        Parent = parent.Parent,
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 1 - (intensity or 0.3),
        Position = UDim2.new(0, size or 4, 0, size or 4),
        Size = parent.Size,
        ZIndex = parent.ZIndex - 1
    })
    
    self:CreateCorner(shadow, 8)
    return shadow
end

-- Main Window Creation
function Library:CreateWindow(title, version)
    local window = {}
    setmetatable(window, self)
    
    -- Create ScreenGui
    window.ScreenGui = self:CreateInstance("ScreenGui", {
        Name = "AdvancedPurpleUI_" .. math.random(1000, 9999),
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Main Container
    window.MainFrame = self:CreateInstance("Frame", {
        Name = "MainFrame",
        Parent = window.ScreenGui,
        BackgroundColor3 = self.Colors.Background,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 900, 0, 600),
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    
    self:CreateCorner(window.MainFrame, 12)
    self:CreateStroke(window.MainFrame, self.Colors.Border, 1, 0.5)
    
    -- Sidebar
    window.Sidebar = self:CreateInstance("Frame", {
        Name = "Sidebar",
        Parent = window.MainFrame,
        BackgroundColor3 = self.Colors.Sidebar,
        Size = UDim2.new(0, 200, 1, 0),
        BorderSizePixel = 0
    })
    
    self:CreateCorner(window.Sidebar, 12)
    
    -- Sidebar content mask
    local sidebarMask = self:CreateInstance("Frame", {
        Name = "SidebarMask",
        Parent = window.Sidebar,
        BackgroundColor3 = self.Colors.Sidebar,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 8, 1, 0),
        BorderSizePixel = 0
    })
    
    -- Header in sidebar
    window.Header = self:CreateInstance("Frame", {
        Name = "Header",
        Parent = window.Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 60),
        BorderSizePixel = 0
    })
    
    -- Logo/Title
    window.Logo = self:CreateInstance("TextLabel", {
        Name = "Logo",
        Parent = window.Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 15),
        Size = UDim2.new(1, -40, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = "🔮 " .. (title or "Advanced UI"),
        TextColor3 = self.Colors.Primary,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Version
    window.Version = self:CreateInstance("TextLabel", {
        Name = "Version",
        Parent = window.Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 35),
        Size = UDim2.new(1, -40, 0, 15),
        Font = Enum.Font.Gotham,
        Text = version or "v1.0.0",
        TextColor3 = self.Colors.TextMuted,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Navigation Container
    window.NavContainer = self:CreateInstance("ScrollingFrame", {
        Name = "NavContainer",
        Parent = window.Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 70),
        Size = UDim2.new(1, 0, 1, -70),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.Colors.Primary,
        BorderSizePixel = 0
    })
    
    local navLayout = self:CreateInstance("UIListLayout", {
        Parent = window.NavContainer,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        window.NavContainer.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Main Content Area
    window.ContentArea = self:CreateInstance("Frame", {
        Name = "ContentArea",
        Parent = window.MainFrame,
        BackgroundColor3 = self.Colors.BackgroundLight,
        Position = UDim2.new(0, 200, 0, 0),
        Size = UDim2.new(1, -200, 1, 0),
        BorderSizePixel = 0
    })
    
    -- Content Header
    window.ContentHeader = self:CreateInstance("Frame", {
        Name = "ContentHeader",
        Parent = window.ContentArea,
        BackgroundColor3 = self.Colors.BackgroundLighter,
        Size = UDim2.new(1, 0, 0, 50),
        BorderSizePixel = 0
    })
    
    -- Window Controls
    window.WindowControls = self:CreateInstance("Frame", {
        Name = "WindowControls",
        Parent = window.ContentHeader,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -80, 0, 10),
        Size = UDim2.new(0, 70, 0, 30),
        BorderSizePixel = 0
    })
    
    -- Minimize Button
    window.MinimizeBtn = self:CreateInstance("TextButton", {
        Name = "MinimizeBtn",
        Parent = window.WindowControls,
        BackgroundColor3 = self.Colors.BackgroundLighter,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = self.Icons.Minimize,
        TextColor3 = self.Colors.TextSecondary,
        TextSize = 16,
        BorderSizePixel = 0
    })
    
    self:CreateCorner(window.MinimizeBtn, 6)
    
    -- Close Button
    window.CloseBtn = self:CreateInstance("TextButton", {
        Name = "CloseBtn",
        Parent = window.WindowControls,
        BackgroundColor3 = self.Colors.BackgroundLighter,
        Position = UDim2.new(0, 35, 0, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = self.Icons.Close,
        TextColor3 = self.Colors.TextSecondary,
        TextSize = 14,
        BorderSizePixel = 0
    })
    
    self:CreateCorner(window.CloseBtn, 6)
    
    -- Button hover effects
    window.MinimizeBtn.MouseEnter:Connect(function()
        self:Tween(window.MinimizeBtn, {BackgroundColor3 = self.Colors.Warning, TextColor3 = self.Colors.Background}, 0.2)
    end)
    
    window.MinimizeBtn.MouseLeave:Connect(function()
        self:Tween(window.MinimizeBtn, {BackgroundColor3 = self.Colors.BackgroundLighter, TextColor3 = self.Colors.TextSecondary}, 0.2)
    end)
    
    window.CloseBtn.MouseEnter:Connect(function()
        self:Tween(window.CloseBtn, {BackgroundColor3 = self.Colors.Error, TextColor3 = self.Colors.Text}, 0.2)
    end)
    
    window.CloseBtn.MouseLeave:Connect(function()
        self:Tween(window.CloseBtn, {BackgroundColor3 = self.Colors.BackgroundLighter, TextColor3 = self.Colors.TextSecondary}, 0.2)
    end)
    
    -- Button functionality
    window.MinimizeBtn.MouseButton1Click:Connect(function()
        window.MainFrame.Visible = false
        
        -- Create restore notification
        local restoreBtn = self:CreateInstance("TextButton", {
            Name = "RestoreBtn",
            Parent = window.ScreenGui,
            BackgroundColor3 = self.Colors.Primary,
            Position = UDim2.new(0, 20, 1, -60),
            Size = UDim2.new(0, 200, 0, 40),
            Font = Enum.Font.GothamSemibold,
            Text = "🔮 Restore " .. (title or "UI"),
            TextColor3 = self.Colors.Text,
            TextSize = 14,
            BorderSizePixel = 0
        })
        
        self:CreateCorner(restoreBtn, 8)
        
        restoreBtn.MouseButton1Click:Connect(function()
            window.MainFrame.Visible = true
            restoreBtn:Destroy()
        end)
    end)
    
    window.CloseBtn.MouseButton1Click:Connect(function()
        self:Tween(window.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            window.ScreenGui:Destroy()
        end)
    end)
    
    -- Content Title
    window.ContentTitle = self:CreateInstance("TextLabel", {
        Name = "ContentTitle",
        Parent = window.ContentHeader,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 0),
        Size = UDim2.new(1, -120, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "Welcome",
        TextColor3 = self.Colors.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Content Container
    window.ContentContainer = self:CreateInstance("ScrollingFrame", {
        Name = "ContentContainer",
        Parent = window.ContentArea,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 70),
        Size = UDim2.new(1, -40, 1, -90),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = self.Colors.Primary,
        BorderSizePixel = 0
    })
    
    local contentLayout = self:CreateInstance("UIListLayout", {
        Parent = window.ContentContainer,
        Padding = UDim.new(0, 15),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        window.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Make window draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    window.ContentHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.MainFrame.Position
        end
    end)
    
    window.ContentHeader.InputEnded:Connect(function(input)
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
            BackgroundColor3 = Library.Colors.BackgroundLighter,
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, 0),
            Font = Enum.Font.GothamSemibold,
            Text = "",
            TextColor3 = Library.Colors.TextSecondary,
            TextSize = 14,
            BorderSizePixel = 0,
            AutoButtonColor = false
        })
        
        Library:CreateCorner(tab.NavButton, 8)
        
        -- Icon
        tab.Icon = Library:CreateInstance("TextLabel", {
            Name = "Icon",
            Parent = tab.NavButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 0),
            Size = UDim2.new(0, 20, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = icon or Library.Icons.Settings,
            TextColor3 = Library.Colors.TextSecondary,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Center
        })
        
        -- Label
        tab.Label = Library:CreateInstance("TextLabel", {
            Name = "Label",
            Parent = tab.NavButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 45, 0, 0),
            Size = UDim2.new(1, -45, 1, 0),
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
            Padding = UDim.new(0, 12),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tab.Content.Size = UDim2.new(1, 0, 0, tabLayout.AbsoluteContentSize.Y)
        end)
        
        -- Tab Selection
        tab.NavButton.MouseButton1Click:Connect(function()
            self:SelectTab(tab)
        end)
        
        -- Hover Effects
        tab.NavButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= tab then
                Library:Tween(tab.NavButton, {BackgroundColor3 = Library.Colors.BackgroundLight}, 0.2)
            end
        end)
        
        tab.NavButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= tab then
                Library:Tween(tab.NavButton, {BackgroundColor3 = Library.Colors.BackgroundLighter}, 0.2)
            end
        end)
        
        -- Store tab
        self.Tabs[name] = tab
        
        -- Select first tab
        if not self.CurrentTab then
            self:SelectTab(tab)
        end
        
        -- Component creation functions for tabs
        function tab:CreateSection(title)
            local section = {}
            
            section.Frame = Library:CreateInstance("Frame", {
                Name = title .. "Section",
                Parent = self.Content,
                BackgroundColor3 = Library.Colors.BackgroundLighter,
                Size = UDim2.new(1, 0, 0, 0),
                BorderSizePixel = 0
            })
            
            Library:CreateCorner(section.Frame, 10)
            Library:CreateStroke(section.Frame, Library.Colors.Border, 1, 0.3)
            
            section.Header = Library:CreateInstance("Frame", {
                Name = "Header",
                Parent = section.Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                BorderSizePixel = 0
            })
            
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
            
            section.Container = Library:CreateInstance("Frame", {
                Name = "Container",
                Parent = section.Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 20, 0, 50),
                Size = UDim2.new(1, -40, 1, -60),
                BorderSizePixel = 0
            })
            
            local sectionLayout = Library:CreateInstance("UIListLayout", {
                Parent = section.Container,
                Padding = UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                section.Frame.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y + 70)
            end)
            
            -- Component creation functions
            function section:CreateToggle(name, default, callback)
                local toggle = {}
                
                toggle.Frame = Library:CreateInstance("Frame", {
                    Name = name .. "Toggle",
                    Parent = self.Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 35),
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
                
                toggle.Indicator = Library:CreateInstance("Frame", {
                    Name = "Indicator",
                    Parent = toggle.Frame,
                    BackgroundColor3 = default and Library.Colors.Primary or Library.Colors.BackgroundLight,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(toggle.Indicator, 3)
                
                if default then
                    local checkmark = Library:CreateInstance("TextLabel", {
                        Name = "Checkmark",
                        Parent = toggle.Indicator,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        Font = Enum.Font.GothamBold,
                        Text = "✓",
                        TextColor3 = Library.Colors.Text,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Center
                    })
                end
                
                toggle.Label = Library:CreateInstance("TextLabel", {
                    Name = "Label",
                    Parent = toggle.Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 25, 0, 0),
                    Size = UDim2.new(1, -25, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = Library.Colors.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                toggle.Value = default or false
                
                toggle.Button.MouseButton1Click:Connect(function()
                    toggle.Value = not toggle.Value
                    
                    if toggle.Value then
                        Library:Tween(toggle.Indicator, {BackgroundColor3 = Library.Colors.Primary}, 0.2)
                        if not toggle.Indicator:FindFirstChild("Checkmark") then
                            local checkmark = Library:CreateInstance("TextLabel", {
                                Name = "Checkmark",
                                Parent = toggle.Indicator,
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, 0, 1, 0),
                                Font = Enum.Font.GothamBold,
                                Text = "✓",
                                TextColor3 = Library.Colors.Text,
                                TextSize = 12,
                                TextXAlignment = Enum.TextXAlignment.Center
                            })
                        end
                    else
                        Library:Tween(toggle.Indicator, {BackgroundColor3 = Library.Colors.BackgroundLight}, 0.2)
                        if toggle.Indicator:FindFirstChild("Checkmark") then
                            toggle.Indicator.Checkmark:Destroy()
                        end
                    end
                    
                    if callback then
                        callback(toggle.Value)
                    end
                end)
                
                return toggle
            end
            
            function section:CreateSlider(name, min, max, default, callback)
                local slider = {}
                
                slider.Frame = Library:CreateInstance("Frame", {
                    Name = name .. "Slider",
                    Parent = self.Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 50),
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
                    Size = UDim2.new(1, -60, 1, 0),
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
                    Position = UDim2.new(1, -60, 0, 0),
                    Size = UDim2.new(0, 60, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(default),
                    TextColor3 = Library.Colors.Primary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                slider.Track = Library:CreateInstance("Frame", {
                    Name = "Track",
                    Parent = slider.Frame,
                    BackgroundColor3 = Library.Colors.BackgroundLight,
                    Position = UDim2.new(0, 0, 0, 30),
                    Size = UDim2.new(1, 0, 0, 6),
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(slider.Track, 3)
                
                slider.Fill = Library:CreateInstance("Frame", {
                    Name = "Fill",
                    Parent = slider.Track,
                    BackgroundColor3 = Library.Colors.Primary,
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(slider.Fill, 3)
                Library:CreateGradient(slider.Fill)
                
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
                    slider.ValueLabel.Text = tostring(currentValue)
                    
                    if callback then
                        callback(currentValue)
                    end
                end
                
                slider.Button.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateSlider(input)
                    end
                end)
                
                slider.Button.InputEnded:Connect(function(input)
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
            
            function section:CreateDropdown(name, options, default, callback)
                local dropdown = {}
                
                dropdown.Frame = Library:CreateInstance("Frame", {
                    Name = name .. "Dropdown",
                    Parent = self.Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 35),
                    ClipsDescendants = true,
                    BorderSizePixel = 0
                })
                
                dropdown.Header = Library:CreateInstance("TextButton", {
                    Name = "Header",
                    Parent = dropdown.Frame,
                    BackgroundColor3 = Library.Colors.BackgroundLight,
                    Size = UDim2.new(1, 0, 0, 35),
                    Font = Enum.Font.Gotham,
                    Text = "",
                    TextColor3 = Library.Colors.Text,
                    TextSize = 14,
                    BorderSizePixel = 0,
                    AutoButtonColor = false
                })
                
                Library:CreateCorner(dropdown.Header, 8)
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
                    Size = UDim2.new(0.5, -30, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = default or "Select...",
                    TextColor3 = Library.Colors.TextSecondary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                dropdown.Arrow = Library:CreateInstance("TextLabel", {
                    Name = "Arrow",
                    Parent = dropdown.Header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -25, 0, 0),
                    Size = UDim2.new(0, 20, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = Library.Icons.ChevronDown,
                    TextColor3 = Library.Colors.Primary,
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Center
                })
                
                dropdown.OptionsContainer = Library:CreateInstance("Frame", {
                    Name = "OptionsContainer",
                    Parent = dropdown.Frame,
                    BackgroundColor3 = Library.Colors.BackgroundLight,
                    Position = UDim2.new(0, 0, 0, 35),
                    Size = UDim2.new(1, 0, 0, #options * 30),
                    Visible = false,
                    BorderSizePixel = 0
                })
                
                Library:CreateCorner(dropdown.OptionsContainer, 8)
                Library:CreateStroke(dropdown.OptionsContainer, Library.Colors.Border, 1, 0.3)
                
                local optionsLayout = Library:CreateInstance("UIListLayout", {
                    Parent = dropdown.OptionsContainer,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                dropdown.IsOpen = false
                
                dropdown.Header.MouseButton1Click:Connect(function()
                    dropdown.IsOpen = not dropdown.IsOpen
                    
                    if dropdown.IsOpen then
                        Library:Tween(dropdown.Arrow, {Rotation = 180}, 0.3)
                        Library:Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 35 + #options * 30)}, 0.3)
                        dropdown.OptionsContainer.Visible = true
                    else
                        Library:Tween(dropdown.Arrow, {Rotation = 0}, 0.3)
                        Library:Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
                        dropdown.OptionsContainer.Visible = false
                    end
                end)
                
                for i, option in ipairs(options) do
                    local optionBtn = Library:CreateInstance("TextButton", {
                        Name = option .. "Option",
                        Parent = dropdown.OptionsContainer,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = option,
                        TextColor3 = Library.Colors.TextSecondary,
                        TextSize = 14,
                        BorderSizePixel = 0,
                        AutoButtonColor = false
                    })
                    
                    optionBtn.MouseEnter:Connect(function()
                        Library:Tween(optionBtn, {BackgroundTransparency = 0.9, BackgroundColor3 = Library.Colors.Primary}, 0.2)
                    end)
                    
                    optionBtn.MouseLeave:Connect(function()
                        Library:Tween(optionBtn, {BackgroundTransparency = 1}, 0.2)
                    end)
                    
                    optionBtn.MouseButton1Click:Connect(function()
                        dropdown.Selected.Text = option
                        dropdown.Selected.TextColor3 = Library.Colors.Text
                        dropdown.IsOpen = false
                        
                        Library:Tween(dropdown.Arrow, {Rotation = 0}, 0.3)
                        Library:Tween(dropdown.Frame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
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
                    Size = UDim2.new(1, 0, 0, 35),
                    Font = Enum.Font.GothamSemibold,
                    Text = name,
                    TextColor3 = Library.Colors.Text,
                    TextSize = 14,
                    BorderSizePixel = 0,
                    AutoButtonColor = false
                })
                
                Library:CreateCorner(button.Frame, 8)
                Library:CreateGradient(button.Frame)
                
                button.Frame.MouseEnter:Connect(function()
                    Library:Tween(button.Frame, {BackgroundColor3 = Library.Colors.Secondary}, 0.2)
                end)
                
                button.Frame.MouseLeave:Connect(function()
                    Library:Tween(button.Frame, {BackgroundColor3 = Library.Colors.Primary}, 0.2)
                end)
                
                button.Frame.MouseButton1Down:Connect(function()
                    Library:Tween(button.Frame, {Size = UDim2.new(1, -4, 0, 31)}, 0.1)
                end)
                
                button.Frame.MouseButton1Up:Connect(function()
                    Library:Tween(button.Frame, {Size = UDim2.new(1, 0, 0, 35)}, 0.1)
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
    
    function window:SelectTab(tab)
        -- Deselect current tab
        if self.CurrentTab then
            Library:Tween(self.CurrentTab.NavButton, {BackgroundColor3 = Library.Colors.BackgroundLighter}, 0.2)
            Library:Tween(self.CurrentTab.Icon, {TextColor3 = Library.Colors.TextSecondary}, 0.2)
            Library:Tween(self.CurrentTab.Label, {TextColor3 = Library.Colors.TextSecondary}, 0.2)
            self.CurrentTab.Content.Visible = false
        end
        
        -- Select new tab
        self.CurrentTab = tab
        Library:Tween(tab.NavButton, {BackgroundColor3 = Library.Colors.Primary}, 0.2)
        Library:Tween(tab.Icon, {TextColor3 = Library.Colors.Text}, 0.2)
        Library:Tween(tab.Label, {TextColor3 = Library.Colors.Text}, 0.2)
        tab.Content.Visible = true
        
        -- Update content title
        self.ContentTitle.Text = tab.Label.Text
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
            BackgroundColor3 = Library.Colors.BackgroundLighter,
            Position = UDim2.new(1, -350, 1, 20),
            Size = UDim2.new(0, 330, 0, 80),
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0, 1)
        })
        
        Library:CreateCorner(notification.Frame, 10)
        Library:CreateStroke(notification.Frame, color, 2)
        
        notification.ColorBar = Library:CreateInstance("Frame", {
            Name = "ColorBar",
            Parent = notification.Frame,
            BackgroundColor3 = color,
            Size = UDim2.new(0, 4, 1, 0),
            BorderSizePixel = 0
        })
        
        notification.Title = Library:CreateInstance("TextLabel", {
            Name = "Title",
            Parent = notification.Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 20, 0, 10),
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
            Position = UDim2.new(0, 20, 0, 35),
            Size = UDim2.new(1, -40, 0, 35),
            Font = Enum.Font.Gotham,
            Text = message,
            TextColor3 = Library.Colors.Text,
            TextSize = 14,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })
        
        Library:Tween(notification.Frame, {Position = UDim2.new(1, -350, 1, -100)}, 0.5, Enum.EasingStyle.Back)
        
        task.delay(duration or 4, function()
            Library:Tween(notification.Frame, {Position = UDim2.new(1, -350, 1, 20)}, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In, function()
                notification.Frame:Destroy()
            end)
        end)
        
        return notification
    end
    
    -- Entrance animation
    window.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Library:Tween(window.MainFrame, {Size = UDim2.new(0, 900, 0, 600)}, 0.5, Enum.EasingStyle.Back)
    
    return window
end

return Library
