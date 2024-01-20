GLOBAL.setmetatable(
    env,
    {__index = function(a, b)
            return GLOBAL.rawget(GLOBAL, b)
        end}
)
local ticket_options = {
    [1] = {["prefab"] = "goldnugget", ["number"] = 10},
    [2] = {["prefab"] = "opalpreciousgem", ["number"] = 1},
    [3] = {["prefab"] = "myth_coin_box", ["number"] = 1}
}
local ticket = ticket_options[GetModConfigData("ticket")]
ticket.name = STRINGS.NAMES[string.upper(ticket.prefab)] or "Item desconhecido"
local function checkticket(inv)
    for k, item in pairs(inv.itemslots) do
        if item.prefab == ticket.prefab then
            local itemnumber = item.components.stackable:StackSize()
            if itemnumber > ticket.number then
                item.components.stackable:SetStackSize(itemnumber - ticket.number)
                return true
            elseif itemnumber == ticket.number then
                item:Remove()
                return true
            end
        end
    end
    for k, v in pairs(inv.equipslots) do
        if v:HasTag("backpack") then
            local container = v.components.container
            for i, item in pairs(container.slots) do
                if item.prefab == ticket.prefab then
                    local itemnumber = item.components.stackable:StackSize()
                    if itemnumber >= ticket.number then
                        item.components.stackable:SetStackSize(itemnumber - ticket.number)
                        return true
                    elseif itemnumber == ticket.number then
                        item:Remove()
                        return true
                    end
                end
            end
        end
    end
    return false
end
local ACTIONS = GLOBAL.ACTIONS
local ActionHandler = GLOBAL.ActionHandler
if true then
    local id = "STARTGAME"
    local name = "Iniciar Desafio"
    local fn = function(act)
        if checkticket(act.doer.components.inventory) then
            act.doer.components.talker:Say("A batalha está prestes a começar")
            act.target.components.colosseum_controller:StartGame(act.doer)
        else
			act.doer.components.talker:Say("São necessários " .. ticket.number .. " " .. ticket.name .. " para iniciar o desafio!")
        end
        return true
    end
    AddAction(id, name, fn)
end
if true then
    local id = "SWITCHMODE"
    local name = "Alternar Modo"
    local fn = function(act)
        act.target.components.colosseum_controller:SwitchMode(act.doer)
        return true
    end
    AddAction(id, name, fn)
end
local type = "SCENE"
local component = "colosseum_controller"
local testfn = function(inst, doer, actions, right)
    if inst:HasTag("colosseum") and doer:HasTag("player") and not inst.replica.colosseum_controller.isgaming:value() then
        if right then
            table.insert(actions, ACTIONS.STARTGAME)
        else
            table.insert(actions, ACTIONS.SWITCHMODE)
        end
    end
end
AddComponentAction(type, component, testfn)
local state = "doshortaction"
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.STARTGAME, state))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.STARTGAME, state))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SWITCHMODE, state))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SWITCHMODE, state))
