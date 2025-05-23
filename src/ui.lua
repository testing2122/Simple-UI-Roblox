local ts = game:GetService("TweenService");
local uis = game:GetService("UserInputService");

local lib = {};
local win = {};

function lib:win(title)
    local gui = Instance.new("ScreenGui");
    local main = Instance.new("Frame");
    local top = Instance.new("Frame");
    local ttl = Instance.new("TextLabel");
    local cont = Instance.new("Frame");
    local uil = Instance.new("UIListLayout");
    local close = Instance.new("TextButton");
    
    gui.Name = "simpleUI";
    gui.Parent = game:GetService("CoreGui");
    
    main.Name = "main";
    main.Parent = gui;
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    main.BorderSizePixel = 0;
    main.Position = UDim2.new(0.5, -150, 0.5, -100);
    main.Size = UDim2.new(0, 300, 0, 200);
    
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
    
    cont.Name = "container";
    cont.Parent = main;
    cont.BackgroundTransparency = 1;
    cont.Position = UDim2.new(0, 0, 0, 35);
    cont.Size = UDim2.new(1, 0, 1, -35);
    
    uil.Parent = cont;
    uil.SortOrder = Enum.SortOrder.LayoutOrder;
    uil.Padding = UDim.new(0, 5);
    
    local dragging;
    local dragInput;
    local dragStart;
    local startPos;
    
    local function upd(input)
        local delta = input.Position - dragStart;
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y);
    end;
    
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true;
            dragStart = input.Position;
            startPos = main.Position;
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false;
                end;
            end);
        end;
    end);
    
    top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input;
        end;
    end);
    
    uis.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            upd(input);
        end;
    end);
    
    close.MouseButton1Click:Connect(function()
        gui:Destroy();
    end);
    
    local win = {};
    
    function win:btn(txt, callback)
        local btn = Instance.new("TextButton");
        btn.Name = "button";
        btn.Parent = cont;
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
        btn.BorderSizePixel = 0;
        btn.Size = UDim2.new(1, -10, 0, 30);
        btn.Position = UDim2.new(0, 5, 0, 0);
        btn.Font = Enum.Font.Gotham;
        btn.Text = txt;
        btn.TextColor3 = Color3.fromRGB(255, 255, 255);
        btn.TextSize = 14;
        
        btn.MouseButton1Click:Connect(function()
            ts:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play();
            wait(0.1);
            ts:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play();
            if callback then callback(); end;
        end);
        
        return btn;
    end;
    
    return win;
end;

return lib;