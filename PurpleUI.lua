-- SolisHub Arise Crossover UI - Exact Recreation
-- Load with: loadstring(game:HttpGet("your-github-url"))()

local SolisUI = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Exact Theme Colors from Screenshot
local Theme = {
    MainBackground = Color3.fromRGB(32, 32, 40),
    SidebarBackground = Color3.fromRGB(28, 28, 35),
    SectionBackground = Color3.fromRGB(40, 40, 48),
    ToggleOff = Color3.fromRGB(60, 60, 70),
    ToggleOn = Color3.fromRGB(168, 85, 247), -- Purple accent
    ToggleHandle = Color3.fromRGB(255, 255, 255),
    ButtonBackground = Color3.fromRGB(168, 85, 247),
    ButtonHover = Color3.fromRGB(180, 100, 255),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 190),
    TextMuted = Color3.fromRGB(120, 120, 130),
    Border = Color3.fromRGB(55, 55, 65),
    TabActive = Color3.fromRGB(168, 85, 247),
    TabInactive = Color3.fromRGB(50, 50, 60)
}

function SolisUI.Create()
    -- Destroy existing
    if PlayerGui:FindFirstChild("SolisHubUI") then
        PlayerGui.SolisHubUI:Destroy()
    end
    
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SolisHubUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    -- Main Container
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 520, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
    mainFrame.BackgroundColor3 = Theme.MainBackground
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Rounded corners
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Theme.SidebarBackground
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 12, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "← SolisHub Arise Crossover"
    titleText.TextColor3 = Theme.TextPrimary
    titleText.TextSize = 14
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.Gotham
    titleText.Parent = titleBar
    
    -- Window Controls
    local controls = Instance.new("Frame")
    controls.Name = "Controls"
    controls.Size = UDim2.new(0, 60, 0, 20)
    controls.Position = UDim2.new(1, -70, 0, 7)
    controls.BackgroundTransparency = 1
    controls.Parent = titleBar
    
    -- Control buttons (minimize, maximize, close)
    local controlColors = {
        Color3.fromRGB(255, 95, 87),   -- Red
        Color3.fromRGB(255, 189, 46),  -- Yellow  
        Color3.fromRGB(40, 201, 64)    -- Green
    }
    
    for i = 1, 3 do
        local controlBtn = Instance.new("Frame")
        controlBtn.Size = UDim2.new(0, 12, 0, 12)
        controlBtn.Position = UDim2.new(0, (i-1) * 18, 0, 4)
        controlBtn.BackgroundColor3 = controlColors[i]
        controlBtn.BorderSizePixel = 0
        controlBtn.Parent = controls
        
        local controlCorner = Instance.new("UICorner")
        controlCorner.CornerRadius = UDim.new(0, 6)
        controlCorner.Parent = controlBtn
    end
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 120, 1, -35)
    sidebar.Position = UDim2.new(0, 0, 0, 35)
    sidebar.BackgroundColor3 = Theme.SidebarBackground
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    
    -- Main Tab Button
    local mainTab = Instance.new("TextButton")
    mainTab.Name = "MainTab"
    mainTab.Size = UDim2.new(1, -16, 0, 32)
    mainTab.Position = UDim2.new(0, 8, 0, 12)
    mainTab.BackgroundColor3 = Theme.TabActive
    mainTab.Text = "Main"
    mainTab.TextColor3 = Theme.TextPrimary
    mainTab.TextSize = 13
    mainTab.Font = Enum.Font.Gotham
    mainTab.BorderSizePixel = 0
    mainTab.Parent = sidebar
    
    local mainTabCorner = Instance.new("UICorner")
    mainTabCorner.CornerRadius = UDim.new(0, 6)
    mainTabCorner.Parent = mainTab
    
    -- Settings Tab Button
    local settingsTab = Instance.new("TextButton")
    settingsTab.Name = "SettingsTab"
    settingsTab.Size = UDim2.new(1, -16, 0, 32)
    settingsTab.Position = UDim2.new(0, 8, 0, 52)
    settingsTab.BackgroundColor3 = Theme.TabInactive
    settingsTab.Text = "Settings"
    settingsTab.TextColor3 = Theme.TextSecondary
    settingsTab.TextSize = 13
    settingsTab.Font = Enum.Font.Gotham
    settingsTab.BorderSizePixel = 0
    settingsTab.Parent = sidebar
    
    local settingsTabCorner = Instance.new("UICorner")
    settingsTabCorner.CornerRadius = UDim.new(0, 6)
    settingsTabCorner.Parent = settingsTab
    
    -- Content Area
    local contentArea = Instance.new("ScrollingFrame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -130, 1, -45)
    contentArea.Position = UDim2.new(0, 130, 0, 45)
    contentArea.BackgroundTransparency = 1
    contentArea.BorderSizePixel = 0
    contentArea.ScrollBarThickness = 4
    contentArea.ScrollBarImageColor3 = Theme.ToggleOn
    contentArea.CanvasSize = UDim2.new(0, 0, 0, 600)
    contentArea.Parent = mainFrame
    
    -- Content Layout
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = contentArea
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 8)
    contentPadding.PaddingLeft = UDim.new(0, 8)
    contentPadding.PaddingRight = UDim.new(0, 8)
    contentPadding.Parent = contentArea
    
    -- Helper function to create sections
    local function createSection(title, items)
        local section = Instance.new("Frame")
        section.Name = title .. "Section"
        section.Size = UDim2.new(1, 0, 0, 30 + (#items * 35))
        section.BackgroundTransparency = 1
        section.Parent = contentArea
        
        -- Section Title
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Name = "SectionTitle"
        sectionTitle.Size = UDim2.new(1, 0, 0, 25)
        sectionTitle.Position = UDim2.new(0, 0, 0, 0)
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Text = title
        sectionTitle.TextColor3 = Theme.TextPrimary
        sectionTitle.TextSize = 14
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.Parent = section
        
        -- Section Items
        for i, item in ipairs(items) do
            local itemFrame = Instance.new("Frame")
            itemFrame.Name = item.name .. "Item"
            itemFrame.Size = UDim2.new(1, 0, 0, 30)
            itemFrame.Position = UDim2.new(0, 0, 0, 25 + (i-1) * 35)
            itemFrame.BackgroundTransparency = 1
            itemFrame.Parent = section
            
            if item.type == "toggle" then
                -- Item Label
                local itemLabel = Instance.new("TextLabel")
                itemLabel.Name = "ItemLabel"
                itemLabel.Size = UDim2.new(1, -80, 1, 0)
                itemLabel.Position = UDim2.new(0, 0, 0, 0)
                itemLabel.BackgroundTransparency = 1
                itemLabel.Text = item.name
                itemLabel.TextColor3 = Theme.TextSecondary
                itemLabel.TextSize = 12
                itemLabel.TextXAlignment = Enum.TextXAlignment.Left
                itemLabel.Font = Enum.Font.Gotham
                itemLabel.Parent = itemFrame
                
                -- Toggle Switch Background
                local toggleBg = Instance.new("Frame")
                toggleBg.Name = "ToggleBg"
                toggleBg.Size = UDim2.new(0, 45, 0, 20)
                toggleBg.Position = UDim2.new(1, -50, 0, 5)
                toggleBg.BackgroundColor3 = item.default and Theme.ToggleOn or Theme.ToggleOff
                toggleBg.BorderSizePixel = 0
                toggleBg.Parent = itemFrame
                
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 10)
                toggleCorner.Parent = toggleBg
                
                -- Toggle Handle
                local toggleHandle = Instance.new("Frame")
                toggleHandle.Name = "ToggleHandle"
                toggleHandle.Size = UDim2.new(0, 16, 0, 16)
                toggleHandle.Position = item.default and UDim2.new(0, 27, 0, 2) or UDim2.new(0, 2, 0, 2)
                toggleHandle.BackgroundColor3 = Theme.ToggleHandle
                toggleHandle.BorderSizePixel = 0
                toggleHandle.Parent = toggleBg
                
                local handleCorner = Instance.new("UICorner")
                handleCorner.CornerRadius = UDim.new(0, 8)
                handleCorner.Parent = toggleHandle
                
                -- Toggle State Text
                local toggleText = Instance.new("TextLabel")
                toggleText.Name = "ToggleText"
                toggleText.Size = UDim2.new(0, 20, 0, 12)
                toggleText.Position = UDim2.new(1, -25, 0, 9)
                toggleText.BackgroundTransparency = 1
                toggleText.Text = item.default and "ON" or ""
                toggleText.TextColor3 = Theme.TextMuted
                toggleText.TextSize = 8
                toggleText.TextXAlignment = Enum.TextXAlignment.Center
                toggleText.Font = Enum.Font.Gotham
                toggleText.Parent = itemFrame
                
                -- Toggle Functionality
                local isToggled = item.default or false
                
                local toggleButton = Instance.new("TextButton")
                toggleButton.Size = UDim2.new(1, 0, 1, 0)
                toggleButton.BackgroundTransparency = 1
                toggleButton.Text = ""
                toggleButton.Parent = itemFrame
                
                toggleButton.MouseButton1Click:Connect(function()
                    isToggled = not isToggled
                    
                    -- Animate toggle
                    local targetColor = isToggled and Theme.ToggleOn or Theme.ToggleOff
                    local targetPos = isToggled and UDim2.new(0, 27, 0, 2) or UDim2.new(0, 2, 0, 2)
                    
                    TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                    TweenService:Create(toggleHandle, TweenInfo.new(0.2), {Position = targetPos}):Play()
                    
                    toggleText.Text = isToggled and "ON" or ""
                    
                    if item.callback then
                        item.callback(isToggled)
                    end
                end)
                
            elseif item.type == "button" then
                local button = Instance.new("TextButton")
                button.Name = item.name .. "Button"
                button.Size = UDim2.new(1, 0, 1, 0)
                button.Position = UDim2.new(0, 0, 0, 0)
                button.BackgroundColor3 = Theme.ButtonBackground
                button.Text = item.name
                button.TextColor3 = Theme.TextPrimary
                button.TextSize = 12
                button.Font = Enum.Font.Gotham
                button.BorderSizePixel = 0
                button.Parent = itemFrame
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 6)
                buttonCorner.Parent = button
                
                button.MouseEnter:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ButtonHover}):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ButtonBackground}):Play()
                end)
                
                button.MouseButton1Click:Connect(function()
                    if item.callback then
                        item.callback()
                    end
                end)
                
            elseif item.type == "dropdown" then
                -- Dropdown Label
                local dropdownLabel = Instance.new("TextLabel")
                dropdownLabel.Name = "DropdownLabel"
                dropdownLabel.Size = UDim2.new(0.4, 0, 1, 0)
                dropdownLabel.Position = UDim2.new(0, 0, 0, 0)
                dropdownLabel.BackgroundTransparency = 1
                dropdownLabel.Text = item.name
                dropdownLabel.TextColor3 = Theme.TextSecondary
                dropdownLabel.TextSize = 12
                dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                dropdownLabel.Font = Enum.Font.Gotham
                dropdownLabel.Parent = itemFrame
                
                -- Dropdown Button
                local dropdown = Instance.new("TextButton")
                dropdown.Name = item.name .. "Dropdown"
                dropdown.Size = UDim2.new(0.6, -5, 1, 0)
                dropdown.Position = UDim2.new(0.4, 5, 0, 0)
                dropdown.BackgroundColor3 = Theme.SectionBackground
                dropdown.Text = item.default or item.options[1] or "Select"
                dropdown.TextColor3 = Theme.TextPrimary
                dropdown.TextSize = 11
                dropdown.Font = Enum.Font.Gotham
                dropdown.BorderSizePixel = 0
                dropdown.Parent = itemFrame
                
                local dropdownCorner = Instance.new("UICorner")
                dropdownCorner.CornerRadius = UDim.new(0, 4)
                dropdownCorner.Parent = dropdown
                
                -- Dropdown arrow
                local arrow = Instance.new("TextLabel")
                arrow.Size = UDim2.new(0, 20, 1, 0)
                arrow.Position = UDim2.new(1, -20, 0, 0)
                arrow.BackgroundTransparency = 1
                arrow.Text = "▼"
                arrow.TextColor3 = Theme.TextMuted
                arrow.TextSize = 8
                arrow.TextXAlignment = Enum.TextXAlignment.Center
                arrow.Font = Enum.Font.Gotham
                arrow.Parent = dropdown
                
                dropdown.MouseButton1Click:Connect(function()
                    if item.callback then
                        item.callback(dropdown.Text)
                    end
                end)
            end
        end
        
        return section
    end
    
    -- Create Main Content
    createSection("Main", {
        {name = "Anti Fling Mode", type = "toggle", default = false, callback = function(v) print("Anti Fling:", v) end},
        {name = "Fly Speed", type = "toggle", default = false, callback = function(v) print("Fly Speed:", v) end},
        {name = "Noclip", type = "toggle", default = false, callback = function(v) print("Noclip:", v) end}
    })
    
    createSection("Teleports", {
        {name = "World", type = "dropdown", options = {"World 1", "World 2", "World 3", "World 4", "World 5"}, default = "World 5", callback = function(v) print("World:", v) end},
        {name = "Teleport To World", type = "button", callback = function() print("Teleporting...") end}
    })
    
    createSection("Player Cheats", {
        {name = "WalkSpeed Toggle", type = "toggle", default = false, callback = function(v) print("WalkSpeed:", v) end},
        {name = "JumpPower Toggle", type = "toggle", default = false, callback = function(v) print("JumpPower:", v) end}
    })
    
    createSection("Anti Afk", {
        {name = "Reset Character", type = "button", callback = function() 
            if Player.Character then
                Player.Character:BreakJoints()
            end
        end},
        {name = "Rejoin", type = "button", callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
        end}
    })
    
    -- Make draggable
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
    
    return screenGui
end

-- Auto-create the UI
return SolisUI.Create()
