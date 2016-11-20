#include <sourcemod>
#include <sdktools>

#define PLUGIN_DESCRIPTION "Change insurgency map"
#define PLUGIN_NAME "[INS] Map"
#define PLUGIN_VERSION "1.0.0"
#define PLUGIN_AUTHOR "Neko-"
#define PLUGIN_PREFIX "[CMap]"

public Plugin:myinfo = {
        name            = PLUGIN_NAME,
        author          = PLUGIN_AUTHOR,
        description     = PLUGIN_DESCRIPTION,
        version         = PLUGIN_VERSION,
};

public OnPluginStart() 
{
    //Admin with flag 'b' will able to use this command
    RegAdminCmd("sm_cmap", ChangeMap, ADMFLAG_GENERIC, "Change map");
    RegAdminCmd("sm_changemap", ChangeMap, ADMFLAG_GENERIC, "Change map");
}

public Action:ChangeMap(client, args) 
{
    decl String:strMapName[64];
    decl String:strMapType[16];

    if(args != 2)
    {
        PrintToChat(client, "%s Invalid Parameter!", PLUGIN_PREFIX);
        return Plugin_Handled;
    }

    GetCmdArg(1, strMapName, sizeof(strMapName));
    GetCmdArg(2, strMapType, sizeof(strMapType));

    ServerCommand("map %s %s", strMapName, strMapType);

    return Plugin_Handled;
}
