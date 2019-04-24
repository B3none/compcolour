#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

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
bool loaded_player_colours = false;
int player_colours[MAXPLAYERS + 1];
char usage[] = "sm_compcolour <name> <yellow|purple|green|blue|orange|grey>";

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
	LoadTranslations("common.phrases");

	RegAdminCmd("sm_compcolour", CompColour, ADMFLAG_GENERIC, usage);
	RegAdminCmd("sm_cc", CompColour, ADMFLAG_GENERIC, usage);
}

public void OnMapStart()
{
	int playerManager = GetPlayerResourceEntity();
	if (playerManager == -1)
	{
		SetFailState("Unable to find cs_player_manager entity");
	}
	
	SDKHook(playerManager, SDKHook_ThinkPost, OnThinkPost);
}

public void OnThinkPost(int entity)
{
	int offset = FindSendPropInfo("CCSPlayerResource", "m_iCompTeammateColor");
	
	if (!loaded_player_colours)
	{
		GetEntDataArray(entity, offset, player_colours, MAXPLAYERS + 1);
		loaded_player_colours = true;
	}
	
	if (offset > 0)
	{
		SetEntDataArray(entity, offset, player_colours, MAXPLAYERS + 1, _, true);
	}
}

public Action CompColour(int client, int args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "%s Usage: %s", MESSAGE_PREFIX, usage);
		
		return Plugin_Handled;
	}
	
	char arg[MAX_NAME_LENGTH], colour[32];
	GetCmdArg(1, arg, sizeof(arg));
	
	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS];
	bool tn_is_ml;
	int target_count = ProcessTargetString(arg, client, target_list, MAXPLAYERS, COMMAND_FILTER_NO_IMMUNITY, target_name, sizeof(target_name), tn_is_ml);
	
	if (target_count <= 0)
	{
		ReplyToTargetError(client, COMMAND_TARGET_NONE);	
		return Plugin_Handled;
	}

	for (int i = 0; i < target_count; i++)
	{
		int target = target_list[i];
		
		GetCmdArg(2, colour, sizeof(colour));
		int colour_id = GetColour(colour);
		
		if (!IsValidColour(colour_id))
		{
			ReplyToCommand(client, "%s Invalid colour.", MESSAGE_PREFIX);
			ReplyToCommand(client, "%s Usage: %s", MESSAGE_PREFIX, usage);
			
			return Plugin_Handled;
		}
		
		SetColour(target, colour_id);
		ReplyToCommand(client, "%s The competative colour for %N has been set to: %s", MESSAGE_PREFIX, target, colour);
	}
	
	return Plugin_Handled;
}

stock bool SetColour(int client, int colour_id)
{
	player_colours[client] = colour_id;
	return true;
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
