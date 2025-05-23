local ts = game:GetService("TweenService");
local uis = game:GetService("UserInputService");
local rs = game:GetService("RunService");

local utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/testing2122/Simple-UI-Roblox/main/src/utils.lua"))();
local elements = loadstring(game:HttpGet("https://raw.githubusercontent.com/testing2122/Simple-UI-Roblox/main/src/elements.lua"))();

local components = {};

function components.createWindow(title)
    local gui = Instance.new("ScreenGui");
    local main = Instance.new("Frame");
    local maingrad = Instance.new("UIGradient");
    local top = Instance.new("Frame");
    local topgrad = Instance.new("UIGradient");
    local topsep = Instance.new("Frame");
    local ttl = Instance.new("TextLabel");
    local tabs = Instance.new("Frame");
    local tabsgrad = Instance.new("UIGradient");
    local tablist = Instance.new("UIListLayout");
    local tabsep = Instance.new("Frame");
    local pages = Instance.new("Frame");
    local close = Instance.new("TextButton");
    
    gui.Name = "simpleUI";
    gui.Parent = game:GetService("CoreGui");
    
    main.Name = "main";
    main.Parent = gui;
    main.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    main.BorderSizePixel = 0;
    main.Position = UDim2.new(0.5, -200, 0.5, -150);
    main.Size = UDim2.new(0, 400, 0, 300);
    main.ClipsDescendants = true;
    
    maingrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
    });
    maingrad.Parent = main;
    
    top.Name = "top";
    top.Parent = main;
    top.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    top.BorderSizePixel = 0;
    top.Size = UDim2.new(1, 0, 0, 30);
    
    topgrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 25, 35))
    });
    topgrad.Parent = top;
    
    topsep.Name = "topsep";
    topsep.Parent = top;
    topsep.BackgroundColor3 = Color3.fromRGB(100, 50, 150);
    topsep.BorderSizePixel = 0;
    topsep.Position = UDim2.new(0, 0, 1, 0);
    topsep.Size = UDim2.new(1, 0, 0, 1);
    
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
    
    tabs.Name = "tabs";
    tabs.Parent = main;
    tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    tabs.BorderSizePixel = 0;
    tabs.Position = UDim2.new(0, 0, 0, 31);
    tabs.Size = UDim2.new(0, 100, 1, -31);
    
    tabsgrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 20, 30))
    });
    tabsgrad.Parent = tabs;
    
    tablist.Parent = tabs;
    tablist.SortOrder = Enum.SortOrder.LayoutOrder;
    tablist.Padding = UDim.new(0, 0);
    
    tabsep.Name = "tabsep";
    tabsep.Parent = tabs;
    tabsep.BackgroundColor3 = Color3.fromRGB(100, 50, 150);
    tabsep.BorderSizePixel = 0;
    tabsep.Position = UDim2.new(1, 0, 0, 0);
    tabsep.Size = UDim2.new(0, 1, 1, 0);
    
    pages.Name = "pages";
    pages.Parent = main;
    pages.BackgroundTransparency = 1;
    pages.Position = UDim2.new(0, 110, 0, 40);
    pages.Size = UDim2.new(1, -120, 1, -50);
    
    -- Animated gradients
    local gradients = {maingrad, topgrad, tabsgrad};
    local gradientInfo = {
        {
            colors = {
                Color3.fromRGB(15, 15, 20),
                Color3.fromRGB(20, 20, 25)
            }
        },
        {
            colors = {
                Color3.fromRGB(25, 25, 30),
                Color3.fromRGB(30, 25, 35)
            }
        },
        {
            colors = {
                Color3.fromRGB(20, 20, 25),
                Color3.fromRGB(25, 20, 30)
            }
        }
    };

    local function lerpColor(c1, c2, t)
        return Color3.new(
            c1.R + (c2.R - c1.R) * t,
            c1.G + (c2.G - c1.G) * t,
            c1.B + (c2.B - c1.B) * t
        );
    end;

    local gradientColors = {
        Color3.fromRGB(60, 20, 80),  -- Dark purple
        Color3.fromRGB(100, 50, 150), -- Purple
        Color3.fromRGB(80, 20, 100),  -- Deep purple
        Color3.fromRGB(40, 20, 60)    -- Very dark purple
    };
    
    local colorIndex = 1;
    local lerpValue = 0;
    
    rs.RenderStepped:Connect(function(delta)
        lerpValue = lerpValue + delta * 0.5;
        
        if lerpValue >= 1 then
            lerpValue = 0;
            colorIndex = (colorIndex % #gradientColors) + 1;
        end;
        
        local currentColor = gradientColors[colorIndex];
        local nextColor = gradientColors[colorIndex % #gradientColors + 1];
        local lerpedColor = lerpColor(currentColor, nextColor, lerpValue);
        
        for i, grad in ipairs(gradients) do
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, gradientInfo[i].colors[1]:Lerp(lerpedColor, 0.1)),
                ColorSequenceKeypoint.new(1, gradientInfo[i].colors[2]:Lerp(lerpedColor, 0.2))
            });
        end;
    end);
    
    utils.makeDraggable(main, top);
    
    close.MouseButton1Click:Connect(function()
        gui:Destroy();
    end);
    
    return elements.createTabHandler(tabs, pages);
end;

return components;