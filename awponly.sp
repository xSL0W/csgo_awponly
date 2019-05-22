#include <sourcemod>
#include <smlib>

ConVar g_cvEnablePlugin;
ConVar g_cvDeleteMapWeapons;
ConVar g_cvKnifeOnlyWarmup

public Plugin myinfo = 
{
	name = "AWP Only",
	author = "xSLOW",
	description = "Disable weapons placed on the map & give AWP + KNIFE to the players",
	version = "1.1"
};


public OnPluginStart()
{
    HookEvent("player_spawn", Event_PlayerSpawn);

    g_cvEnablePlugin = CreateConVar("sm_awponly_enableplugin", "1", "1 = Plugin enabled, 0 = Plugin disabled", FCVAR_NOTIFY);
    g_cvKnifeOnlyWarmup = CreateConVar("sm_awponly_warmupknifeonly", "0", "1 = Knife only in warmup, 0 = AWP + Knife in warmup", FCVAR_NOTIFY);
    g_cvDeleteMapWeapons = CreateConVar("sm_awponly_deletemapweapons", "1", "1 = Delete weapons placed on the map, 0 = Don't delete weapons placed on the map");

    AutoExecConfig(true, "awponly");
}


public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
    if(g_cvEnablePlugin.IntValue == 1)
        RequestFrame(SetWeapons, GetClientOfUserId(GetEventInt(event, "userid")));
}


public void OnMapStart()
{
    if(g_cvEnablePlugin.IntValue == 1 && g_cvDeleteMapWeapons.IntValue == 1)
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
    if(IsClientValid(client) && IsPlayerAlive(client))
    {
        if(g_cvKnifeOnlyWarmup.IntValue == 1)
        {
            if(GameRules_GetProp("m_bWarmupPeriod") == 1)
            {
                Client_RemoveAllWeapons(client, "", true);
                GivePlayerItem(client, "weapon_knife");
            }
            else
            {
                Client_RemoveAllWeapons(client, "", true);
                GivePlayerItem(client, "weapon_awp");
                GivePlayerItem(client, "weapon_knife");
            }
        }
        else
        {
            Client_RemoveAllWeapons(client, "", true);
            GivePlayerItem(client, "weapon_awp");
            GivePlayerItem(client, "weapon_knife");
        }
    }
}