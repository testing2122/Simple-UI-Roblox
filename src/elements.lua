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
        tab.Size = UDim2.new(1, 0, 0, 30);
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
            local outline = Instance.new("UIStroke");
            local outlineGradient = Instance.new("UIGradient");
            
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
            
            outline.Parent = button;
            outline.Color = Color3.fromRGB(100, 50, 150);
            outline.Thickness = 1;
            
            outlineGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 20, 80)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 50, 150)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 20, 80))
            });
            outlineGradient.Parent = outline;
            
            local offset = 0;
            rs.RenderStepped:Connect(function(delta)
                offset = (offset + delta * 0.1) % 1;
                outlineGradient.Offset = Vector2.new(offset, 0);
            end);
            
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
            local left = Instance.new("Frame");
            local right = Instance.new("Frame");
            local leftGrad = Instance.new("UIGradient");
            local rightGrad = Instance.new("UIGradient");
            
            sep.Name = "separator";
            sep.Parent = page;
            sep.BackgroundTransparency = 1;
            sep.Size = UDim2.new(1, -10, 0, 20);
            
            label.Parent = sep;
            label.BackgroundTransparency = 1;
            label.Position = UDim2.new(0.5, -50, 0, 0);
            label.Size = UDim2.new(0, 100, 1, 0);
            label.Font = Enum.Font.GothamBold;
            label.Text = text or "•";
            label.TextColor3 = Color3.fromRGB(255, 255, 255);
            label.TextSize = 12;
            
            left.Parent = sep;
            left.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            left.BorderSizePixel = 0;
            left.Position = UDim2.new(0, 0, 0.5, 0);
            left.Size = UDim2.new(0.5, -60, 0, 1);
            
            right.Parent = sep;
            right.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            right.BorderSizePixel = 0;
            right.Position = UDim2.new(0.5, 60, 0.5, 0);
            right.Size = UDim2.new(0.5, -60, 0, 1);
            
            leftGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 20, 80)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 50, 150))
            });
            leftGrad.Parent = left;
            
            rightGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 50, 150)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 20, 80))
            });
            rightGrad.Parent = right;
            
            local offset = 0;
            rs.RenderStepped:Connect(function(delta)
                offset = (offset + delta * 0.1) % 1;
                leftGrad.Offset = Vector2.new(offset, 0);
                rightGrad.Offset = Vector2.new(offset, 0);
            end);
            
            return sep;
        end;
        
        return tabContent;
    end;
    
    return win;
end;

return elements;