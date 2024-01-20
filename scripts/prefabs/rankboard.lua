local assets =
{
	Asset("ANIM", "anim/quest_board.zip"),
}

local function getTop5(player)
    local nomeJogador = player
    local onda = 0
    local arquivoRanking = "rank.txt"
    local topRanking = {}

    local arquivo = io.open(arquivoRanking, "r")
    if arquivo then
		local contadorLinhas = 0

		for linha in arquivo:lines() do
			contadorLinhas = contadorLinhas + 1

			if contadorLinhas > 5 then
				break
			end

			local nome, ondaAlcancada = linha:match("([^,]+),([^,]+)")
			table.insert(topRanking, {rank = contadorLinhas, nome = nome, onda = ondaAlcancada})
		end
		arquivo:close()

        local encontrado = false
        for i, jogador in ipairs(topRanking) do
            if jogador.nome == nomeJogador then
                encontrado = true
                break
            end
        end

        if not encontrado then
            contadorLinhas = 0
			arquivo = io.open(arquivoRanking, "r")
            for jogador in arquivo:lines() do
				contadorLinhas = contadorLinhas + 1
				local nome, ondaAlcancada = jogador:match("([^,]+),([^,]+)")
                if nome == nomeJogador then
                    encontrado = true
					table.insert(topRanking, {rank = contadorLinhas, nome = nome, onda = ondaAlcancada})
                    break
                end
            end

            if not encontrado then
				contadorLinhas = 0
				for _ in io.lines(arquivoRanking) do
					contadorLinhas = contadorLinhas + 1
				end
                table.insert(topRanking, {rank = contadorLinhas, nome = nomeJogador, onda = '0'})
            end
        end
		
		return topRanking
    end
	
	return topRanking
end

local PopupDialogScreen = require "screens/popupdialog"
local function CustomPopupDialogScreen(title, text, buttons)
    local popup = PopupDialogScreen(title, text, buttons)

    popup.bg:SetSize(300, 300)
    popup.bg.fill:SetScale(1.6, 1.6) 

    popup.title:SetPosition(0, 230, 0)

    popup.text:SetPosition(0, 20, 0)
	popup.text:SetRegionSize(500, 500)
	
	popup.menu:SetPosition(-(200*(#buttons-1))/2, -230, 0)

    return popup
end

local function MostrarAviso(lista)
    local titulo = "TOP RANK"
    local texto = ""

    local espacamentoColunas = 15

    texto = texto .. string.rep("-", espacamentoColunas * 3) .. "\n"
    texto = texto .. string.format("%-"..(espacamentoColunas-1).."s %-"..(espacamentoColunas-1).."s %-"..(espacamentoColunas-1).."s\n", "Nº", "NOME", "ONDA")
    texto = texto .. string.rep("-", espacamentoColunas * 3) .. "\n"

    for i, valor in ipairs(lista) do
        texto = texto .. string.format("%-"..espacamentoColunas.."d %-"..espacamentoColunas.."s %-"..espacamentoColunas.."s", valor.rank, valor.nome, valor.onda)
        texto = texto .. "\n" .. string.rep("-", espacamentoColunas * 3) .. "\n"

        if #lista == 6 and i == 5 then
            texto = "\n\n"..texto
        end
    end

    local botoes = {
        {
            text = "OK",
            cb = function()
                TheFrontEnd:PopScreen()
            end,
        },
    }

    local telaAviso = PopupDialogScreen(titulo, texto, botoes)
    TheFrontEnd:PushScreen(telaAviso)
end


local function OnOpenRank(inst, doer)
    inst.components.activatable.inactive = true
	if doer then
		local topPlayers = getTop5(doer:GetDisplayName())
		MostrarAviso(topPlayers)
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 1.1)

	inst.AnimState:SetBank("quest_board")
	inst.AnimState:SetBuild("quest_board")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("structure")
	inst:AddTag("rank")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("activatable")
	inst.components.activatable.OnActivate = OnOpenRank
	inst.components.activatable.inactive = true
	
	return inst
end

return 	Prefab("rank", fn, assets)
