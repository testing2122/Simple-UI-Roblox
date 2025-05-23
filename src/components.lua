local ts = game:GetService("TweenService");
local uis = game:GetService("UserInputService");
local rs = game:GetService("RunService");

local utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/testing2122/Simple-UI-Roblox/main/src/utils.lua"))();

local components = {};

function components.createWindow(title)
    local gui = Instance.new("ScreenGui");
    local main = Instance.new("Frame");
    local top = Instance.new("Frame");
    local ttl = Instance.new("TextLabel");
    local close = Instance.new("TextButton");
    local tabsContainer = Instance.new("Frame");
    local contentContainer = Instance.new("Frame");
    
    if syn then syn.protect_gui(gui) end
    gui.Name = "simpleUI";
    gui.Parent = game:GetService("CoreGui");
    
    main.Name = "main";
    main.Parent = gui;
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
    main.BorderSizePixel = 0;
    main.Position = UDim2.new(0.5, -200, 0.5, -150);
    main.Size = UDim2.new(0, 400, 0, 300);
    
    top.Name = "top";
    top.Parent = main;
    top.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    top.BorderSizePixel = 0;
    top.Size = UDim2.new(1, 0, 0, 30);
    
    local topsep = Instance.new("Frame");
    local topsepgrad = Instance.new("UIGradient");
    
    topsep.Name = "topsep";
    topsep.Parent = top;
    topsep.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    topsep.BorderSizePixel = 0;
    topsep.Position = UDim2.new(0, 0, 1, 0);
    topsep.Size = UDim2.new(1, 0, 0, 1);
    
    topsepgrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 20, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 50, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 20, 80))
    });
    topsepgrad.Parent = topsep;
    
    ttl.Name = "title";
    ttl.Parent = top;
    ttl.BackgroundTransparency = 1;
    ttl.Size = UDim2.new(1, -30, 1, 0);
    ttl.Font = Enum.Font.GothamBold;
    ttl.Text = title;
    ttl.TextColor3 = Color3.fromRGB(255, 255, 255);
    ttl.TextSize = 14;
    ttl.TextXAlignment = Enum.TextXAlignment.Left;
    ttl.Position = UDim2.new(0, 10, 0, 0);
    
    close.Name = "close";
    close.Parent = top;
    close.BackgroundTransparency = 1;
    close.Position = UDim2.new(1, -30, 0, 0);
    close.Size = UDim2.new(0, 30, 1, 0);
    close.Font = Enum.Font.GothamBold;
    close.Text = "X";
    close.TextColor3 = Color3.fromRGB(255, 255, 255);
    close.TextSize = 14;
    
    tabsContainer.Name = "tabs";
    tabsContainer.Parent = main;
    tabsContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25);
    tabsContainer.BorderSizePixel = 0;
    tabsContainer.Position = UDim2.new(0, 0, 0, 31);
    tabsContainer.Size = UDim2.new(0, 100, 1, -31);
    tabsContainer.ClipsDescendants = true;
    
    local tabsep = Instance.new("Frame");
    local tabsepgrad = Instance.new("UIGradient");
    
    tabsep.Name = "tabsep";
    tabsep.Parent = tabsContainer;
    tabsep.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    tabsep.BorderSizePixel = 0;
    tabsep.Position = UDim2.new(1, -1, 0, 0);
    tabsep.Size = UDim2.new(0, 1, 1, 0);
    
    tabsepgrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 20, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 50, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 20, 80))
    });
    tabsepgrad.Parent = tabsep;
    tabsepgrad.Rotation = 90;
    
    local tabList = Instance.new("UIListLayout");
    tabList.Parent = tabsContainer;
    tabList.SortOrder = Enum.SortOrder.LayoutOrder;
    tabList.Padding = UDim.new(0, 2);
    tabList.HorizontalAlignment = Enum.HorizontalAlignment.Left;
    tabList.VerticalAlignment = Enum.VerticalAlignment.Top;
    
    local tabPadding = Instance.new("UIPadding");
    tabPadding.Parent = tabsContainer;
    tabPadding.PaddingTop = UDim.new(0, 2);
    
    contentContainer.Name = "content";
    contentContainer.Parent = main;
    contentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
    contentContainer.BorderSizePixel = 0;
    contentContainer.Position = UDim2.new(0, 100, 0, 31);
    contentContainer.Size = UDim2.new(1, -100, 1, -31);
    
    local offset = 0;
    rs.RenderStepped:Connect(function(delta)
        offset = (offset + delta * 0.1) % 1;
        topsepgrad.Offset = Vector2.new(offset, 0);
        tabsepgrad.Offset = Vector2.new(offset, 0);
    end);
    
    utils.makeDraggable(main, top);
    
    close.MouseButton1Click:Connect(function()
        gui:Destroy();
    end);
    
    local win = {};
    local firstTab = true;
    local tabCount = 0;
    
    function win:tab(name)
        local tab = Instance.new("TextButton");
        local page = Instance.new("ScrollingFrame");
        local pageList = Instance.new("UIListLayout");
        local pagePadding = Instance.new("UIPadding");
        
        tabCount = tabCount + 1;
        
        tab.Name = name;
        tab.Parent = tabsContainer;
        tab.BackgroundColor3 = firstTab and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(30, 30, 30);
        tab.BorderSizePixel = 0;
        tab.Size = UDim2.new(1, 0, 0, 30);
        tab.Font = Enum.Font.GothamBold;
        tab.Text = name;
        tab.TextColor3 = Color3.fromRGB(255, 255, 255);
        tab.TextSize = 12;
        tab.AutoButtonColor = false;
        tab.LayoutOrder = tabCount;
        
        page.Name = name;
        page.Parent = contentContainer;
        page.BackgroundTransparency = 1;
        page.BorderSizePixel = 0;
        page.Size = UDim2.new(1, 0, 1, 0);
        page.CanvasSize = UDim2.new(0, 0, 0, 0);
        page.ScrollBarThickness = 2;
        page.Visible = firstTab;
        page.ScrollingEnabled = true;
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y;
        
        pagePadding.Parent = page;
        pagePadding.PaddingLeft = UDim.new(0, 10);
        pagePadding.PaddingRight = UDim.new(0, 10);
        pagePadding.PaddingTop = UDim.new(0, 10);
        
        pageList.Parent = page;
        pageList.SortOrder = Enum.SortOrder.LayoutOrder;
        pageList.Padding = UDim.new(0, 8);
        pageList.HorizontalAlignment = Enum.HorizontalAlignment.Left;
        pageList.VerticalAlignment = Enum.VerticalAlignment.Top;
        
        tab.MouseButton1Click:Connect(function()
            for _, v in ipairs(contentContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = v.Name == name;
                end
            end
            
            for _, v in ipairs(tabsContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundColor3 = v.Name == name and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(30, 30, 30);
                end
            end
        end);
        
        local tabContent = {};
        local elementOrder = 0;
        
        function tabContent:btn(text, callback)
            local button = Instance.new("TextButton");
            
            elementOrder = elementOrder + 1;
            button.LayoutOrder = elementOrder;
            button.Name = text;
            button.Parent = page;
            button.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
            button.BorderSizePixel = 0;
            button.Size = UDim2.new(1, 0, 0, 30);
            button.Font = Enum.Font.GothamBold;
            button.Text = text;
            button.TextColor3 = Color3.fromRGB(255, 255, 255);
            button.TextSize = 12;
            button.AutoButtonColor = false;
            
            button.MouseEnter:Connect(function()
                ts:Create(button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                }):Play();
            end);
            
            button.MouseLeave:Connect(function()
                ts:Create(button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                }):Play();
            end);
            
            button.MouseButton1Click:Connect(callback);
            return button;
        end;
        
        function tabContent:sep(text)
            local sep = Instance.new("Frame");
            local line = Instance.new("Frame");
            local lineGrad = Instance.new("UIGradient");
            local label = Instance.new("TextLabel");
            
            elementOrder = elementOrder + 1;
            sep.LayoutOrder = elementOrder;
            
            sep.Name = "separator";
            sep.Parent = page;
            sep.BackgroundTransparency = 1;
            sep.Size = UDim2.new(1, 0, 0, 20);
            
            line.Parent = sep;
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            line.BorderSizePixel = 0;
            line.Position = UDim2.new(0, 0, 0.5, 0);
            line.Size = UDim2.new(1, 0, 0, 1);
            
            lineGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 20, 80)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 50, 150)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 20, 80))
            });
            lineGrad.Parent = line;
            
            label.Parent = sep;
            label.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
            label.BorderSizePixel = 0;
            label.Position = UDim2.new(0.5, -50, 0, 0);
            label.Size = UDim2.new(0, 100, 1, 0);
            label.Font = Enum.Font.GothamBold;
            label.Text = text;
            label.TextColor3 = Color3.fromRGB(255, 255, 255);
            label.TextSize = 12;
            
            local offset = 0;
            rs.RenderStepped:Connect(function(delta)
                offset = (offset + delta * 0.1) % 1;
                lineGrad.Offset = Vector2.new(offset, 0);
            end);
            
            return sep;
        end;
        
        pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pageList.AbsoluteContentSize.Y + 20);
        end);
        
        if firstTab then
            firstTab = false;
        end
        
        return tabContent;
    end;
    
    return win;
end;

return components;