#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

#define MESSAGE_PREFIX "[\x04CompColour\x01]"

enum colours
{
    GREY = -1,
    YELLOW = 0,
    PURPLE = 1,
    GREEN = 2,
    BLUE = 3,
    ORANGE = 4,
}

char usage[] = "sm_compcolour <#userid|name> <yellow|purple|green|blue|orange|grey>";

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
	RegAdminCmd("sm_compcolour", CompColour, ADMFLAG_GENERIC, usage);
}

public Action CompColour(int client, any args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "%s Usage: %s", MESSAGE_PREFIX, usage);
		
		return Plugin_Handled;
	}
	
	char arg[MAX_NAME_LENGTH], colour[32];
	
	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS];
	bool tn_is_ml;
	int target_count = ProcessTargetString(arg, client, target_list, MAXPLAYERS, COMMAND_TARGET_NONE, target_name, sizeof(target_name), tn_is_ml);
	
	if (target_count > 0)
	{
		if (target_count > 1)
		{
			ReplyToCommand(client, "%s Multiple players found for search term: %s", MESSAGE_PREFIX, arg);
			
			return Plugin_Handled;
		}
		
		GetCmdArg(2, colour, sizeof(colour));
		int colour_id = GetColour(colour);
		
		if (!IsValidColour(colour_id))
		{
			PrintToChat(client, "%s Invalid colour.", MESSAGE_PREFIX);
			ReplyToCommand(client, "%s Usage: %s", MESSAGE_PREFIX, usage);
			
			return Plugin_Handled;
		}
		
		int target = target_list[0];
		
		SetColour(target, colour_id);
		ReplyToCommand(client, "%s The colour for %N has been set to: %s", MESSAGE_PREFIX, target, colour);
		
		return Plugin_Handled;
	}

	ReplyToTargetError(client, target_count);
	return Plugin_Handled;
}

void SetColour(int client, int colour_id)
{
	SetEntProp(client, Prop_Data, "m_iCompTeammateColor", colour_id);
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
	else if (StrEqual(colour, "grey", false))
	{
		return GREY;
	}
	else
	{
		return -2; // Out of bounds value
	}
}

bool IsValidColour(int colour)
{
	return colour >= -1 && colour <= 4;
}

stock bool IsValidClient(int client)
{
	return client > 0 && client <= MaxClients && IsClientInGame(client);
}
