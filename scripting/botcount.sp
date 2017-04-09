/*
	Thank Jared Ballou (jballou) for his coop lobby overwrite
	By using his coop lobby overwrite will fix the bot count amount
	This plugin is a reharsh version to fix the coop bot count without overwrite the lobby size
*/

#include <sourcemod>
#include <sdktools>

public Plugin:myinfo = {
	name		= "[INS] Coop Bot Count Fixed",
	author		= "Neko-",
	description	= "Fix coop bot count",
	version		= "1.0.0"
};

public OnPluginStart()
{
	HookEvent("server_spawn", Event_GameStart, EventHookMode_Pre);
	HookEvent("game_init", Event_GameStart, EventHookMode_Pre);
	HookEvent("game_start", Event_GameStart, EventHookMode_Pre);
	HookEvent("game_newmap", Event_GameStart, EventHookMode_Pre);
	FixBotCount();
}

public Event_GameStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	FixBotCount();
}

public FixBotCount()
{
	ConVar cvar = FindConVar("mp_coop_lobbysize");
	new Float:fvalue = GetConVarFloat(cvar);
	new value = GetConVarInt(cvar);
	SetConVarBounds(cvar, ConVarBound_Upper, true, fvalue);
	SetConVarInt(cvar, value);
}