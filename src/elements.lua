local ts = game:GetService("TweenService");
local rs = game:GetService("RunService");

local elements = {};

function elements.createTabHandler(tabContainer, pageContainer)
    local firstTab = true;
    local win = {};
    
    function win:tab(name)
        local tab = Instance.new("TextButton");
        local tabgrad = Instance.new("UIGradient");
        local btmsep = Instance.new("Frame");
        local page = Instance.new("Frame");
        local pageList = Instance.new("UIListLayout");
        
        tab.Name = name;
        tab.Parent = tabContainer;
        tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        tab.BorderSizePixel = 0;
        tab.Size = UDim2.new(1, 0, 0, 32);
        tab.Font = Enum.Font.Gotham;
        tab.Text = name;
        tab.TextColor3 = Color3.fromRGB(255, 255, 255);
        tab.TextSize = 12;
        tab.AutoButtonColor = false;
        
        tabgrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 25, 35))
        });
        tabgrad.Parent = tab;
        
        btmsep.Name = "btmsep";
        btmsep.Parent = tab;
        btmsep.BackgroundColor3 = Color3.fromRGB(100, 50, 150);
        btmsep.BorderSizePixel = 0;
        btmsep.Position = UDim2.new(0, 0, 1, 0);
        btmsep.Size = UDim2.new(1, 0, 0, 1);
        btmsep.BackgroundTransparency = 0.5;
        
        page.Name = name;
        page.Parent = pageContainer;
        page.BackgroundTransparency = 1;
        page.Size = UDim2.new(1, 0, 1, 0);
        page.Visible = firstTab;
        
        pageList.Parent = page;
        pageList.SortOrder = Enum.SortOrder.LayoutOrder;
        pageList.Padding = UDim.new(0, 5);
        
        if firstTab then
            tabgrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 30, 40)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 35, 45))
            });
            firstTab = false;
        end;
        
        tab.MouseButton1Click:Connect(function()
            for _, v in pairs(pageContainer:GetChildren()) do
                v.Visible = false;
            end;
            
            for _, v in pairs(tabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    v.TextColor3 = Color3.fromRGB(255, 255, 255);
                    local grad = v:FindFirstChild("UIGradient");
                    if grad then
                        grad.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 25, 35))
                        });
                    end;
                    if v ~= tab then
                        v.Name = v.Name:gsub("_active", "");
                    end;
                end;
            end;
            
            page.Visible = true;
            tab.TextColor3 = Color3.fromRGB(255, 255, 255);
            tab.Name = tab.Name .. "_active";
            tabgrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 30, 40)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 35, 45))
            });
        end);
        
        local tabContent = {};
        
        function tabContent:btn(txt, callback)
            local btn = Instance.new("TextButton");
            local btnframe = Instance.new("Frame");
            
            btnframe.Name = "btnframe";
            btnframe.Parent = page;
            btnframe.BackgroundColor3 = Color3.fromRGB(30, 25, 35);
            btnframe.BorderSizePixel = 0;
            btnframe.Size = UDim2.new(1, -10, 0, 30);
            
            btn.Name = "button";
            btn.Parent = btnframe;
            btn.BackgroundTransparency = 1;
            btn.Size = UDim2.new(1, 0, 1, 0);
            btn.Font = Enum.Font.Gotham;
            btn.Text = "  " .. txt;
            btn.TextColor3 = Color3.fromRGB(255, 255, 255);
            btn.TextSize = 14;
            btn.TextXAlignment = Enum.TextXAlignment.Left;
            
            btn.MouseButton1Click:Connect(function()
                ts:Create(btnframe, TweenInfo.new(0.16), {
                    BackgroundColor3 = Color3.fromRGB(40, 35, 45)
                }):Play();
                
                if callback then callback(); end;
                
                wait(0.16);
                ts:Create(btnframe, TweenInfo.new(0.16), {
                    BackgroundColor3 = Color3.fromRGB(30, 25, 35)
                }):Play();
            end);
            
            return btn;
        end;

        function tabContent:sep(txt)
            local sep = Instance.new("Frame");
            local line1 = Instance.new("Frame");
            local line2 = Instance.new("Frame");
            local lbl = Instance.new("TextLabel");
            
            sep.Name = "separator";
            sep.Parent = page;
            sep.BackgroundTransparency = 1;
            sep.Size = UDim2.new(1, -10, 0, 20);
            
            line1.Name = "line1";
            line1.Parent = sep;
            line1.BackgroundColor3 = Color3.fromRGB(100, 50, 150);
            line1.BorderSizePixel = 0;
            line1.Position = UDim2.new(0, 0, 0.5, 0);
            line1.Size = UDim2.new(0.5, -13, 0, 1);
            line1.BackgroundTransparency = 0.5;
            
            lbl.Name = "text";
            lbl.Parent = sep;
            lbl.BackgroundTransparency = 1;
            lbl.Position = UDim2.new(0.5, -10, 0, 0);
            lbl.Size = UDim2.new(0, 20, 1, 0);
            lbl.Font = Enum.Font.Gotham;
            lbl.Text = txt or "•";
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255);
            lbl.TextSize = 12;
            
            line2.Name = "line2";
            line2.Parent = sep;
            line2.BackgroundColor3 = Color3.fromRGB(100, 50, 150);
            line2.BorderSizePixel = 0;
            line2.Position = UDim2.new(0.5, 13, 0.5, 0);
            line2.Size = UDim2.new(0.5, -13, 0, 1);
            line2.BackgroundTransparency = 0.5;
            
            return sep;
        end;
        
        return tabContent;
    end;
    
    return win;
end;

return elements;