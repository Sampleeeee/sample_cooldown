local discordRole = "Cooldown"
local acePermission = "sample.cooldown"

SHOULD_USE_DISCORD_PERMS = true

DISCORD_PERMS_RESOURCE = "sample_util"
DISCORD_PERMS_FUNCTION = "IsRolePresent"

COOLDOWN_PAUSE_TYPES = {
	{
		command = "hold",
		text = "Server Status: ~w~Priorities On Hold",
		color = { 255, 255, 255 },
		notify_text = "^1^*WARNING: ^r^7All priorities are on hold, please refrain from starting a priority or you risk punishment.",
		disable_pvp = false,
        discord_role = discordRole,
        ace_permission = acePermission
	},
	{
		command = "peace",
		text = "Server Status: ~w~Peacetime",
		color = { 255, 0, 0 },
		notify_text = "^1^*WARNING: ^r^7Peacetime has been enabled.",
		disable_pvp = true,
		discord_role = discordRole,
        ace_permission = acePermission
	},
	{
		command = "briefing",
		text = "Server Status: ~w~Briefing In Progress",
		color = { 255, 0, 0 },
		notify_text = "^1^*WARNING: ^r^7A briefing has just begun. All law enforcement officers are currently busy.",
		disable_pvp = true,
		discord_role = discordRole,
        ace_permission = acePermission
	},
	{
		command = "meeting",
		text = "Server Status: ~w~Meeting In Progress",
		color = { 255, 0, 0 },
		notify_text = "^1^*WARNING: ^r^7A meeting has been started. Please refrain from starting any priorities.",
		disable_pvp = true,
		discord_role = discordRole,
        ace_permission = acePermission
	},
	{
		command = "zerotolerance",
		aliases = { "zt" },
		text = "Server Status: ~w~Zero Tolerance",
		color = { 255, 0, 0 },
		notify_text = "^1^*WARNING: ^r^7Zero tolerance is now in effect. Breaking any rules will result in immediate punishment without warning.",
		disable_pvp = true,
		discord_role = discordRole,
        ace_permission = acePermission
	},
	{
		command = "priority",
		aliases = { "pr" },
		text = "Server Status: ~w~Priority In Progress",
		color = { 255, 255, 0 },
		notify_text = "^1^*WARNING: ^r^7A priority call has just begun. Please wait for the cooldown timer to end before starting another priority. Failure to wait will result in punishment.",
		disable_pvp = false,
		discord_role = discordRole,
        ace_permission = acePermission
        },
}

RESTART_COUNTDOWN_TEXT = "Server Restart In: ~w~%i second(s)"
RESTART_COUNTDOWN_COMMAND = "serverrestart"
RESTART_COUNTDOWN_TIME = 300 -- time in seconds
RESTART_COUNTDOWN_NOTIFY_TEXT = "^1^*WARNING: ^r^7The server will be restarting in 300 seconds."
RESTART_COUNTDOWN_DISCORD_ROLE = discordRole
RESTART_COUNTDOWN_ACE_PERMISSION = acePermission

COOLDOWN_COUNTDOWN_TEXT = "Priority Cooldown: ~w~%i minutes" -- %i = minutes left
COOLDOWN_COUNTDOWN_COMMAND = "cooldown"
COOLDOWN_COUNTDOWN_DISABLE_PVP = true
COOLDOWN_COUNTDOWN_TIME = 10 -- TIME IN MINUTES
COOLDOWN_COUNTDOWN_NOTIFY_TEXT = "^1^*WARNING: ^r^7Priority cooldown is now in effect, please wait %s minutes before starting another priority."
COOLDOWN_COUNTDOWN_DISCORD_ROLE = discordRole
COOLDOWN_COUNTDOWN_ACE_PERMISSION = acePermission

-- this disables all text from being displayed on screen
COOLDOWN_END_ALL_COMMAND = "endcooldown"
COOLDOWN_END_ALL_NOTIFY_TEXT = ""
COOLDOWN_END_ALL_TEXT = "Server Status: ~w~Priority Available" -- Leave this blank to show nothing
COOLDOWN_END_ALL_DISCORD_ROLE = discordRole
COOLDOWN_END_ALL_ACE_PERMISSION = acePermission

AOP_COMMAND = "aop"
AOP_DISCORD_ROLE = "AOP"
AOP_ACE_PERMISSION = acePermission
AOP_NOTIFY_TEXT = "^1^*WARNING: ^r^7The Area of Patrol has been changed to %s by management. Please finish all current scenes and then drive to the new AOP." -- %s = new aop
AOP_TEXT = "AOP: ~w~%s"
AOP_DEFAULT = "Northern Map"
SPAWN_PLAYER_IN_AOP = true

-- Don't touch this line
function NewAopLocation(title,locations,minPlayers,maxPlayers)if type(locations):find"vector"then locations={locations}end return{Title=title,Spawnpoints=locations,MinimumPlayers=minPlayers,MaximumPlayers=maxPlayers}end


local spawns = {
    Grapeseed = vector3(1693.79, 4914.85, 43.08),
    SandyShores = vector3(1534.94, 3777.54, 34.52),
    Harmony = vector3(601.49, 2730.73, 42.0),
    MirrorPark = vector3(1138.83, -646.01, 56.74),
    PaletoBay = vector3(-447.24, 5970.46, 31.78),
    Vinewood = vector3(-101.74, 879.23, 236.33),
    WesternCity = vector3(-1843.16, -1227.22, 13.0),
    SouthernCity = vector3(-5.14, -1748.09, 29.3),
	Apartments = vector3(-266.65, -960.86, 31.22),
    Statewide = {}
}

spawns.SandyHarmonyGrapeseed = { spawns.SandyShores, spawns.Harmony, spawns.Grapeseed }
spawns.SouthernMap = { spawns.Apartments }
spawns.NorthernMap = { spawns.SandyShores, spawns.Harmony, spawns.Grapeseed, spawns.PaletoBay }
spawns.PaletoGrapeseed = { spawns.PaletoBay, spawns.Grapeseed }

-- Create Statewide
for k, v in pairs(spawns) do spawns.Statewide[#spawns.Statewide + 1] = v end

AOP_LOCATIONS = {
    NewAopLocation("Sandy Shores", spawns.SandyShores, 0, 14),
    NewAopLocation("Paleto Bay", spawns.PaletoBay, 0, 14),
    NewAopLocation("Mirror Park", spawns.MirrorPark, 0, 14),
    NewAopLocation("Grapeseed", spawns.Grapeseed, 0, 14),
    NewAopLocation("Sandy Shores / Grapeseed / Harmony", spawns.SandyHarmonyGrapeseed, 15, 30),
	NewAopLocation("Southern City", spawns.SouthernCity, 15, 30),
    NewAopLocation("Northern City", spawns.Vinewood, 15, 30),
    NewAopLocation("Western City", spawns.WesternCity, 15, 30),
	NewAopLocation("Southern Map", spawns.SouthernMap, 31, 54),
	NewAopLocation("Northern Map", spawns.NorthernMap, 31, 54),
    NewAopLocation("Statewide", spawns.Statewide, 55, 1024)
}

-- Reorder Table, don't touch
local oldLocations=AOP_LOCATIONS;AOP_LOCATIONS={};for k,v in pairs(oldLocations)do AOP_LOCATIONS[v.Title]=v;end

local decrease = 0.05

AOP_TEXT_SCALE = 0.4
AOP_TEXT_FONT = 4
AOP_TEXT_POS_X = 0.165
AOP_TEXT_POS_Y = 0.93 - decrease

STATUS_TEXT_SCALE = 0.4
STATUS_TEXT_FONT = 4
STATUS_TEXT_POS_X = 0.165
STATUS_TEXT_POS_Y = 0.949 - decrease

-- THIS IS A WIP
PVP_WEAPON_BYPASS_ROLES = {
	["Cooldown"] = true,
	["DCSO"] = true
}

-- ALSO A WIP
PVP_WEAPON_BYPASS = {
	["WEAPON_STUNGUN"] = true
}

-- THIS WORKS THOUGH
PVP_DISABLES_MELEE = true
