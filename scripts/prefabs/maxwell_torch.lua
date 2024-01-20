local assets =
{
	Asset("ANIM", "anim/maxwell_torch.zip"),
    Asset("MINIMAP_IMAGE", "maxwelltorch"),
}

local prefabs =
{
    "maxwell_torch_flame",
}

local function changelevels(inst, order)
    for i=1, #order do
        inst.components.burnable:SetFXLevel(order[i])
        Sleep(0.05)
    end
end

local function light(inst)    
    inst.task = inst:StartThread(function() changelevels(inst, inst.lightorder) end)    
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("maxwelltorch.png")

    anim:SetBank("maxwell_torch")
    anim:SetBuild("maxwell_torch")
    anim:PlayAnimation("idle",false)

    inst:AddTag("structure")
    inst:AddTag("colosseum")

    MakeObstaclePhysics(inst, .1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.lightorder = {5, 6, 7, 8, 7}

    inst:AddComponent("colosseum_controller")

    inst:AddComponent("inventory")
    inst.components.inventory.maxslots=200

    inst:AddComponent("burnable")
    inst.components.burnable:AddBurnFX("maxwell_torch_flame", Vector3(0,0,0), "fire_marker")
    inst.components.burnable:SetOnIgniteFn(light)

    local old_ignite=inst.components.burnable.Ignite
    inst.components.burnable.Ignite = function (self,immediate, source, doer)
        if self.inst.components.colosseum_controller.isgaming==false then return end
        old_ignite(self,immediate, source, doer)
    end

    local old_extinguish=inst.components.burnable.Extinguish
    inst.components.burnable.Extinguish = function(self, resetpropagator, heatpct, smotherer)
        if self.inst.components.colosseum_controller.isgaming then return end
        old_extinguish(self, resetpropagator, heatpct, smotherer)
    end

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("maxwell_torch", fn, assets, prefabs),
       MakePlacer("maxwell_torch_placer", "maxwell_torch", "maxwell_torch", "idle")