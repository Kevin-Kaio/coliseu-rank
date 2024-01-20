
local function createlabel(inst)
    local str = inst.str:value()
    local height = inst.height:value()
    local scale = inst.scale:value()
    local colour = inst.colour:value()

    if inst.label == nil then
        inst.label = inst.entity:AddLabel()
    end

    inst.label:SetFont(BODYTEXTFONT)
    inst.label:SetFontSize(scale)
    inst.label:SetWorldOffset(0, height, 0)
    inst.label:SetColour(colour[1]/255,colour[2]/255,colour[3]/255)
    inst.label:SetText(str)
    inst.label:Enable(true)
end


local function settext(inst,str,height,scale,colour)
	if inst  then
        local str=str or "默认字符"
        local height=height or 2.5
        local scale=scale or 30
        local colour=colour or UICOLOURS.GOLD

        inst.height:set(height)
        inst.scale:set(scale)
        inst.colour:set(colour)
        inst.str:set(str)

	end
end



local function fn()
    local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
    inst.entity:AddTag("NOCLICK")
    inst.entity:AddTag("colosseum")

    inst.height = net_float(inst.GUID, "title_height", "heightchange")
    inst.scale = net_byte(inst.GUID, "title_scale", "scalechange")
	inst.colour = net_bytearray(inst.GUID, "title_colour", "colourchange")
    inst.str = net_string(inst.GUID, "title_str", "strchange")

    inst:ListenForEvent("strchange", createlabel)


    inst.entity:SetPristine()

    if TheNet:IsDedicated() or TheNet:GetIsServer() then
		inst.SetText = settext
	end

    return inst
end

return Prefab("colosseum_title", fn)