GLOBAL.setmetatable(env,{__index=function(a,b)return GLOBAL.rawget(GLOBAL,b)end})
--所有的关卡设置都在main文件夹里
--如果想定制关卡自用，请在上传时选择非公开
--并注上原作者和模组链接，万分感谢
TUNING.COLOSSEUM_DELAY=GetModConfigData("delay")
TUNING.COLOSSEUM_TAG_ANY=GetModConfigData("tagany")
TUNING.COLOSSEUM_TAG_HARD=GetModConfigData("taghard")
TUNING.COLOSSEUM_TAG_ENDLESS=GetModConfigData("tagendless")

STRINGS.NAMES.RANK = "Quadro de Classificação"
STRINGS.NAMES.MAXWELL_TORCH = "Chama do Coliseu"
STRINGS.RECIPE_DESC.MAXWELL_TORCH = "Construa seu próprio Coliseu."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAXWELL_TORCH = "Mal posso esperar para lutar."

Assets = {
    Asset("ATLAS", "images/maxwell_torch.xml"),
    Asset("IMAGE", "images/maxwell_torch.tex"),
	Asset("ANIM", "anim/quest_board.zip"),
}

PrefabFiles =  {
    "colosseum_title",
    "maxwell_torch",
    "maxwell_torch_flame",
    "enemyping",
	"rankboard",
}

modimport("main/colosseum_levels.lua")
modimport("main/colosseum_levels_hard.lua")
modimport("main/colosseum_levels_endless.lua")
TUNING.COLOSSEUM_MODE_OPTIONS={
    [1]=TUNING.COLOSSEUM_LEVELS,
    [2]=TUNING.COLOSSEUM_LEVELS_HARD,
    [3]=TUNING.COLOSSEUM_LEVELS_ENDLESS
}
AddPrefabPostInit("world", function(world)
    if TUNING.KTNDAMAGE~=nil  then
        modimport("main/colosseum_levels_longsword.lua")
        table.insert(TUNING.COLOSSEUM_MODE_OPTIONS,TUNING.COLOSSEUM_LEVELS_LONGSWORD)
    end
    if TUNING.MYTH_CHARACTER_MOD_OPEN~=nil  then
        modimport("main/colosseum_levels_myth.lua")
        table.insert(TUNING.COLOSSEUM_MODE_OPTIONS,TUNING.COLOSSEUM_LEVELS_MYTH)
    end
    if KnownModIndex:IsModEnabled("workshop-2348196117") then
        modimport("main/colosseum_levels_hollow.lua")
        table.insert(TUNING.COLOSSEUM_MODE_OPTIONS,TUNING.COLOSSEUM_LEVELS_HOLLOW)
    end
end)

local maxwell_torch = AddRecipe(
    "maxwell_torch",
    {Ingredient("boards", 10),Ingredient("cutstone", 10),Ingredient("yellowgem", 1)},
    RECIPETABS.TOWN,
    TECH.LOST,
    "maxwell_torch_placer",
    1, nil, nil, nil,
    "images/maxwell_torch.xml",
    "maxwell_torch.tex"
)
maxwell_torch.sortkey = 0

AddPlayerPostInit(function(player)
    if TheWorld.ismastersim then
        player:DoTaskInTime(0,function ()
            if player.Network:IsServerAdmin() or GetModConfigData("permission")==false then
                if not player.components.builder:KnowsRecipe("maxwell_torch") and
                    player.components.builder:CanLearn("maxwell_torch") then
                    player.components.builder:UnlockRecipe("maxwell_torch")
                end
            end
            player.colosseum_title = SpawnPrefab("colosseum_title")
            player.colosseum_title.entity:SetParent(player.entity)
            player.colosseum_title:SetText("",2.8,23,{255,150,0})
        end)
    end
end)

AddReplicableComponent("colosseum_controller")
modimport("main/startgame.lua")