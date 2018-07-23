#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

public Plugin:myinfo = {
    name = "[INS] Bot Actions",
    description = "Other type of bot action for INS bots",
    author = "Neko-",
    version = "1.0.0",
};

new bool:g_nPlayer[MAXPLAYERS+1] = {false, ...};

public OnPluginStart()
{
	//HookEvent("weapon_fire", Event_WeaponFire, EventHookMode_Pre);
	
	RegAdminCmd("bottarget", SetBotAimTarget, ADMFLAG_KICK, "Set bot to use aimbot on target");
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon, &nSubType, &nCmdNum, &nTickCount, &nSeed)  
{
	if(IsFakeClient(client) && IsPlayerAlive(client))
	{
		float fRandom = GetRandomFloat(0.0, 1.0);
		int nTargetView = getClientViewClient(client);
		int nTargetAim = GetClientAimTarget(client, true);
		
		//float fRandomLookAtTarget = GetRandomFloat(0.0, 1.0);
		bool bAllowAim = true;
		
		if(bAllowAim)
		{
			int nActiveWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
			int nClipAmmo = GetEntProp(nActiveWeapon, Prop_Send, "m_iClip1");
			//int nTarget = GetClosestClient(client);
			int nTarget = GetClosestClientAndTarget(client);
			if((nClipAmmo > 0) && (nTarget > 0) && (IsPlayerAlive(nTarget)))
			{
				LookAtClient(client, nTarget);
				buttons |= IN_ATTACK;
				return Plugin_Changed;  
			}
		}
		
		if((nTargetView == nTargetAim) && (GetClientTeam(client) != GetClientTeam(nTargetAim)) && (fRandom <= 0.01))
		{
			buttons |= IN_ATTACK; 
			//nSeed = 0;
			return Plugin_Changed;  
		}
		else if((nTargetView == nTargetAim) && (GetClientTeam(client) != GetClientTeam(nTargetAim)) && g_nPlayer[nTargetAim])
		{
			buttons |= IN_ATTACK; 
			//nSeed = 0;
			return Plugin_Changed;  
		}
	}
	
	return Plugin_Continue;
}

public OnClientPostAdminCheck(client)
{
	g_nPlayer[client] = false;
}

public OnClientDisconnect(client)
{
	g_nPlayer[client] = false;
}

public Action:Event_WeaponFire(Handle:event, const String:name[], bool:dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	//If it bot (Not real player)
	if(IsFakeClient(client))
	{
		/*
		int nTargetAim = GetClientAimTarget(client, true);
		
		if(nTargetAim > 0)
		{
			int nStance = GetEntProp(nTargetAim, Prop_Send, "m_iCurrentStance");
			SetEntProp(client, Prop_Send, "m_iCurrentStance", nStance);
		}
		else
		{
			//Set random stance type
			int nRandomStance = GetRandomInt(0, 5);
			if((nRandomStance == 1) || (nRandomStance == 2) || (nRandomStance == 0))
			{
				SetEntProp(client, Prop_Send, "m_iCurrentStance", nRandomStance);
			}
		}
		*/
		SetEntProp(client, Prop_Send, "m_iCurrentStance", 2);
	}
}

stock void LookAtClient(int iClient, int iTarget)
{
	float fTargetPos[3]; float fTargetAngles[3]; float fClientPos[3]; float fFinalPos[3];
	GetClientEyePosition(iClient, fClientPos);
	GetClientEyePosition(iTarget, fTargetPos);
	GetClientEyeAngles(iTarget, fTargetAngles);
	
	float fVecFinal[3];
	AddInFrontOf(fTargetPos, fTargetAngles, 0.0, fVecFinal);
	MakeVectorFromPoints(fClientPos, fVecFinal, fFinalPos);
	
	GetVectorAngles(fFinalPos, fFinalPos);

	TeleportEntity(iClient, NULL_VECTOR, fFinalPos, NULL_VECTOR);
}

stock void AddInFrontOf(float fVecOrigin[3], float fVecAngle[3], float fUnits, float fOutPut[3])
{
	float fVecView[3]; GetViewVector(fVecAngle, fVecView);
	
	fOutPut[0] = fVecView[0] * fUnits + fVecOrigin[0];
	fOutPut[1] = fVecView[1] * fUnits + fVecOrigin[1];
	fOutPut[2] = fVecView[2] * fUnits + fVecOrigin[2];
}

stock void GetViewVector(float fVecAngle[3], float fOutPut[3])
{
	fOutPut[0] = Cosine(fVecAngle[1] / (180 / FLOAT_PI));
	fOutPut[1] = Sine(fVecAngle[1] / (180 / FLOAT_PI));
	fOutPut[2] = -Sine(fVecAngle[0] / (180 / FLOAT_PI));
}

stock int GetClosestClient(int iClient)
{
	float fClientOrigin[3], fTargetOrigin[3];
	
	GetClientAbsOrigin(iClient, fClientOrigin);
	
	int iClientTeam = GetClientTeam(iClient);
	int iClosestTarget = -1;
	
	float fClosestDistance = -1.0;
	float fTargetDistance;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i))
		{
			if (iClient == i || GetClientTeam(i) == iClientTeam || !IsPlayerAlive(i))
			{
				continue;
			}
			
			GetClientAbsOrigin(i, fTargetOrigin);
			fTargetDistance = GetVectorDistance(fClientOrigin, fTargetOrigin);

			if (fTargetDistance > fClosestDistance && fClosestDistance > -1.0)
			{
				continue;
			}

			if (!ClientCanSeeTarget(iClient, i))
			{
				continue;
			}
			
			if (fTargetDistance < 70)
			{
				continue;
			}
			
			/*
			if (!IsTargetInSightRange(iClient, i, 90.0, fTargetDistance))
			{
				continue;
			}
			*/
			
			fClosestDistance = fTargetDistance;
			iClosestTarget = i;
		}
	}
	
	return iClosestTarget;
}

public Action:SetBotAimTarget(client, args)
{
	int nAnounce = 0;
	
	if((args != 1) && (args != 2))
	{
		return Plugin_Continue;
	}
	else if(args == 2)
	{
		decl String:strAnounce[2];
		GetCmdArg(2, strAnounce, sizeof(strAnounce));
		nAnounce = StringToInt(strAnounce);
	}
	
	decl String:strTarget[64];
	GetCmdArg(1, strTarget, sizeof(strTarget));
	
	new nTarget = FindTarget(client, strTarget);
	if(nTarget == -1)
	{
		PrintToChat(client, "\x07f26565[BOT] \x01Target Not Found!");
		return Plugin_Handled;
	}
	
	decl String:strTargetName[128];
	GetClientName(nTarget, strTargetName, sizeof(strTargetName));
	
	if(g_nPlayer[nTarget])
	{
		g_nPlayer[nTarget] = false;
		if(nAnounce == 1)
		{
			PrintToChatAll("\x07f26565[BOT] \x01Bot will no longer target %s", strTargetName);
		}
		else
		{
			PrintToChat(client, "\x07f26565[BOT] \x01Bot will no longer target %s", strTargetName);
		}
	}
	else
	{
		g_nPlayer[nTarget] = true;
		if(nAnounce == 1)
		{
			PrintToChatAll("\x07f26565[BOT] \x01Bot now will target %s", strTargetName);
		}
		else
		{
			PrintToChat(client, "\x07f26565[BOT] \x01Bot now will target %s", strTargetName);
		}
	}
	
	return Plugin_Handled;
}

stock int GetClosestClientAndTarget(int iClient)
{
	float fClientOrigin[3], fTargetOrigin[3];
	
	GetClientAbsOrigin(iClient, fClientOrigin);
	
	int iClientTeam = GetClientTeam(iClient);
	int iClosestTarget = -1;
	
	float fClosestDistance = -1.0;
	float fTargetDistance;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i))
		{
			if (iClient == i || GetClientTeam(i) == iClientTeam || !IsPlayerAlive(i))
			{
				continue;
			}
			
			GetClientAbsOrigin(i, fTargetOrigin);
			fTargetDistance = GetVectorDistance(fClientOrigin, fTargetOrigin);

			if (fTargetDistance > fClosestDistance && fClosestDistance > -1.0)
			{
				continue;
			}

			if (!ClientCanSeeTarget(iClient, i))
			{
				continue;
			}
			
			if (fTargetDistance < 70)
			{
				continue;
			}
			
			if(g_nPlayer[i] == false)
			{
				continue;
			}
			
			/*
			if (!IsTargetInSightRange(iClient, i, 90.0, fTargetDistance))
			{
				continue;
			}
			*/
			
			fClosestDistance = fTargetDistance;
			iClosestTarget = i;
		}
	}
	
	return iClosestTarget;
}

stock bool ClientCanSeeTarget(int iClient, int iTarget, float fDistance = 0.0, float fHeight = 50.0)
{
	float fClientPosition[3]; float fTargetPosition[3];
	
	GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", fClientPosition);
	fClientPosition[2] += fHeight;
	
	GetClientEyePosition(iTarget, fTargetPosition);
	
	if (fDistance == 0.0 || GetVectorDistance(fClientPosition, fTargetPosition, false) < fDistance)
	{
		Handle hTrace = TR_TraceRayFilterEx(fClientPosition, fTargetPosition, MASK_SOLID_BRUSHONLY, RayType_EndPoint, Base_TraceFilter);
		
		if (TR_DidHit(hTrace))
		{
			delete hTrace;
			return false;
		}
		
		delete hTrace;
		return true;
	}
	
	return false;
}

public bool Base_TraceFilter(int iEntity, int iContentsMask, int iData)
{
	return iEntity == iData;
}

stock bool IsTargetInSightRange(int client, int target, float angle = 90.0, float distance = 0.0, bool heightcheck = true, bool negativeangle = false)
{
	if (angle > 360.0)
		angle = 360.0;
	
	if (angle < 0.0)
		return false;
	
	float clientpos[3];
	float targetpos[3];
	float anglevector[3];
	float targetvector[3];
	float resultangle;
	float resultdistance;
	
	GetClientEyeAngles(client, anglevector);
	anglevector[0] = anglevector[2] = 0.0;
	GetAngleVectors(anglevector, anglevector, NULL_VECTOR, NULL_VECTOR);
	NormalizeVector(anglevector, anglevector);
	if (negativeangle)
		NegateVector(anglevector);
	
	GetClientAbsOrigin(client, clientpos);
	GetClientAbsOrigin(target, targetpos);
	
	if (heightcheck && distance > 0)
		resultdistance = GetVectorDistance(clientpos, targetpos);
	
	clientpos[2] = targetpos[2] = 0.0;
	MakeVectorFromPoints(clientpos, targetpos, targetvector);
	NormalizeVector(targetvector, targetvector);
	
	resultangle = RadToDeg(ArcCosine(GetVectorDotProduct(targetvector, anglevector)));
	
	if (resultangle <= angle / 2)
	{
		if (distance > 0)
		{
			if (!heightcheck)
				resultdistance = GetVectorDistance(clientpos, targetpos);
			
			if (distance >= resultdistance)
				return true;
			else return false;
		}
		else return true;
	}
	
	return false;
}

stock int getClientViewClient(int client) {
	float m_vecOrigin[3];
	float m_angRotation[3];
	GetClientEyePosition(client, m_vecOrigin);
	GetClientEyeAngles(client, m_angRotation);
	Handle tr = TR_TraceRayFilterEx(m_vecOrigin, m_angRotation, MASK_VISIBLE, RayType_Infinite, TraceEntityFilter:FilterOutPlayer, client);
	int pEntity = -1;
	if (TR_DidHit(tr)) {
		pEntity = TR_GetEntityIndex(tr);
		delete tr;
		if (!IsValidClient(client))
			return -1;
		if (!IsValidEntity(pEntity))
			return -1;
		float playerPos[3];
		float entPos[3];
		GetClientAbsOrigin(client, playerPos);
		GetEntPropVector(pEntity, Prop_Data, "m_vecOrigin", entPos);
		return pEntity;
	}
	delete tr;
	return -1;
}

public bool:FilterOutPlayer(entity, contentsMask, any:data)
{
    if (entity == data)
    {
        return false;
    }
    
    return true;
}

bool:IsValidClient(client) 
{
	if ( !( 1 <= client <= MaxClients ) || !IsClientInGame(client) ) 
		return false; 
	
	return true; 
}  