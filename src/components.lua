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
    tabsContainer.Position = UDim2.new(0, 0, 0, 30);
    tabsContainer.Size = UDim2.new(0, 100, 1, -30);
    
    local tabList = Instance.new("UIListLayout");
    tabList.Parent = tabsContainer;
    tabList.SortOrder = Enum.SortOrder.LayoutOrder;
    tabList.Padding = UDim.new(0, 2);
    
    contentContainer.Name = "content";
    contentContainer.Parent = main;
    contentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
    contentContainer.BorderSizePixel = 0;
    contentContainer.Position = UDim2.new(0, 100, 0, 30);
    contentContainer.Size = UDim2.new(1, -100, 1, -30);
    
    utils.makeDraggable(main, top);
    
    close.MouseButton1Click:Connect(function()
        gui:Destroy();
    end);
    
    local win = {};
    local firstTab = true;
    
    function win:tab(name)
        local tab = Instance.new("TextButton");
        local page = Instance.new("ScrollingFrame");
        local pageList = Instance.new("UIListLayout");
        
        tab.Name = name;
        tab.Parent = tabsContainer;
        tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
        tab.BorderSizePixel = 0;
        tab.Size = UDim2.new(1, 0, 0, 30);
        tab.Font = Enum.Font.GothamBold;
        tab.Text = name;
        tab.TextColor3 = Color3.fromRGB(255, 255, 255);
        tab.TextSize = 12;
        tab.AutoButtonColor = false;
        
        page.Name = name;
        page.Parent = contentContainer;
        page.BackgroundTransparency = 1;
        page.BorderSizePixel = 0;
        page.Size = UDim2.new(1, 0, 1, 0);
        page.CanvasSize = UDim2.new(0, 0, 0, 0);
        page.ScrollBarThickness = 2;
        page.Visible = firstTab;
        
        pageList.Parent = page;
        pageList.SortOrder = Enum.SortOrder.LayoutOrder;
        pageList.Padding = UDim.new(0, 5);
        pageList.HorizontalAlignment = Enum.HorizontalAlignment.Center;
        
        if firstTab then
            tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
            firstTab = false;
        end
        
        tab.MouseButton1Click:Connect(function()
            for _, v in pairs(contentContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false;
                end
            end
            
            for _, v in pairs(tabsContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
                end
            end
            
            page.Visible = true;
            tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
        end);
        
        local tabContent = {};
        
        function tabContent:btn(text, callback)
            local button = Instance.new("TextButton");
            
            button.Name = text;
            button.Parent = page;
            button.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
            button.BorderSizePixel = 0;
            button.Size = UDim2.new(1, -20, 0, 30);
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
            local label = Instance.new("TextLabel");
            
            sep.Name = "separator";
            sep.Parent = page;
            sep.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
            sep.BorderSizePixel = 0;
            sep.Size = UDim2.new(1, -20, 0, 1);
            
            label.Parent = sep;
            label.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
            label.BorderSizePixel = 0;
            label.Position = UDim2.new(0.5, -40, -0.5, 0);
            label.Size = UDim2.new(0, 80, 0, 16);
            label.Font = Enum.Font.GothamBold;
            label.Text = text;
            label.TextColor3 = Color3.fromRGB(255, 255, 255);
            label.TextSize = 10;
            
            return sep;
        end;
        
        pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pageList.AbsoluteContentSize.Y);
        end);
        
        return tabContent;
    end;
    
    return win;
end;

return components;