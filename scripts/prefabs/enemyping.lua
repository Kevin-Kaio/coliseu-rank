local assets =
{
    Asset("ANIM", "anim/reticuleaoe.zip")
}

local PAD_DURATION = .1
local SCALE = 1.5
local FLASH_TIME = .3

local function UpdatePing(inst, s0, s1, t0, duration, multcolour, addcolour)
    if next(multcolour) == nil then
        multcolour[1], multcolour[2], multcolour[3], multcolour[4] = inst.AnimState:GetMultColour()
    end
    if next(addcolour) == nil then
        addcolour[1], addcolour[2], addcolour[3], addcolour[4] = inst.AnimState:GetAddColour()
    end
    local t = GetTime() - t0
    local k = 1 - math.max(0, t - PAD_DURATION) / duration
    k = 1 - k * k
    local s = Lerp(s0, s1, k)
    local c = Lerp(1, 0, k)
    inst.Transform:SetScale(s, s, s)
    inst.AnimState:SetMultColour(c * multcolour[1], c * multcolour[2], c * multcolour[3], c * multcolour[4])

    k = math.min(FLASH_TIME, t) / FLASH_TIME
    c = math.max(0, 1 - k * k)
    inst.AnimState:SetAddColour(c * addcolour[1], c * addcolour[2], c * addcolour[3], c * addcolour[4])
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst.entity:SetCanSleep(false)

    inst.AnimState:SetBank("reticuleaoe")
    inst.AnimState:SetBuild("reticuleaoe")
    inst.AnimState:PlayAnimation("idle_small")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGroundFixed)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetScale(SCALE, SCALE)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

	inst.entity:SetPristine()

    local duration = .5

	if not TheNet:IsDedicated() then
		inst:DoPeriodicTask(0.1, UpdatePing, nil, 1, 1.1, GetTime(), duration, {}, {})
	end

	if TheWorld.ismastersim then
		inst:DoTaskInTime(duration, function ()
			inst:Remove()
		end)
	end

    inst.persists = false

    return inst
end

return Prefab("enemyping", fn, assets)