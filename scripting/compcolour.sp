#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name = "[CS:GO] CompColour",
	author = "B3none",
	description = "Set a client competitive colour.",
	version = "1.0.0",
	url = "https://github.com/b3none"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_compcolour", CompColour);
}

public Action CompColour(int client, any args)
{
	if (IsValidClient(client))
	{
		PrintToConsole(client, "Team colour: %i", GetEntProp(client, Prop_Data, "m_iCompTeammateColor"));
	}
}

bool IsValidClient(int client)
{
	return client > 0 && client <= MaxClients;
}
