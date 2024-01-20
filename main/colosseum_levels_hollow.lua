GLOBAL.setmetatable(env,{__index=function(a,b)return GLOBAL.rawget(GLOBAL,b)end})
TUNING.COLOSSEUM_LEVELS_HOLLOW={
    [0]={
        ["name"]="空洞模式",
        ["id"]="hollow"
    },
    [1]={
        ["supply"]={
            [1]={
                ["prefab"]="ruinshat",
                ["number"]=2
            },
            [2]={
                ["prefab"]="voltgoatjelly_spice_chili",
                ["number"]=1
            },
            [3]={
                ["prefab"]="ruins_bat",
                ["number"]=2
            },
            [4]={
                ["prefab"]="perogies",
                ["number"]=5
            }
        },
        ["enemys"]={
            [1]={
                ["prefab"]="hollow_knight",
                ["position"]={["x"]=0,["z"]=-12}
            }
        }
    },
}
local language = TUNING.COLOSSEUM_LANGUAGE
if not language then
    TUNING.COLOSSEUM_LEVELS_HOLLOW[0].name="HollowKnight Mode"
end