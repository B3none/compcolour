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
	char colour[32];
	GetCmdArg(1, colour, sizeof(colour));
	int colour_id = GetColour(colour);
	
	if (strlen(colour) == 0)
	{
		PrintToConsole(client, "Please specify a colour.");
		
		return Plugin_Handled;
	}
	
	if (IsValidClient(client))
	{
		SetEntProp(client, Prop_Data, "m_iCompTeammateColor", colour_id);
		
		if (colour_id != /*GREY*/-1)
		{
			PrintToConsole(client, "Colour has been set to: %s", colour);
		}
		else
		{
			PrintToConsole(client, "Colour has been set to grey as a fallback.");
		}
		
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

int GetColour(char[] colour)
{
	if (StrEqual(colour, "yellow", false))
	{
		return YELLOW;
	}
	else if (StrEqual(colour, "purple", false))
	{
		return PURPLE;
	}
	else if (StrEqual(colour, "green", false))
	{
		return GREEN;
	}
	else if (StrEqual(colour, "blue", false))
	{
		return BLUE;
	}
	else if (StrEqual(colour, "orange", false))
	{
		return ORANGE;
	}
	else
	{
		return GREY;
	}
}

bool IsValidClient(int client)
{
	return client > 0 && client <= MaxClients;
}
