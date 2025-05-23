local ts = game:GetService("TweenService");

local elements = {};

function elements.createTabHandler(tabContainer, pageContainer)
    local firstTab = true;
    local win = {};
    
    function win:tab(name)
        local tab = Instance.new("TextButton");
        local page = Instance.new("Frame");
        local pageList = Instance.new("UIListLayout");
        
        tab.Name = name;
        tab.Parent = tabContainer;
        tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
        tab.BorderSizePixel = 0;
        tab.Size = UDim2.new(1, 0, 0, 32);
        tab.Font = Enum.Font.Gotham;
        tab.Text = name;
        tab.TextColor3 = Color3.fromRGB(255, 255, 255);
        tab.TextSize = 12;
        tab.AutoButtonColor = false;
        
        page.Name = name;
        page.Parent = pageContainer;
        page.BackgroundTransparency = 1;
        page.Size = UDim2.new(1, 0, 1, 0);
        page.Visible = firstTab;
        
        pageList.Parent = page;
        pageList.SortOrder = Enum.SortOrder.LayoutOrder;
        pageList.Padding = UDim.new(0, 5);
        
        if firstTab then
            tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45);
            firstTab = false;
        end;
        
        tab.MouseButton1Click:Connect(function()
            for _, v in pairs(pageContainer:GetChildren()) do
                v.Visible = false;
            end;
            
            for _, v in pairs(tabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    ts:Create(v, TweenInfo.new(0.16), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play();
                end;
            end;
            
            page.Visible = true;
            ts:Create(tab, TweenInfo.new(0.16), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play();
        end);
        
        local tabContent = {};
        
        function tabContent:btn(txt, callback)
            local btn = Instance.new("TextButton");
            btn.Name = "button";
            btn.Parent = page;
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
            btn.BorderSizePixel = 0;
            btn.Size = UDim2.new(1, -10, 0, 30);
            btn.Position = UDim2.new(0, 5, 0, 0);
            btn.Font = Enum.Font.Gotham;
            btn.Text = txt;
            btn.TextColor3 = Color3.fromRGB(255, 255, 255);
            btn.TextSize = 14;
            
            btn.MouseButton1Click:Connect(function()
                ts:Create(btn, TweenInfo.new(0.16), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play();
                if callback then callback(); end;
                wait(0.16);
                ts:Create(btn, TweenInfo.new(0.16), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play();
            end);
            
            return btn;
        end;
        
        return tabContent;
    end;
    
    return win;
end;

return elements;