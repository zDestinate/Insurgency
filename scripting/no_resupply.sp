#include <sourcemod>

public Plugin:myinfo = 
{
	name = "[INS] No Resupply",
	author = "Neko-",
	description = "Not allow player to resupply",
	version = "1.0.0",
}

public OnPluginStart()
{
	AddCommandListener(ResupplyListener, "inventory_resupply");
}

public Action:ResupplyListener(client, const String:cmd[], argc)
{
	PrintToChat(client, "You are not allowed to resupply!");
	return Plugin_Handled;
}