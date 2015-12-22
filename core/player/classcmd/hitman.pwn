#include <YSI\y_hooks>

/*======================================================================================================
									[Hooked Callback]
======================================================================================================*/

hook OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID )
	{
		if(jobData[playerid][HasHit] == true && GetPlayerJob(killerid) == HITMAN)
		{
			MsgAllF(COLOR_ORANGE, "Hit: "C_GREY"%p (%i) "C_WHITE"has completed the hit on "C_GREY"%p (%i) "C_WHITE"and recieved "C_GREEN"$%i.", killerid, killerid, playerid, playerid, jobData[playerid][ HitAmount ] );
			
			GivePlayerMoney(killerid, jobData[playerid][HitAmount]);

			jobData[playerid][HasHit] = false, jobData[playerid][ HitAmount ] = 0, 
			jobData[playerid][HitReason][ 0 ] = EOS, jobData[playerid][HitPlacedBy][ 0 ] = EOS;

		}
		if(jobData[playerid][HasHit] == true && GetPlayerJob(killerid) != HITMAN)
		{
			MsgAllF(COLOR_ORANGE, "Hit: "C_WHITE"Contract on "C_GREY"%p (%i) "C_WHITE"has been cancelled, player died.", playerid, playerid);

			jobData[playerid][HasHit] = false;
			jobData[playerid][HitAmount] = 0, 
			jobData[playerid][HitReason][0] = EOS;
			jobData[playerid][HitPlacedBy][0] = EOS;
		}
	}
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(jobData[playerid][HasHit] == true) 
		MsgAllF(COLOR_ORANGE, "Hit: "C_WHITE"Contract on "C_GREY"%p (%i) "C_WHITE"has been cancelled, player left.", playerid, playerid );
}

/*======================================================================================================
										[Commands]
======================================================================================================*/

CMD:hitlist(playerid, params[])
{
	new 
		count = 0;

	if(GetPlayerJob(playerid) != HITMAN || GetPlayerTeam(playerid) != TEAM_CIVILIAN)
		return MsgTag(playerid, TYPE_ERROR, "You are not allowed to use this command if you are not a hitman.");

	Msg(playerid, COLOR_GREEN, "______________________ "C_ORANGE"[ Begin - Hitlist ] "C_GREEN"______________________");
	foreach(new i : Player)
	{
		if(jobData[i][HasHit] == true)
		{
			MsgF(playerid, COLOR_WHITE, "Username: %p (%i) - Placed By: %s - Reason: %s- Amount: "C_GREEN"$%i", i, i, jobData[i][HitPlacedBy],  jobData[i][HitReason], jobData[i][ HitAmount ]);
			++ count;
		}
	}
	if(count != 1) Msg(playerid, COLOR_WHITE, "There are no hits available");
	Msg(playerid, COLOR_GREEN, "______________________ "C_ORANGE"[ Final - Hitlist ] "C_GREEN"______________________");
	return true;
}


CMD:track(playerid, params[])
{	
	if(GetPlayerJob(playerid) != HITMAN || GetPlayerTeam(playerid) != TEAM_CIVILIAN)
		return MsgTag(playerid, TYPE_ERROR, "You are not allowed to use this command if you are not a hitman.");

	if( isnull( params ) )
		return MsgTag(playerid, TYPE_USAGE, "/tracj <PlayerID>");

	new targetid = strval(params);

	if( targetid == playerid )
		return MsgTag(playerid, TYPE_ERROR, "You are not allowed to track your own self.");

	if( !IsPlayerConnected( targetid ) )
		return MsgTag(playerid, TYPE_ERROR, "The player you are trying to track is not connected.");

	if( !IsPlayerSpawned( targetid ) )
		return MsgTag(playerid, TYPE_ERROR, "The player you are trying to track is not spawned.");

	if( GetPlayerInterior(targetid) > 1 )
	{
		MsgF(playerid, COLOR_WHITE, "Location of "C_GREY"%p "C_WHITE"near "C_GREY"inside an interior", targetid);
	}
	else MsgF(playerid, COLOR_WHITE, "Location of "C_GREY"%p "C_WHITE"near "C_GREY"%s", targetid, GetPlayerLocation(playerid));
	return true;
}	

CMD:placehit(playerid, params[])
{
	new 
		targetid, hitamount, reason[32];

	if(GetPlayerJob(playerid) == HITMAN && GetPlayerTeam(playerid) == TEAM_CIVILIAN )
		return MsgTag(playerid, TYPE_ERROR, "You are not allowed to place hit on others if you are a hitman.");

	if(sscanf(params, "ris[32]", targetid, hitamount, reason))
		return Msg(playerid, COLOR_YELLOW, "Usage: "C_WHITE"/placehit <PlayerID> <Amount> <Reason>");

	if( !IsPlayerConnected( targetid ) )
		return MsgTag(playerid, TYPE_ERROR, "The player you are placing hit on is not connected.");

	if( !IsPlayerSpawned( targetid ) )
		return MsgTag(playerid, TYPE_ERROR, "The player you are placing hit on is not spawned.");

	if( GetPlayerMoney(playerid) < hitamount)
		return MsgTag(playerid, TYPE_ERROR, "You do not have enough money to pay the hit, earn more money!");

	if( hitamount < 10000 )
		return MsgTag(playerid, TYPE_ERROR, "The hitman will not accept your offer, increase the amount of the hit!");

	if(jobData[targetid][HasHit] == true)
		return MsgTag(playerid, TYPE_ERROR, "The player you are placing hit on already have hit.");

	jobData[targetid][ HitAmount ] = hitamount;
	jobData[targetid][HasHit] = true;

	new 
		name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);

	strcpy(jobData[targetid][HitReason], reason, 32);
	strcpy(jobData[targetid][HitPlacedBy], name, MAX_PLAYER_NAME);

	GivePlayerMoney(playerid, -hitamount);

	MsgF(playerid, COLOR_ORANGE, "Hit: "C_WHITE"You successfully placed a hit on "C_GREY"%p (%i) "C_WHITE"for "C_GREEN"$%i"C_WHITE", reason: "C_GREY"%s", targetid, targetid, hitamount, reason);
	MsgAllF(COLOR_ORANGE, "Hit: "C_GREY"%p (%i) "C_WHITE"placed a hit on "C_GREY"%p (%i) "C_WHITE"for "C_GREEN"$%i"C_WHITE", reason: "C_GREY"%s", playerid, playerid, targetid, targetid, hitamount, reason);
	return true;
}