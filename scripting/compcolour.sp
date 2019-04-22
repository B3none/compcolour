#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

enum colours
{
    GREY = -1,
    YELLOW = 0,
    PURPLE = 1,
    GREEN = 2,
    BLUE = 3,
    ORANGE = 4,
}

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
	int colour_id;
	char colour[32];
	GetCmdArg(1, colour, sizeof(colour));
	
	if (strlen(colour) == 0)
	{
		PrintToConsole(client, "Please specify a colour.");
		
		return Plugin_Handled;
	}
	else if (StrEqual(colour, "grey", false))
	{
		colour_id = GREY;
	}
	else if (StrEqual(colour, "yellow", false))
	{
		colour_id = GREY;
	}
	else if (StrEqual(colour, "purple", false))
	{
		colour_id = GREY;
	}
	else if (StrEqual(colour, "green", false))
	{
		colour_id = GREY;
	}
	else if (StrEqual(colour, "blue", false))
	{
		colour_id = GREY;
	}
	else if (StrEqual(colour, "orange", false))
	{
		colour_id = GREY;
	}
	else
	{
		PrintToConsole(client, "Colour %s was not found.", colour);
		
		return Plugin_Handled;
	}
	
	if (IsValidClient(client))
	{
		SetEntProp(client, Prop_Data, "m_iCompTeammateColor", colour_id);
		PrintToConsole(client, "Colour has been set to: %s", colour);
	}
	
	return Plugin_Continue;
}

bool IsValidClient(int client)
{
	return client > 0 && client <= MaxClients;
}
