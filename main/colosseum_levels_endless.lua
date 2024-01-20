GLOBAL.setmetatable(env,{__index=function(a,b)return GLOBAL.rawget(GLOBAL,b)end})
TUNING.COLOSSEUM_LEVELS_ENDLESS={
    [0]={
        ["name"]="无尽模式",
        ["id"]="endless"
    }
}
local language = TUNING.COLOSSEUM_LANGUAGE
if not language then
    TUNING.COLOSSEUM_LEVELS_ENDLESS[0].name="Endless Mode"
end