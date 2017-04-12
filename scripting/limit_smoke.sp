#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

public Plugin:myinfo = {
    name = "[INS] Limit Smoke",
    description = "Limit the amount of smoke player can have at a time.",
    author = "Neko-",
    version = "1.0.2",
};

new Handle:cvarEnabled = INVALID_HANDLE;
new Handle:cvarLimitAmount = INVALID_HANDLE;

public OnPluginStart() 
{
    cvarEnabled = CreateConVar("sm_ins_limit_smoke_enabled", "1", "sets whether limit smoke are enabled", FCVAR_PROTECTED, true, 0.0, true, 1.0);
    cvarLimitAmount = CreateConVar("sm_ins_limit_smoke_amount", "1", "amount of smoke that player can bring at a time", FCVAR_PROTECTED, true, 1.0, true, 5.0);
    
    AutoExecConfig(true,"ins.limit_smoke");
}

public OnClientPutInServer(client) 
{
	if(!IsFakeClient(client))
	{
		SDKHook(client, SDKHook_WeaponSwitch, WeaponSwitchHook); 
	}
}

public Action:WeaponSwitchHook(client, weapon)
{
	if(GetConVarBool(cvarEnabled))
	{
		int nSmokeAmount = GetConVarInt(cvarLimitAmount);
		decl String:sWeaponName[64]; 
		GetEntityClassname(weapon, sWeaponName, sizeof(sWeaponName)); 

		new PrimaryAmmoType = GetEntProp(weapon, Prop_Data, "m_iPrimaryAmmoType");

		if(StrEqual(sWeaponName, "weapon_m18") && (PrimaryAmmoType != -1))
		{
			new CurrentAmmo = GetEntProp(client, Prop_Send, "m_iAmmo", _, PrimaryAmmoType);
			if(CurrentAmmo > nSmokeAmount)
			{
				PrintHintText(client, "You can't have more than %i smoke. Use it wisely!", nSmokeAmount);
				SetEntProp(client, Prop_Send, "m_iAmmo", nSmokeAmount, _, PrimaryAmmoType);
			}
		}
	}
	
	return Plugin_Continue;
}