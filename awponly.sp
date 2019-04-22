#include <sourcemod>
#include <smlib>

ConVar EnablePlugin;
ConVar DeleteMapWeapons;

public Plugin myinfo = 
{
	name = "AWP Only",
	author = "xSLOW",
	description = "Disable weapons placed on the map & give AWP and KNIFE to the player",
	version = "1.0"
};

public OnPluginStart()
{
    HookEvent("player_spawn", Event_PlayerSpawn);

    EnablePlugin = CreateConVar("sm_awponly_enableplugin", "1", "1 = Plugin enabled, 0 = Plugin disabled", FCVAR_NOTIFY);
    DeleteMapWeapons = CreateConVar("sm_awponly_deletemapweapons", "1", "1 = Delete weapons placed on the map, 0 = Don't delete weapons placed on the map", FCVAR_NOTIFY);

    AutoExecConfig(true, "awponly");
}

public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));
    if(EnablePlugin.IntValue == 1)
        SetWeapons(client);
}

public void OnMapStart()
{
    if(EnablePlugin.IntValue == 1 && DeleteMapWeapons.IntValue == 1)
        ServerCommand("sm_cvar mp_weapons_allow_map_placed 0")
}


stock bool IsClientValid(int client)
{
    if (client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && !IsFakeClient(client))
        return true;
    return false;
}

public void SetWeapons(int client)
{
    if(IsClientValid(client))
    {
        Client_RemoveAllWeapons(client, "", true);
        GivePlayerItem(client, "weapon_awp");
        GivePlayerItem(client, "weapon_knife");
    }
}