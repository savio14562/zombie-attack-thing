local settings = {
        Fov = 64, -- In pixels
        Path = workspace.enemies, -- Change if anything is put in another folder (Check using Dex)
        EnableKey = Enum.KeyCode.V, -- The key that toggles whether or not its enabled. Change if you need to 

        RCLMode = true, -- Uses the mouse cursor 
        LockOn = true, -- If true, snap to position, if not, interpolate quickly
        AimForHead = true, -- Not sure why you wouldnt want this enabled....
        PlayerCheck = false, -- Enable for player check (Checks if its a player or not)
}


local fovcircle = Drawing.new("Circle")
fovcircle.Visible = true
fovcircle.Transparency = 1 
-- fovcircle.Size = Vector2.new(settings.Fov,settings.Fov)
fovcircle.Radius = settings.Fov
fovcircle.Thickness = 4

local enabled = true
local player = game:GetService("Players").LocalPlayer
local params = RaycastParams.new()
local size = workspace.CurrentCamera.ViewportSize

local function wallCheck(thing)
        -- params.FilterDescendantsInstances = {thing,player.Character}
        -- local ray = workspace:Raycast(thing:GetPivot().Position,workspace.CurrentCamera.CFrame.Position)
        -- return ray == nil
        return true
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end 
        if input.KeyCode == settings.EnableKey then
                enabled = not enabled
        end
end)

game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
        if enabled == true then
                local target
                local targetPos
                local maxDist = math.huge
                for i,c in pairs(settings.Path:GetChildren()) do
                        if c:FindFirstChildWhichIsA("Humanoid") then
                                if c == player.Character then
                                        continue
                                end
                                if settings.PlayerCheck then
                                        if not game:GetService("Players"):FindFirstChild(c.Name) then
                                                continue
                                        end
                                end
                                local dist = (workspace.CurrentCamera.CFrame.Position-c:GetPivot().Position).Magnitude
                                local pos,onScreen = workspace.CurrentCamera:WorldToViewportPoint(c:GetPivot().Position)
                                pos = Vector2.new(pos.X,pos.Y)
                                -- if dist < maxDist and wallCheck(c) and onScreen then
                                        
                                -- end
                                if (pos-size/2).Magnitude <= settings.Fov and onScreen then
                                        if (pos-size/2).Magnitude < maxDist then
                                                maxDist = (pos-size/2).Magnitude 
                                                target = c 
                                                targetPos = pos         
                                        end                                                 
                                end
                        end
                end
                if target then
                        --mousemoveabs(targetPos.X,targetPos.Y)
                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position,target.Head.Position)
                end
                fovcircle.Position = game:GetService("UserInputService"):GetMouseLocation()         
        end
end)

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        size = workspace.CurrentCamera.ViewportSize
end)