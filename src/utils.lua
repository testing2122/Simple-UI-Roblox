local ts = game:GetService("TweenService");
local uis = game:GetService("UserInputService");

local utils = {};

function utils.makeDraggable(main, handle)
    local dragging;
    local dragInput;
    local dragStart;
    local startPos;
    
    local function upd(input)
        local delta = input.Position - dragStart;
        local target = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y);
        ts:Create(main, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {Position = target}):Play();
    end;
    
    handle.InputBegan:Connect(function(input)
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
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input;
        end;
    end);
    
    uis.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            upd(input);
        end;
    end);
end;

return utils;