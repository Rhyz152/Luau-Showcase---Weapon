local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Connections = ReplicatedStorage:WaitForChild("Connections")
local PlayerStateConnections = Connections:WaitForChild("PlayerStateConnections")
local StateEnabledEvent: RemoteEvent = PlayerStateConnections:WaitForChild("StateEnabledEvent")

local module = {}

local PlayerStates: {} = {}
local States = {
    ["Unarmed"] = true::boolean,
    ["Armed"] = false::boolean,
    ["Attacking"] = false::boolean,
    ["Stunned"] = false::boolean
}

local function CheckExistingPlayerStates(Player:Player)
    if not PlayerStates[Player] then
        return false
    end
    return true
end

local function CheckValidStateName(Player:Player, StateName:string)
    if PlayerStates[Player][StateName] ~= nil then
        return true     
    end
    
    return false
end

function module.InitPlayerStates(Player:Player)
    if CheckExistingPlayerStates(Player) then return end

    PlayerStates[Player] = table.clone(States)
    print(PlayerStates[Player])
end

function module.EnablePlayerState(Player:Player, StateName:string)
    if not CheckExistingPlayerStates(Player) or not CheckValidStateName(Player, StateName) then return end
    if not RunService:IsServer() then
        Player:Kick("Attempt to enable state from Client? Might be an error, or you should stop exploiting!!!")
        return
    end

    for state, value in pairs(PlayerStates[Player]) do
        if state == StateName then continue end

        PlayerStates[Player][state] = false
    end
    
    PlayerStates[Player][StateName] = true
    StateEnabledEvent:FireClient(Player, StateName)
end

function module.GetPlayerState(Player:Player, StateName:string)
    if not CheckExistingPlayerStates(Player) or not CheckValidStateName(Player, StateName) then return end

    return PlayerStates[Player][StateName]
end

return module