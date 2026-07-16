local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ClientAssets = ReplicatedStorage:WaitForChild("ClientAssets")

--// Animations
local AnimationsFolder = ReplicatedStorage:WaitForChild("Animations")
local ZanpakutoAnimations = AnimationsFolder:WaitForChild("ZanpakutoAnimations")
local Swing1Anim: Animation = ZanpakutoAnimations:WaitForChild("Swing1Anim")
local Swing2Anim: Animation = ZanpakutoAnimations:WaitForChild("Swing2Anim")
local Swing3Anim: Animation = ZanpakutoAnimations:WaitForChild("Swing3Anim")
local FinisherSwingAnim: Animation = ZanpakutoAnimations:WaitForChild("FinisherAnim")

--// SFXs
local SFXAssets = ClientAssets:WaitForChild("SFX")
local EffectsFolder = SFXAssets:WaitForChild("Effects")
local SlashSFX: Sound = EffectsFolder:WaitForChild("SlashSFX")
local HitSFX: Sound = EffectsFolder:WaitForChild("HitSFX")

--// VFXs
local VFXAssets = ClientAssets:WaitForChild("VFX")
local CombatVFX = VFXAssets:WaitForChild("CombatVFX")
local SlashVFX: BasePart = CombatVFX:WaitForChild("SlashVFXPart")
local HitVFXPart: BasePart = CombatVFX:WaitForChild("HitVFXPart")

local ComboDelay: number = 0.5
local ComboResetDelay: number = 3

type CombatData = {
    Name: string,
    AnimationId: string,
    SlashSound: Sound,
    HitSound: Sound,
    VFXPart: BasePart,
    HitVFX: BasePart,
    Damage: number,
    KnockbackMultiplier: number,
    Cooldown: number,
}

local module = {}

module.Swing1 = {
    Name = "Swing1",
    AnimationId = Swing1Anim.AnimationId,
    SlashSound = SlashSFX,
    HitSound = HitSFX,
    VFXPart = SlashVFX,
    HitVFX = HitVFXPart,
    Damage = 7.5,
    KnockbackMultiplier = 1,
    Cooldown = ComboResetDelay,

}::CombatData

module.Swing2 = {
    Name = "Swing2",
    AnimationId = Swing2Anim.AnimationId,
    SlashSound = SlashSFX,
    HitSound = HitSFX,
    VFXPart = SlashVFX,
    HitVFX = HitVFXPart,
    Damage = 7.5,
    KnockbackMultiplier = 1,
    Cooldown = ComboDelay,

}::CombatData

module.Swing3 = {
    Name = "Swing3",
    AnimationId = Swing3Anim.AnimationId,
    SlashSound = SlashSFX,
    HitSound = HitSFX,
    VFXPart = SlashVFX,
    HitVFX = HitVFXPart,
    Damage = 7.5,
    KnockbackMultiplier = 1,
    Cooldown = ComboDelay,

}::CombatData

module.FinisherSwing = {
    Name = "FinisherSwing",
    AnimationId = FinisherSwingAnim.AnimationId,
    SlashSound = SlashSFX,
    HitSound = HitSFX,
    VFXPart = SlashVFX,
    HitVFX = HitVFXPart,
    Damage = 12.5,
    KnockbackMultiplier = 1.75,
    Cooldown = ComboDelay,

}::CombatData

return module