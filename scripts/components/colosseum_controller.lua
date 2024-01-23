local R = 24
local radious = math.pi / 180
local delay = TUNING.COLOSSEUM_DELAY
local levels = TUNING.COLOSSEUM_LEVELS
local tagany = TUNING.COLOSSEUM_TAG_ANY
local taghard = TUNING.COLOSSEUM_TAG_HARD
local tagendless = TUNING.COLOSSEUM_TAG_ENDLESS

local rewards = {
    [1] = {["prefab"] = "boomerang",     ["number"] = 1, ["mode"] = "easy", ["level"] = 15},
    [2] = {["prefab"] = "nightsword",    ["number"] = 1, ["mode"] = "easy", ["level"] = 15},
    [3] = {["prefab"] = "footballhat",   ["number"] = 1, ["mode"] = "easy", ["level"] = 15},
    [4] = {["prefab"] = "armor_sanity",  ["number"] = 1, ["mode"] = "easy", ["level"] = 15},
    [5] = {["prefab"] = "amulet",        ["number"] = 1, ["mode"] = "easy", ["level"] = 15},
    [6] = {["prefab"] = "walking_stick", ["number"] = 1, ["mode"] = "easy", ["level"] = 15},

    [7] = {["prefab"] = "whip",          ["number"] = 1, ["mode"] = "hard", ["level"] = 18},
    [8] = {["prefab"] = "ruins_bat",     ["number"] = 1, ["mode"] = "hard", ["level"] = 18},
    [9] = {["prefab"] = "ruinshat",      ["number"] = 1, ["mode"] = "hard", ["level"] = 18},
    [10] = {["prefab"] = "armorruins",   ["number"] = 1, ["mode"] = "hard", ["level"] = 18},
    [11] = {["prefab"] = "orangestaff",  ["number"] = 1, ["mode"] = "hard", ["level"] = 18},
    [12] = {["prefab"] = "yellowamulet", ["number"] = 1, ["mode"] = "hard", ["level"] = 18},
}

local weapons = {
    [1] = "spear_wathgrithr",
    [2] = "spear_wathgrithr",
    [3] = "ruins_bat",
    [4] = "nightsword",
    [5] = "glasscutter",
    [6] = "batbat"
}

local armors = {[1] = "wathgrithrhat", [2] = "wathgrithrhat", [3] = "ruinshat", [4] = "footballhat"}
local foods = {
    [1] = "meat_dried",
    [2] = "meat_dried",
    [3] = "meat_dried",
    [4] = "meat_dried",
    [5] = "meat_dried",
    [6] = "fishsticks",
    [7] = "fishsticks",
    [8] = "fishsticks",
    [9] = "fishsticks",
    [10] = "perogies",
    [11] = "perogies",
    [12] = "perogies",
    [13] = "jellybean_spice_chili",
    [14] = "voltgoatjelly_spice_chili"
}
local enemys = {
    [1] = {["prefab"] = "tallbird", ["difficulty"] = 80},
    [2] = {["prefab"] = "pigguard", ["difficulty"] = 80},
    [3] = {["prefab"] = "icehound", ["difficulty"] = 50},
    [4] = {["prefab"] = "firehound", ["difficulty"] = 50},
    [5] = {["prefab"] = "spiderqueen", ["difficulty"] = 120},
    [6] = {["prefab"] = "worm", ["difficulty"] = 60},
    [7] = {["prefab"] = "leif", ["difficulty"] = 70},
    [8] = {["prefab"] = "krampus", ["difficulty"] = 70},
    [9] = {["prefab"] = "spider_warrior", ["difficulty"] = 40},
    [10] = {["prefab"] = "bishop", ["difficulty"] = 80},
    [11] = {["prefab"] = "knight", ["difficulty"] = 60},
    [12] = {["prefab"] = "deerclops", ["difficulty"] = 250},
    [13] = {["prefab"] = "klaus", ["difficulty"] = 280},
    [14] = {["prefab"] = "minotaur", ["difficulty"] = 300},
    [15] = {["prefab"] = "spider_dropper", ["difficulty"] = 45},
    [16] = {["prefab"] = "rook", ["difficulty"] = 100},
    [17] = {["prefab"] = "moose", ["difficulty"] = 250},
    [18] = {["prefab"] = "archive_centipede", ["difficulty"] = 140},
    [19] = {["prefab"] = "bunnyman", ["difficulty"] = 60},
    [20] = {["prefab"] = "bearger", ["difficulty"] = 230}
}
local enemys_myth = {
    [1] = {["prefab"] = "blackbear", ["difficulty"] = 250},
    [2] = {["prefab"] = "rhino3_blue", ["difficulty"] = 260},
    [3] = {["prefab"] = "rhino3_red", ["difficulty"] = 260},
    [4] = {["prefab"] = "rhino3_yellow", ["difficulty"] = 260}
}
local enemys_legion = {[1] = {["prefab"] = "elecarmet", ["difficulty"] = 320}}
local enemys_hollow = {[1] = {["prefab"] = "hollow_knight", ["difficulty"] = 320}}

local dropsPermitidos = {
    ["meat"] =          {["percent"] = 20},
    ["monstermeat"] =   {["percent"] = 20},
    ["drumstick"] =     {["percent"] = 20},
    ["yellowgem"] =     {["percent"] = 20},
    ["orangegem"] =     {["percent"] = 20},
    ["greengem"] =      {["percent"] = 20},
    ["redgem"] =        {["percent"] = 20},
    ["purplegem"] =     {["percent"] = 20},
    ["bluegem"] =       {["percent"] = 20},
    ["livinglog"] =     {["percent"] = 20},
    ["goose_feather"] = {["percent"] = 20},
    ["gears"] =         {["percent"] = 20},
    ["houndstooth"] =   {["percent"] = 20},
    ["silk"] =          {["percent"] = 20},
}

local tagsGlobal = {"legend_weapon", "myth_removebydespwn"}
local prefabsGlobal = {"longsword", "blackdragon_sword"}

local function intable(t, v)
    for key, value in pairs(t) do
        if value == v then
            return true
        end
    end
    return false
end

local inventarioTemp = {
    itemslots = {},
    equipslots = {},
}

local function gerenciarInventario(inv1, annotation, toPlayer)
    if toPlayer then 
        for _, item in pairs(inventarioTemp.equipslots) do
            inv1:Equip(item)
        end
        
        for _, item in pairs(inventarioTemp.itemslots) do
            inv1:GiveItem(item)
            TheNet:Announce("prefab:" .. item.prefab)
        end
        
        inventarioTemp.itemslots = {}
        inventarioTemp.equipslots = {}
        
        return
    end
    
    local prefabsLocal = {}
    for _, v in ipairs(prefabsGlobal) do
        table.insert(prefabsLocal, v)
    end

    table.insert(prefabsLocal, "cane")
    table.insert(prefabsLocal, "abigail_flower")
    
    local itensTemporarios = {}

    for k, item in pairs(inv1.itemslots) do
        local move = true
        for key, value in pairs(tagsGlobal) do
            if item:HasTag(value) then
                move = false
            end
        end
        if intable(prefabsGlobal, item.prefab) then
            move = false
        end
        if move then
            if annotation then
                table.insert(inventarioTemp.itemslots, item)
            end
            
            inv1:RemoveItemBySlot(k)
        end
    end

    for k, v in pairs(inv1.equipslots) do
        if v:HasTag("backpack") then
            local container = v.components.container
            for i, item in pairs(container.slots) do
                local move = true
                for key, value in pairs(tagsGlobal) do
                    if item:HasTag(value) then
                        move = false
                    end
                end
                if intable(prefabsGlobal, item.prefab) then
                    move = false
                end
                if move then
                    if annotation then
                        table.insert(inventarioTemp.itemslots, item)
                    end
                    
                    container:RemoveItemBySlot(i)
                end
            end
        else
            local move = true
            for key, value in pairs(tagsGlobal) do
                if v:HasTag(value) then
                    move = false
                end
            end
            if intable(prefabsGlobal, v.prefab) then
                move = false
            end
            if move then
                if annotation then
                    table.insert(inventarioTemp.equipslots, v)
                end 
                
                inv1:Unequip(k)
            end
        end
    end
end

local function cleanup(x, _, z, player, inv)
    local ents = TheSim:FindEntities(x, _, z, R - 0.2)
    for i, v in ipairs(ents) do
        if
            not v:HasTag("player") and not v:HasTag("colosseum") and not v:HasTag("FX") and not v:HasTag("NOCLICK") and
                not v:HasTag("critter") and
                not v.inlimbo and
                v.prefab ~= "abigail"
         then
            local x, _, z = v.Transform:GetWorldPosition()
            if inv ~= nil and not inv:IsFull() and v.components.inventoryitem and v.components.health == nil then
                inv:GiveItem(v)
            else
                v:Remove()
            end
            if math.random() > 0.5 then
                SpawnPrefab("sand_puff").Transform:SetPosition(x, _, z)
            end
        elseif v:HasTag("player") and player ~= nil and v ~= player then
            v.Transform:SetPosition(x, _, z + R + 6)
        end
    end
end

local function needweapons(inv)
    for k, item in pairs(inv.itemslots) do
        for key, value in pairs(tagsGlobal) do
            if item:HasTag(value) then
                return false
            end
        end
        if intable(prefabsGlobal, item.prefab) then
            return false
        end
    end
    for k, v in pairs(inv.equipslots) do
        if v:HasTag("backpack") then
            local container = v.components.container
            for i, item in pairs(container.slots) do
                for key, value in pairs(tagsGlobal) do
                    if item:HasTag(value) then
                        return false
                    end
                end
                if intable(prefabsGlobal, item.prefab) then
                    return false
                end
            end
        else
            for key, value in pairs(tagsGlobal) do
                if v:HasTag(value) then
                    return false
                end
            end
            if intable(prefabsGlobal, v.prefab) then
                return false
            end
        end
    end
    return true
end

local function getrandomitem(table)
    return table[math.random(#table)]
end
local function getrandompos()
    local r = math.sqrt(math.random() * (R - 6) * (R - 6))
    local theta = math.random() * 360 * radious
    return {["x"] = r * math.sin(theta), ["z"] = r * math.cos(theta)}
end
local function randomenemys(required_difficulty)
    while true do
        local _enemys = {}
        local sum_difficulty = 0
        while true do
            local enemy = getrandomitem(enemys)
            local enemy_prefab = enemy.prefab
            local enemy_difficulty = enemy.difficulty
            table.insert(_enemys, {["prefab"] = enemy_prefab, ["position"] = getrandompos()})
            sum_difficulty = sum_difficulty + enemy_difficulty
            if sum_difficulty >= required_difficulty - 15 then
                break
            end
        end
        if sum_difficulty <= required_difficulty + 15 then
            return _enemys
        end
    end
end
local ColosseumController =
    Class(
    function(self, inst)
        self.inst = inst
        self.player = nil
        self.needweapons = true
        self.uninit = true
        self.isgaming = false
        self.tobepass = false
        self.level = 0
        self.maxlevel = #levels
        self.checked = {}
        self.mode = 1
        self.modeoptions = TUNING.COLOSSEUM_MODE_OPTIONS
        self.wormhole_in = nil
        self.wormhole_out = nil
        self.inst:DoTaskInTime(
            0.1,
            function()
                if self.uninit then
                    self:Init()
                else
                    self:PseudoInit()
                end
            end
        )
        self.inst:DoPeriodicTask(
            0.25,
            function()
                if self.isgaming then
                    self:CheckGame()
                end
            end
        )
        if TUNING.MYTH_CHARACTER_MOD_OPEN then
            for key, value in pairs(enemys_myth) do
                table.insert(enemys, value)
            end
        end
        if KnownModIndex:IsModEnabled("workshop-1392778117") then
            for key, value in pairs(enemys_legion) do
                table.insert(enemys, value)
            end
        end
        if KnownModIndex:IsModEnabled("workshop-2348196117") then
            for key, value in pairs(enemys_hollow) do
                table.insert(enemys, value)
            end
        end
    end
)
function ColosseumController:Init()
    self.uninit = false
    local x, _, z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, _, z, R)
    for i, v in ipairs(ents) do
        if not v:HasTag("player") and not v:HasTag("colosseum") and not v:HasTag("NOCLICK") and not v.inlimbo then
            local x, _, z = v.Transform:GetWorldPosition()
            v:Remove()
            if math.random() > 0.5 then
                SpawnPrefab("sand_puff").Transform:SetPosition(x, _, z)
            end
        end
    end
    for i = 0, 359, 6 do
        local x1 = x + R * math.sin(i * radious)
        local z1 = z + R * math.cos(i * radious)
        local function spawnbasalt()
            SpawnPrefab("basalt").Transform:SetPosition(x1, _, z1)
        end
        self.inst:DoTaskInTime(i / 200, spawnbasalt)
    end
    local wormhole1 = SpawnPrefab("wormhole")
    wormhole1.Transform:SetPosition(x, _, z + R - 6)
    wormhole1:AddTag("colosseum")
    local wormhole2 = SpawnPrefab("wormhole")
    wormhole2.Transform:SetPosition(x, _, z + R + 6)
    wormhole1.components.teleporter:Target(wormhole2)
    wormhole2.components.teleporter:Target(wormhole1)
    self.wormhole_in = wormhole1
    self.wormhole_out = wormhole2
    wormhole1.components.teleporter.travelcameratime = 0
    wormhole2.components.teleporter.travelcameratime = 0
    wormhole1.components.teleporter.travelarrivetime = 1
    wormhole2.components.teleporter.travelarrivetime = 1
	SpawnPrefab("rank").Transform:SetPosition(x, _, z + R + 2)
    self.inst.colosseum_title = SpawnPrefab("colosseum_title")
    self.inst.colosseum_title.entity:SetParent(self.inst.entity)
    self.inst.colosseum_title:SetText(levels[0].name, 2.3, 25, {255, 150, 0})
end
function ColosseumController:PseudoInit()
    local x, _, z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, _, z + R - 6, 0.2)
    for i, v in ipairs(ents) do
        if v.prefab == "wormhole" then
            self.wormhole_in = v
        end
    end
    local ents = TheSim:FindEntities(x, _, z + R + 6, 0.2)
    for i, v in ipairs(ents) do
        if v.prefab == "wormhole" then
            self.wormhole_out = v
        end
    end
    if self.wormhole_in == nil then
        local wormhole1 = SpawnPrefab("wormhole")
        wormhole1.Transform:SetPosition(x, _, z + R - 6)
        self.wormhole_in = wormhole1
    end
    if self.wormhole_out == nil then
        local wormhole2 = SpawnPrefab("wormhole")
        wormhole2.Transform:SetPosition(x, _, z + R + 6)
        self.wormhole_out = wormhole2
    end
    self.wormhole_in:AddTag("colosseum")
    self.wormhole_in.components.teleporter:Target(self.wormhole_out)
    self.wormhole_out.components.teleporter:Target(self.wormhole_in)
    self.wormhole_in.components.teleporter.travelcameratime = 0
    self.wormhole_out.components.teleporter.travelcameratime = 0
    self.wormhole_in.components.teleporter.travelarrivetime = 1
    self.wormhole_out.components.teleporter.travelarrivetime = 1
    self.inst.colosseum_title = SpawnPrefab("colosseum_title")
    self.inst.colosseum_title.entity:SetParent(self.inst.entity)
    self.inst.colosseum_title:SetText(levels[0].name, 2.3, 25, {255, 150, 0})
end
function ColosseumController:StartGame(player)
    local x, _, z = self.inst.Transform:GetWorldPosition()
    cleanup(x, _, z, player)
    self.isgaming = true
    self.tobepass = false
    self.inst.replica.colosseum_controller.isgaming:set(self.isgaming)
    self.inst.components.burnable:Ignite()
    self.level = 0
    self.player = player
    self.needweapons = true
    player.components.temperature:SetTemp(25)
    self.needweapons = needweapons(player.components.inventory)
    gerenciarInventario(player.components.inventory, true, false)
    self.wormhole_in.components.teleporter:SetEnabled(false)
    self.wormhole_out.components.teleporter:SetEnabled(false)

	STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAXWELL_TORCH = "Não há recuo."
	TheNet:Announce("O jogador " .. player.name .. " iniciou o desafio do Coliseu de " .. levels[0].name)

    self:NextLevel()
end
function ColosseumController:CheckGame()
    local x, _, z = self.inst.Transform:GetWorldPosition()
    local player = self.player
    if player == nil or player.components.health:IsDead() then
        self:EndGame()
        return
    end
    local x1, _, z1 = player.Transform:GetWorldPosition()
    if x1 == nil or z1 == nil then
        self:EndGame()
        return
    end
    if (x - x1) * (x - x1) + (z - z1) * (z - z1) > R * R then

		player.components.talker:Say("Eu desisto!")

        self:EndGame()
        return
    end
    if player.components.temperature:GetCurrent() ~= 25 then
        player.components.temperature:SetTemperature(25)
    end
    if self.level == 0 then
        return
    end
    local pass = true
    for k, v in pairs(self.checked) do
        pass = false
        if v == nil or not v:IsValid() or v.components.health:IsDead() then
            table.remove(self.checked, k)
        elseif v.prefab == "alterguardian_phase3" then
            local x2, _, z2 = v.Transform:GetWorldPosition()
            if (x - x2) * (x - x2) + (z - z2) * (z - z2) > R * R then
                v.Transform:SetPosition(x, _, z)
            end
        end
    end
    if pass and not self.tobepass then
        self.tobepass = true
        self:NextLevel()
    end
end
function ColosseumController:NextLevel()
    if self.level == self.maxlevel and levels[0].id ~= "endless" then
        self:EndGame(true)
        return
    end
    local player = self.player
    if player == nil then
        return
    end

    player.components.talker:Say("Vou entrar no próximo nível em " .. tostring(delay) .. " segundos")

    if levels[0].id == "endless" then
        self:EndlessCreate(self.level + 1)
    end
	
	local index = self.level + 1 
	for i, item in pairs(levels[index].supply) do
		for count = 1, item.number, 1 do
			local v = SpawnPrefab(item.prefab)
			if v.components.weapon == nil or self.needweapons then
				player.components.inventory:GiveItem(v)
			else
				v:Remove()
			end
		end
	end
    local x, _, z = self.inst.Transform:GetWorldPosition()
    self.inst:DoTaskInTime(
        delay - 1,
        function()
            if self.isgaming then
                for i, enemy in pairs(levels[self.level + 1].enemys) do
                    local ping = SpawnPrefab("enemyping")
                    ping.Transform:SetPosition(x + enemy.position.x, 0, z + enemy.position.z)
                end
            end
        end
    )
    self.inst:DoTaskInTime(
        delay,
        function()
            if self.isgaming then
                if self.level ~= 0 then
                    cleanup(x, _, z, player, self.inst.components.inventory)
                end
                self.level = self.level + 1

                self.inst.colosseum_title:SetText("Level " .. self.level, 2.3, 25, {255, 150, 0})
                
                self.checked = {}

                for i, enemy in pairs(levels[self.level].enemys) do
                    local v = SpawnPrefab(enemy.prefab)
                    v.Transform:SetPosition(x + enemy.position.x, 0, z + enemy.position.z)
                    if v.prefab == "klaus" then
                        v:SpawnDeer(v)
                    elseif v.prefab == "moose" then
                        v.shouldGoAway = false
                    elseif v.prefab == "bearger" then
                        v.components.sleeper:SetSleepTest(
                            function()
                                return false
                            end
                        )
                        if v:HasTag("hibernation") then
                            v:RemoveTag("hibernation")
                        end
                    end
                    v.components.combat:GetAttacked(player, 1)
                    table.insert(self.checked, v)
                end
                self.tobepass = false
            end
        end
    )
end

function ColosseumController:EndGame(triumph)
    local x, _, z = self.inst.Transform:GetWorldPosition()
    cleanup(x, _, z, nil, self.inst.components.inventory)
    gerenciarInventario(self.player.components.inventory, false, false)
    self.inst.colosseum_title:SetText(levels[0].name, 2.3, 25, {255, 150, 0})
    self.isgaming = false
    self.inst.replica.colosseum_controller.isgaming:set(self.isgaming)
    self.inst.components.inventory:DropEverything(true)
    self.inst.components.burnable:Extinguish()
    self.wormhole_in.components.teleporter:SetEnabled(true)
    self.wormhole_out.components.teleporter:SetEnabled(true)

    STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAXWELL_TORCH = "Mal posso esperar para lutar."

    if self.player then
        local player = self.player
        local delay = 1;
        if player.components.health:IsDead() then
            player:DoTaskInTime(
                2,
                function(inst)
                    inst.Transform:SetPosition(x, _, z)
                    inst:PushEvent("respawnfromghost")
                end
            )
            
            delay = 10;
        end
        
        player:DoTaskInTime(
            delay,
            function(inst)
                gerenciarInventario(player.components.inventory, false, true)
            end
        )
            
        player.components.temperature:SetTemp(nil)
    end
    if triumph or levels[0].id == "endless" then
        self:RewardPlayer()
    else
        TheNet:Announce("Fim de jogo!")
    end
end
function ColosseumController:RewardPlayer()
    local player = self.player
    local x, _, z = player.Transform:GetWorldPosition()
    if x == nil or z == nil then
        return
    end
    
    local delay = player.components.health:IsDead() and 10 or 1;
    self.inst:DoTaskInTime(
        delay,
        function()
			for k, reward in pairs(rewards) do
				if levels[0].id ~= "endless" and levels[0].id == reward.mode then
					for i = 1, reward.number, 1 do
						local inst = SpawnPrefab(reward.prefab)
						player.components.inventory:GiveItem(inst)
					end
				elseif levels[0].id == "endless" and self.level >= reward.level then
					for i = 1, reward.number, 1 do
						local inst = SpawnPrefab(reward.prefab)
						player.components.inventory:GiveItem(inst)
					end
				end
			end
        end
    )

	if levels[0].id == "easy" and tagany then
		player.colosseum_title:SetText("Campeão Easy", 2.8, 18, {255, 0, 0}) -- Vermelho
		TheNet:Announce(player.name .. " venceu o desafio no modo Easy!")
	end
	if levels[0].id == "hard" and taghard then
		player.colosseum_title:SetText("Campeão Hard", 2.8, 18, {128, 0, 128}) -- Roxo
		TheNet:Announce(player.name .. " venceu o desafio no modo Hard!")
	end
	if levels[0].id == "endless" and tagendless then
		if self.level > 1 then
			TheNet:Announce(player.name .. " alcançou o nivel "..(self.level-1).." no modo Endless!")
			player.colosseum_title:SetText("Campeão Endless - " .. self.level-1, 2.8, 25, {0, 0, 0}) -- Preto
		else 
			TheNet:Announce(player.name .. " não conseguiu concluir nenhum nivel no modo Endless!")
		end
		
		local nomeJogador = player.name
		local onda = self.level-1
		local arquivoRanking = "rank.txt"
		local linhasRanking = {}

		local arquivo = io.open(arquivoRanking, "r")
		if arquivo then
			for linha in arquivo:lines() do
				local nomeJogador, ondaAlcancada = linha:match("([^,]+),([^,]+)")
				table.insert(linhasRanking, {nome = nomeJogador, onda = tonumber(ondaAlcancada)})
			end
			arquivo:close()
		end

		local encontrado = false
		for _, jogador in ipairs(linhasRanking) do
		
			if jogador.nome == nomeJogador then
				jogador.onda = math.max(jogador.onda, onda)
				encontrado = true
				break
			end
		end

		if not encontrado then
			table.insert(linhasRanking, {nome = nomeJogador, onda = onda})
		end

		table.sort(linhasRanking, function(a, b) return a.onda > b.onda end)

		arquivo = io.open(arquivoRanking, "w")
		for _, jogador in ipairs(linhasRanking) do
			arquivo:write(jogador.nome .. "," .. jogador.onda .. "\n")
		end
		arquivo:close()
	end
end
function ColosseumController:SwitchMode(doer)
    if self.mode ~= #self.modeoptions then
        self.mode = self.mode + 1
        levels = self.modeoptions[self.mode]
    else
        self.mode = 1
        levels = self.modeoptions[1]
    end
    self.maxlevel = #levels
    self.inst.colosseum_title:SetText(levels[0].name, 2.3, 25, {255, 150, 0})
end
function ColosseumController:EndlessCreate(level)
    levels[level] = {["supply"] = {}, ["enemys"] = {}}
    if (level - 1) % 6 == 0 and self.needweapons then
        table.insert(levels[level].supply, {["prefab"] = getrandomitem(weapons), ["number"] = 1})
    end
    if (level - 1) % 3 == 0 then
        table.insert(levels[level].supply, {["prefab"] = getrandomitem(armors), ["number"] = 1})
    end
    if level then
        table.insert(levels[level].supply, {["prefab"] = getrandomitem(foods), ["number"] = 1})
    end
    local required_difficulty = 80 + (level * 1000) ^ 0.55
    levels[level].enemys = randomenemys(required_difficulty)
end
function ColosseumController:OnSave()
    return {uninit = self.uninit}
end
function ColosseumController:OnLoad(data)
    if data then
        self.uninit = data.uninit
    end
end
return ColosseumController
