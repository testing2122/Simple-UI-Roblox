local ts = game:GetService("TweenService");
local uis = game:GetService("UserInputService");

local utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/testing2122/Simple-UI-Roblox/main/src/utils.lua"))();
local elements = loadstring(game:HttpGet("https://raw.githubusercontent.com/testing2122/Simple-UI-Roblox/main/src/elements.lua"))();

local components = {};

function components.createWindow(title)
    local gui = Instance.new("ScreenGui");
    local main = Instance.new("Frame");
    local top = Instance.new("Frame");
    local ttl = Instance.new("TextLabel");
    local tabs = Instance.new("Frame");
    local tablist = Instance.new("UIListLayout");
    local pages = Instance.new("Frame");
    local close = Instance.new("TextButton");
    
    gui.Name = "simpleUI";
    gui.Parent = game:GetService("CoreGui");
    
    main.Name = "main";
    main.Parent = gui;
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    main.BorderSizePixel = 0;
    main.Position = UDim2.new(0.5, -200, 0.5, -150);
    main.Size = UDim2.new(0, 400, 0, 300);
    
    top.Name = "top";
    top.Parent = main;
    top.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
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
    
    close.Name = "close";
    close.Parent = top;
    close.BackgroundTransparency = 1;
    close.Position = UDim2.new(1, -30, 0, 0);
    close.Size = UDim2.new(0, 30, 1, 0);
    close.Font = Enum.Font.GothamBold;
    close.Text = "X";
    close.TextColor3 = Color3.fromRGB(255, 255, 255);
    close.TextSize = 14;
    
    tabs.Name = "tabs";
    tabs.Parent = main;
    tabs.BackgroundColor3 = Color3.fromRGB(35, 35, 35);
    tabs.BorderSizePixel = 0;
    tabs.Position = UDim2.new(0, 0, 0, 30);
    tabs.Size = UDim2.new(0, 100, 1, -30);
    
    tablist.Parent = tabs;
    tablist.SortOrder = Enum.SortOrder.LayoutOrder;
    tablist.Padding = UDim.new(0, 2);
    
    pages.Name = "pages";
    pages.Parent = main;
    pages.BackgroundTransparency = 1;
    pages.Position = UDim2.new(0, 105, 0, 35);
    pages.Size = UDim2.new(1, -110, 1, -40);
    
    utils.makeDraggable(main, top);
    
    close.MouseButton1Click:Connect(function()
        gui:Destroy();
    end);
    
    return elements.createTabHandler(tabs, pages);
end;

return components;