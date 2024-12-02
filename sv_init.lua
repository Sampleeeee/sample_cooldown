local cooldownTimeLeft = 0
local currentType = COOLDOWN_END_ALL_COMMAND
local pvpDisabled = false
local cooldownText = COOLDOWN_END_ALL_TEXT
GlobalState.Aop = AOP_DEFAULT
local util = exports["sample_util"] --exports[DISCORD_PERMS_RESOURCE]

function HasPermission(source, permission)
    if SHOULD_USE_DISCORD_PERMS then
        return util:IsRolePresent(source, permission) --util[DISCORD_PERMS_FUNCTION](source, permission)
    else
        return IsPlayerAceAllowed(source, permission)
    end
end

function RegisterPauseType( command, k, v )
	RegisterCommand(command, function(source, args, raw) 
		if not HasPermission(source, SHOULD_USE_DISCORD_PERMS and v.discord_role or v.ace_permission) then
			NoPermission(source)
			return
        end
        
        --print(GetPlayerName(source), "used command", v.command)
		SendWebhook("**"..GetPlayerName(source).."** has used **"..v.command.."**")
		
		currentType = v.command
		pvpDisabled = v.disable_pvp
		cooldownText = v.text

		TriggerClientEvent("chat:addMessage", -1, {
			color = v.color,
			templateId = 'aopbox',
			args = { v.notify_text }
        })
        
        if v.restart then
            cooldownTimeLeft = 300
        end

        Citizen.CreateThread(function()
            while cooldownTimeLeft > 0 do
                Citizen.Wait(1000)
                cooldownTimeLeft = cooldownTimeLeft - 1
                TriggerClientEvent("SampleCooldown::UpdateCooldown", -1, currentType, cooldownTimeLeft, pvpDisabled, cooldownText)
            end
        end)
		
		TriggerClientEvent("SampleCooldown::UpdateCooldown", -1, currentType, cooldownTimeLeft, pvpDisabled, cooldownText)
	end)
end

for k, v in ipairs(COOLDOWN_PAUSE_TYPES) do
	RegisterPauseType( v.command, k, v )
	for k2, v2 in ipairs( v.aliases or {} ) do
		RegisterPauseType( v2, k, v )
	end
end

RegisterCommand(COOLDOWN_COUNTDOWN_COMMAND, function(source, args, raw)
	if not HasPermission(source, SHOULD_USE_DISCORD_PERMS and COOLDOWN_COUNTDOWN_DISCORD_ROLE or COOLDOWN_COUNTDOWN_ACE_PERMISSION) then
		NoPermission(source)
		return
    end
    
    --print(GetPlayerName(source), "used command", COOLDOWN_COUNTDOWN_COMMAND)
	
		
	currentType = COOLDOWN_COUNTDOWN_COMMAND
	cooldownTimeLeft = tonumber( args[1] ) or COOLDOWN_COUNTDOWN_TIME
	pvpDisabled = COOLDOWN_COUNTDOWN_DISABLE_PVP
	cooldownText = COOLDOWN_COUNTDOWN_TEXT

	SendWebhook("**"..GetPlayerName(source).."** has used **Cooldown** for **"..cooldownTimeLeft.." minutes**")
	
	TriggerClientEvent("chat:addMessage", -1, {
		templateId = 'aopbox',
		args = { COOLDOWN_COUNTDOWN_NOTIFY_TEXT:format( tostring( cooldownTimeLeft ) ) }
	})
	
	TriggerClientEvent("SampleCooldown::UpdateCooldown", -1, currentType, cooldownTimeLeft, pvpDisabled, cooldownText)
	
	Citizen.CreateThread(function()
		while cooldownTimeLeft > 0 do
			Wait(60000)
			cooldownTimeLeft = cooldownTimeLeft - 1
			TriggerClientEvent("SampleCooldown::UpdateCooldown", -1, currentType, cooldownTimeLeft, pvpDisabled, cooldownText)
		end
		
		currentType = COOLDOWN_END_ALL_COMMAND
		pvpDisabled = false
		cooldownText = COOLDOWN_END_ALL_TEXT

		TriggerClientEvent("SampleCooldown::UpdateCooldown", -1, currentType, cooldownTimeLeft, pvpDisabled, cooldownText)
	end)
end)

RegisterCommand(RESTART_COUNTDOWN_COMMAND, function(source, args, raw)
    if not HasPermission(source, SHOULD_USE_DISCORD_PERMS and RESTART_COUNTDOWN_DISCORD_ROLE or RESTART_COUNTDOWN_ACE_PERMISSION) then
		NoPermission(source)
		return
    end

    --print(GetPlayerName(source), "used command", RESTART_COUNTDOWN_COMMAND)
    
    currentType = RESTART_COUNTDOWN_COMMAND
	cooldownTimeLeft = RESTART_COUNTDOWN_TIME
	pvpDisabled = false
    cooldownText = RESTART_COUNTDOWN_TEXT:format(cooldownTimeLeft)
    
    TriggerClientEvent("chat:addMessage", -1, {
		templateId = 'aopbox',
		args = { RESTART_COUNTDOWN_NOTIFY_TEXT }
    })
    
    TriggerClientEvent("SampleCooldown::UpdateCooldown", -1, currentType, cooldownTimeLeft, pvpDisabled, cooldownText)
	
	Citizen.CreateThread(function()
		while cooldownTimeLeft >= 0 do
			Wait(1000)
			cooldownTimeLeft = cooldownTimeLeft - 1
			TriggerClientEvent("SampleCooldown::UpdateCooldown", -1, currentType, cooldownTimeLeft, pvpDisabled, cooldownText)
		end
	end)
end)

RegisterNetEvent "SampleCooldown::ClientFullyConnected"
AddEventHandler("SampleCooldown::ClientFullyConnected", function()
	TriggerClientEvent("SampleCooldown::UpdateCooldown", source, currentType, cooldownTimeLeft, pvpDisabled, cooldownText, currentAOP)
end)

function NoPermission(source)
    TriggerClientEvent("chat:addMessage", source, {
        color = { 255, 0, 0 },
        args = { "ERROR", "You do not have permission to do this!" }
    })
end

RegisterCommand(COOLDOWN_END_ALL_COMMAND, function(source)
	if not HasPermission(source, SHOULD_USE_DISCORD_PERMS and COOLDOWN_END_ALL_DISCORD_ROLE or COOLDOWN_END_ALL_ACE_PERMISSION) then
        NoPermission(source)
		return
    end
    
    --print(GetPlayerName(source), "used command", COOLDOWN_END_ALL_COMMAND)
	SendWebhook("**"..GetPlayerName(source).."** has used **End Cooldown**")
	
	currentType = COOLDOWN_END_ALL_COMMAND
	cooldownTimeLeft = 0
	cooldownText = COOLDOWN_END_ALL_TEXT
	pvpDisabled = false
	
	TriggerClientEvent("chat:addMessage", -1, {
		templateId = 'aopbox',
		args = { COOLDOWN_END_ALL_NOTIFY_TEXT }
	})
	
	TriggerClientEvent("SampleCooldown::UpdateCooldown", -1, currentType, cooldownTimeLeft, false, cooldownText) 
end)

function ChangeAop(aop)
	currentAOP = aop
	TriggerClientEvent("SampleCooldown::UpdateCooldown", -1, currentType, cooldownTimeLeft, pvpDisabled, cooldownText, currentAOP)
end

function SendWebhook(text)
    local content = {
	    content = text,
    }

    PerformHttpRequest("https://discord.com/api/webhooks/924564638526500896/eru-Gn-HxV79hS2ups1FIzXgxsneOrTw_Ft_2zuUuUpJamIsEBA-nnJUAobOVs0_Nh0t", 
        function(err, text, headers) end, 'POST', json.encode(content), { ['Content-Type'] = 'application/json' })
end

RegisterCommand(AOP_COMMAND, function(source, args)
    if not HasPermission(source, AOP_DISCORD_ROLE) then
        SendWebhook("**"..( GetPlayerName(source) or GetPlayerName( source ) ) .."** attempted to change the AOP to ** "..table.concat(args, ' ').."** but they didn't have permission.")
		NoPermission(source)
		return
    end

	SendWebhook("**".. ( GetPlayerName(source) or GetPlayerName( source ) ).."** has changed the AOP to ** "..table.concat(args, ' ').."**")
	GlobalState.Aop = table.concat( args, " " )

	TriggerClientEvent( "chat:addMessage", -1, { 
		templateId = 'aopbox',
		args = { AOP_NOTIFY_TEXT:format( GlobalState.Aop ) }
	} )

	TriggerEvent('astra:ts', GetPlayerName(source) or GetPlayerName( source ), GlobalState.Aop)
end)

function getAOP()
	return GlobalState.Aop
end

exports( 'getAOP', getAOP )

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  TriggerEvent('astra:ts', 'Server', GlobalState.Aop)
	end
end)
  
