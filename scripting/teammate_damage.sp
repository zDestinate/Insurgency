#pragma semicolon 1 

#include <sourcemod>
#include <sdkhooks>
#include <sdktools> 
#define PLUGIN_VERSION "1.0.0"

// This will be used for checking which team the player is on before repsawning them
#define TEAM_NONE			0
#define TEAM_SPECTATORS  	1
#define TEAM_SECURITY		2
#define TEAM_INSURGENTS		3

new Handle:g_CvarEnabled;
new Handle:g_CvarSecurityDamage;
new Handle:g_CvarInsurgentDamage;

public Plugin:myinfo = 
{
	name = "[INS] Teammate Damage",
	author = "Neko-",
	description = "This plugin use to control the teammate damage to prevent team killing",
	version = PLUGIN_VERSION,
};

public OnPluginStart()
{
	g_CvarEnabled = CreateConVar("sm_td_enable", "1.0", "Enables(1) or disables(0) the plugin.", FCVAR_NONE, true, 0.0, true, 1.0);
	g_CvarSecurityDamage = CreateConVar("sm_td_sec", "0.2", "Teammate damage for security in percentage 0.0 to 1.0 (1.0 = 100%)", FCVAR_NONE, true, 0.0, true, 1.0);
	g_CvarInsurgentDamage = CreateConVar("sm_td_ins", "0.2", "Teammate damage for insurgents in percentage 0.0 to 1.0 (1.0 = 100%)", FCVAR_NONE, true, 0.0, true, 1.0);
	
	AutoExecConfig(true,"ins.teammate_damage");
}

public OnClientPutInServer(client) 
{
	SDKHook(client, SDKHook_OnTakeDamage, Hook_OnTakeDamage); 
} 

public Action:Hook_OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype) 
{ 
	if (attacker < 1 || victim < 1 || attacker > MaxClients || victim > MaxClients || !GetConVarBool(g_CvarEnabled)) 
	{ 
		return Plugin_Continue; 
	}
	
	if ((GetClientTeam(attacker) == GetClientTeam(victim)) && (attacker != victim))
	{		
		if(GetClientTeam(victim) == TEAM_SECURITY)
		{
			new Float:CvarDamage = GetConVarFloat(g_CvarSecurityDamage);
			if(CvarDamage > 0.0)
			{
				damage *= CvarDamage;
				return Plugin_Continue;
			}
			else
			{
				return Plugin_Handled;
			}
		}
		else if(GetClientTeam(victim) == TEAM_INSURGENTS)
		{
			new Float:CvarDamage = GetConVarFloat(g_CvarInsurgentDamage);
			if(CvarDamage > 0.0)
			{
				damage *= CvarDamage;
				return Plugin_Continue;
			}
			else
			{
				return Plugin_Handled;
			}
		}
	}
	
	return Plugin_Continue;
}