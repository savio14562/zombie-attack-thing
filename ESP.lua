local players = game:GetService("Players")
-- local plr = players.LocalPlayer
local me = players.LocalPlayer
local mec = me.Character
me.CharacterAdded:Connect(function(character)
        mec = character
end)

local drawing = Drawing
local objects = {}
local size = workspace.CurrentCamera.ViewportSize
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        size = workspace.CurrentCamera.ViewportSize
end)

local function charFunc(char,square,line)
        local cf1 = char:GetPivot()*CFrame.new(2,3,0)
        local cf2 = cf1*CFrame.new(-4,-6,0)
        local cam = workspace.CurrentCamera
        local v1,vis = cam:WorldToViewportPoint(cf1.Position)
        v1 = Vector2.new(v1.X,v1.Y)
        local v2,vis = cam:WorldToViewportPoint(cf2.Position)
        v2 = Vector2.new(v2.X,v2.Y)
        -- square.Position = Vector2.new(x,y):Lerp(Vector2.new(x2,y2),.5)
        if vis then
                square.Visible = true
                line.Visible = true
                square.Position = v1
                square.Size = Vector2.new(v2.X-v1.X,v2.Y-v1.Y)
                local dist = (workspace.CurrentCamera.CFrame.Position-char:GetPivot().Position).Magnitude/10
                square.Thickness = math.clamp(10-dist,1,10)
                
        else
                line.Visible = false 
                square.Visible = false        
        end
        line.From = Vector2.new(size.X/2,size.Y/2)
        line.To = v1:Lerp(v2,.5)
        
end

local function playerAdded(plr)
        local color = plr.Head.Color
        local square = drawing.new("Square")
        square.Visible = true
        square.Transparency = 1
        square.Color = color
        local line = drawing.new("Line")
        line.Visible = true 
        line.Thickness = 2
        line.Color = color
        line.Transparency = 1
        objects[plr] = {square,line}
end

workspace.enemies.ChildAdded:Connect(function(thing)
    playerAdded(thing)
    local hum = thing:FindFirstChildWhichIsA("Humanoid")
    hum.HealthChanged:Connect(function()
        if hum.Health <= 0 then 
            local square,line = unpack(objects[player])
            square:Remove()
            line:Remove()
            objects[thing] = nil    
        end 
    end 
end)


game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
        for char,shape in pairs(objects) do
                if char then
                       if char:FindFirstChildWhichIsA("Humanoid") then 
                          charFunc(plr.Character,unpack(shape)) 
                       end 
                end
        end
end)
