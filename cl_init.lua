Citizen.CreateThread(function()
    TriggerServerEvent "SampleCooldown::ClientFullyConnected"
	TriggerEvent('chat:addTemplate', 'aopbox', "<div style='background-color: rgba(64, 64, 64, 0.3); text-align: center; border-radius: 0.5vh; padding: 0.7vh; font-size: 1.7vh;'><b>{0}</b></div>")
end)

local cooldownTimeLeft = 0
local currentType = COOLDOWN_END_ALL_COMMAND
local pvpDisabled = false
local cooldownText = COOLDOWN_END_ALL_TEXT
local currentAOP = AOP_DEFAULT

RegisterNetEvent "SampleCooldown::UpdateCooldown"
AddEventHandler("SampleCooldown::UpdateCooldown", function(cType, timeLeft, pvp, txt, aop)
	cType = cType or currentType
	timeLeft = timeLeft or cooldownTimeLeft
	if pvp == nil then pvp = pvpDisabled end
	txt = txt or cooldownText
	aop = aop or currentAOP
	
	currentType = cType
	cooldownTimeLeft = timeLeft
	pvpDisabled = pvp
	cooldownText = txt
    currentAOP = aop
    
	if currentType ~= COOLDOWN_COUNTDOWN_COMMAND and currentType ~= RESTART_COUNTDOWN_COMMAND then
		cooldownTimeLeft = 0
    end
	
	if pvpDisabled then
		Citizen.CreateThread(function()
			while true do
				if pvpDisabled == false then break end
				local ped = PlayerPedId()
				SetPlayerCanDoDriveBy(ped, false)
				DisablePlayerFiring(ped, true)
				if PVP_DISABLES_MELEE then
					DisableControlAction(0, 140)
				end
				Wait(0)
			end
		end)
	end
end)

function table.Count(t)
	local i = 0
	for k in pairs(t) do i = i + 1 end
	return i
end

function table.Random(t)
	local rk = math.random(1, table.Count(t))
	local i = 1
	for k, v in pairs(t) do
		if i == rk then return v, k end
		i = i + 1
	end
end

AddEventHandler("playerSpawned", function()
	if not SPAWN_PLAYER_IN_AOP then return end
    local p = PlayerPedId()
    
    Citizen.Wait(500)

    local selected = table.Random(AOP_LOCATIONS[GlobalState.Aop].Spawnpoints)
    SetEntityCoords(p, selected.x + 0.0, selected.y + 0.0, selected.z + 0.0)
end)

Citizen.CreateThread(function()
	while true do
		if cooldownTimeLeft == 0 then
            if currentType ~= COOLDOWN_END_ALL_COMMAND or COOLDOWN_END_ALL_TEXT ~= "" then
                exports.sample_util:DrawTextRightOfMinimap( exports.sample_util:GetHudColor() .. AOP_TEXT:format( GlobalState.Aop ), 0, 0 )
                exports.sample_util:DrawTextRightOfMinimap( exports.sample_util:GetHudColor() .. cooldownText, 0, 0.02 )
			else
				exports.sample_util:DrawTextRightOfMinimap( exports.sample_util:GetHudColor() .. AOP_TEXT:format( GlobalState.Aop ), 0, 0 )
			end
        else
            if currentType == RESTART_COUNTDOWN_COMMAND then
                exports.sample_util:DrawTextRightOfMinimap( exports.sample_util:GetHudColor() .. AOP_TEXT:format( GlobalState.Aop ), 0, 0 )
                exports.sample_util:DrawTextRightOfMinimap( exports.sample_util:GetHudColor() .. RESTART_COUNTDOWN_TEXT:format( cooldownTimeLeft ), 0, 0.02 )
            else
                exports.sample_util:DrawTextRightOfMinimap( exports.sample_util:GetHudColor() .. AOP_TEXT:format( GlobalState.Aop ), 0, 0 )
				exports.sample_util:DrawTextRightOfMinimap( exports.sample_util:GetHudColor() .. COOLDOWN_COUNTDOWN_TEXT:format( cooldownTimeLeft ), 0.0, 0.02 )
            end
        end
        
		NetworkSetFriendlyFireOption( true )
		Citizen.Wait(0)
	end
end)

RegisterCommand("tpaop", function()
    if not SPAWN_PLAYER_IN_AOP then return end
    local p = PlayerPedId()

    local selected = table.Random(AOP_LOCATIONS[GlobalState.Aop].Spawnpoints)
    SetEntityCoords(p, selected.x + 0.0, selected.y + 0.0, selected.z + 0.0)
end)