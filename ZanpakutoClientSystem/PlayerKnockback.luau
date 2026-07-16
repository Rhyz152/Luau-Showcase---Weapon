local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--// Connections
local Connections = ReplicatedStorage:WaitForChild("Connections")
local KnockbackConnections = Connections:WaitForChild("KnockbackConnections")
local KnockbackEvent: RemoteEvent = KnockbackConnections:WaitForChild("KnockbackEvent")

local LocalPlayer = Players.LocalPlayer

local module = {}

function module.Start()
    KnockbackEvent.OnClientEvent:Connect(function(KnockbackVelocity: Vector3)
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local RootPart = Character:WaitForChild("HumanoidRootPart"):: BasePart

        if RootPart then
            RootPart.AssemblyLinearVelocity += KnockbackVelocity
        end
    end)
end

return module