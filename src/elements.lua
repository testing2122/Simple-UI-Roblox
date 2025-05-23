local ts = game:GetService("TweenService");
local rs = game:GetService("RunService");

local elements = {};

function elements.createTabHandler(tabContainer, pageContainer)
    local firstTab = true;
    local win = {};
    
    function win:tab(name)
        local tab = Instance.new("TextButton");
        local page = Instance.new("ScrollingFrame");
        local list = Instance.new("UIListLayout");
        
        tab.Name = name;
        tab.Parent = tabContainer;
        tab.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
        tab.BackgroundTransparency = 0.1;
        tab.BorderSizePixel = 0;
        tab.Size = UDim2.new(1, -10, 0, 30); -- Added -10 to keep tabs inside container
        tab.Position = UDim2.new(0, 5, 0, 0); -- Added 5 pixel padding
        tab.Font = Enum.Font.GothamBold;
        tab.Text = name;
        tab.TextColor3 = Color3.fromRGB(255, 255, 255);
        tab.TextSize = 12;
        tab.AutoButtonColor = false;
        
        page.Name = name;
        page.Parent = pageContainer;
        page.BackgroundTransparency = 1;
        page.BorderSizePixel = 0;
        page.Size = UDim2.new(1, 0, 1, 0);
        page.CanvasSize = UDim2.new(0, 0, 0, 0);
        page.ScrollBarThickness = 2;
        page.Visible = firstTab;
        
        list.Parent = page;
        list.SortOrder = Enum.SortOrder.LayoutOrder;
        list.Padding = UDim.new(0, 5);
        
        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y);
        end);
        
        if firstTab then
            tab.BackgroundTransparency = 0;
            firstTab = false;
        end;
        
        tab.MouseButton1Click:Connect(function()
            for _, v in pairs(pageContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false;
                end;
            end;
            
            for _, v in pairs(tabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    ts:Create(v, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.1
                    }):Play();
                end;
            end;
            
            page.Visible = true;
            ts:Create(tab, TweenInfo.new(0.2), {
                BackgroundTransparency = 0
            }):Play();
        end);
        
        local tabContent = {};
        
        function tabContent:btn(text, callback)
            local button = Instance.new("TextButton");
            
            button.Name = text;
            button.Parent = page;
            button.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
            button.BorderSizePixel = 0;
            button.Size = UDim2.new(1, -10, 0, 30);
            button.Font = Enum.Font.GothamBold;
            button.Text = text;
            button.TextColor3 = Color3.fromRGB(255, 255, 255);
            button.TextSize = 12;
            button.AutoButtonColor = false;
            
            button.MouseEnter:Connect(function()
                ts:Create(button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                }):Play();
            end);
            
            button.MouseLeave:Connect(function()
                ts:Create(button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                }):Play();
            end);
            
            button.MouseButton1Click:Connect(callback);
            
            return button;
        end;
        
        function tabContent:sep(text)
            local sep = Instance.new("Frame");
            local label = Instance.new("TextLabel");
            local right = Instance.new("Frame");
            local rightGrad = Instance.new("UIGradient");
            
            sep.Name = "separator";
            sep.Parent = page;
            sep.BackgroundTransparency = 1;
            sep.Size = UDim2.new(1, -10, 0, 20);
            
            label.Parent = sep;
            label.BackgroundTransparency = 1;
            label.Position = UDim2.new(1, -120, 0, 0); -- Moved to right side
            label.Size = UDim2.new(0, 100, 1, 0);
            label.Font = Enum.Font.GothamBold;
            label.Text = text or "•";
            label.TextColor3 = Color3.fromRGB(255, 255, 255);
            label.TextSize = 12;
            
            right.Parent = sep;
            right.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            right.BorderSizePixel = 0;
            right.Position = UDim2.new(0, 10, 0.5, 0); -- Adjusted position
            right.Size = UDim2.new(1, -140, 0, 1); -- Adjusted size
            
            rightGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 20, 80)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 50, 150))
            });
            rightGrad.Parent = right;
            
            local offset = 0;
            rs.RenderStepped:Connect(function(delta)
                offset = (offset + delta * 0.1) % 1;
                rightGrad.Offset = Vector2.new(offset, 0);
            end);
            
            return sep;
        end;
        
        return tabContent;
    end;
    
    return win;
end;

return elements;