--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--// Connections
local Connections = ReplicatedStorage.Connections
local CombatConnections = Connections.CombatConnections
local ClientMeleeRequest: RemoteFunction = CombatConnections.ClientMeleeRequest
local HitboxDetectionRequest: RemoteFunction = CombatConnections.HitboxDetectionRequest

--// Shared
local Shared = ReplicatedStorage.Shared
local SharedUtils = Shared.SharedUtils
local PlayerStateUtils = SharedUtils.PlayerStateUtils
local CooldownUtils = SharedUtils.CooldownUtils
local KnockbackUtils = SharedUtils.KnocbackUtils
local PlayerStateController = require(PlayerStateUtils.PlayerStateController)
local CooldownHandler = require(CooldownUtils.CooldownHandler)
local KnockbackHandler = require(KnockbackUtils.KnockbackHandler)
local SharedDataModules = Shared.SharedDataModules
local CombatData = require(SharedDataModules.CombatDataModules.CombatData)

--// Main
local module = {}

local function VerifyPlayerStates(Player: Player)
    if PlayerStateController.GetPlayerState(Player, "Unarmed") then return false end
    if PlayerStateController.GetPlayerState(Player, "Blocking") then return false end
    if PlayerStateController.GetPlayerState(Player, "Stunned") then return false end

    return true
end

function module.Start()
    --// Main - melee
    local LastMeleeRequest: {} = {}
    local CurrentPlayerCombo: {} = {}
    local ActiveCombatKey: {} = {}

    ClientMeleeRequest.OnServerInvoke = function(Player: Player)
        if not VerifyPlayerStates(Player) then return false, nil end
        local LastAttack = LastMeleeRequest[Player] or 0
        if os.clock() - LastAttack > 1.75 then
            CurrentPlayerCombo[Player] = 1
        end

        local ComboIndex = CurrentPlayerCombo[Player] or 1
        local CombatDataKey = CombatData["Swing" .. ComboIndex] or CombatData.FinisherSwing
        if not CombatDataKey then warn("CombatDataKey not made"); return false, CurrentPlayerCombo end

        local IsCooldown = CooldownHandler.CheckCooldown(Player, CombatDataKey.Cooldown, LastMeleeRequest)
        if IsCooldown then 
            return false, nil
        end

        ActiveCombatKey[Player] = CombatDataKey
        
        CurrentPlayerCombo[Player] = if ComboIndex >= 4 then 1 else ComboIndex + 1

        PlayerStateController.EnablePlayerState(Player, "Attacking")
        task.defer(function()
            task.wait(0.5)
            PlayerStateController.EnablePlayerState(Player, "Armed")
        end)
        return true, CombatDataKey
    end

    --// Main - spatial query
    HitboxDetectionRequest.OnServerInvoke = function(Player: Player, HitboxCframe: CFrame, HitboxSize: Vector3)
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local HumanoidRootPart: BasePart = Character:WaitForChild("HumanoidRootPart")
        local AlreadyHit: {} = {}

        local CombatKey = ActiveCombatKey[Player]

        local Damage = CombatKey.Damage
        local KnockbackMultiplier = CombatKey.KnockbackMultiplier

        for _, Part in pairs(workspace:GetPartBoundsInBox(HitboxCframe, HitboxSize)) do
            if not Part:IsA("BasePart") then continue end

            local OtherCharacter = Part:FindFirstAncestorOfClass("Model") or Part:FindFirstChildOfClass("Model")
            if not OtherCharacter or AlreadyHit[OtherCharacter] or OtherCharacter == Character then continue end
            AlreadyHit[OtherCharacter] = true

            local OtherHumanoid = OtherCharacter:FindFirstChildOfClass("Humanoid")
            if not OtherHumanoid then continue end

            local OtherHrp = OtherCharacter.PrimaryPart:: BasePart
            if not OtherHrp or OtherHrp.Name ~= "HumanoidRootPart" then continue end

            OtherHumanoid.WalkSpeed = 0
            OtherHumanoid:TakeDamage(Damage)

            local BaseForce: number = 50
            if CombatKey.Name == CombatData.FinisherSwing.Name then
                print(CombatKey.Name)
                KnockbackHandler.ApplyKnockBack(OtherCharacter, OtherHrp, KnockbackMultiplier, BaseForce, HumanoidRootPart.CFrame.LookVector)
            end

            task.defer(function()
                OtherHumanoid.WalkSpeed = 16
            end)
            return OtherHrp
        end

        return nil
    end
    
    --// Cleanup
    Players.PlayerRemoving:Connect(function(Player: Player)
        LastMeleeRequest[Player] = nil
        CurrentPlayerCombo[Player] = nil
        ActiveCombatKey[Player] = nil
    end)
end

return module