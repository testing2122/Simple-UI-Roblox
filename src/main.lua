local lib = {};

function lib:win(title)
    local components = loadstring(game:HttpGet("https://raw.githubusercontent.com/testing2122/Simple-UI-Roblox/main/src/components.lua"))();
    return components.createWindow(title);
end;

return lib;