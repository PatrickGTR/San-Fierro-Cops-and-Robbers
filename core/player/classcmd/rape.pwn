#include <YSI\y_hooks>

#include "core/player/rape.pwn"

CMD:rape(playerid, params[])
{
	if(GetPlayerJob(playerid) != RAPIST || GetPlayerTeam(playerid) != TEAM_CIVILIAN)
		return MsgTag(playerid, TYPE_ERROR, "You are not allowed to use this command if you are not a rapist.");

	if(isnull(params))
		return MsgTag(playerid, TYPE_USAGE, "/rape <PlayerID>");

	new 
		targetid = strval( params );

	if(targetid == INVALID_PLAYER_ID)
		return MsgTag(playerid, TYPE_ERROR, "The player you are trying to rape is not connected.");

	if(!IsPlayerSpawned(targetid))
		return MsgTag(playerid, TYPE_ERROR, "The player you are trying to rape is not spawned.");

	if(IsPlayerInfected(targetid))
		return MsgTag(playerid, TYPE_ERROR, "The player you are trying to rape is already infected.");

	if(!IsPlayerNearPlayer(playerid, targetid, 4.0))
		return MsgTag(playerid, TYPE_ERROR, "The player you are trying to rape is not near you.");

	if(targetid == playerid)
		return MsgTag(playerid, TYPE_ERROR, "You can not rape your own self.");

	if(gettime() - jobData[playerid][HasJustUseRape] < 20)
		return MsgTag(playerid, TYPE_ERROR, "Please wait "C_GREY"%i seconds "C_WHITE"before using the command again.", gettime() - jobData[playerid][ HasJustUseRape ]);

	if(GetPlayerCondom(playerid) > 0)
	{
		-- GetPlayerCondom(playerid); 
		MsgF(playerid, COLOR_LIGHTGREEN, "Rape: "C_GREY"You tried to rape "C_GREY"%p (%i) "C_WHITE"but failed because he had Condoms.", targetid, targetid);
  	 	MsgF(targetid, COLOR_LIGHTGREEN, "Rape: "C_GREY"%p(%i) "C_WHITE"tried to rape you, luckily you have a condom, you have "C_GREY"%i "C_WHITE"condoms left", playerid, playerid, GetPlayerCondom(playerid));
  	 	return true;
 	}

	GivePlayerDisease(targetid, random(5) + 1);

	++ playerAccessories[playerid][totalRape];
	++ playerAccessories[targetid][totalBeenRaped];

	MsgAllF(COLOR_LIGHTGREEN, "Rape: "C_GREY"%p (%i) "C_WHITE"has infected "C_GREY"%p (%i) "C_WHITE"with "C_LGREEN"%s", playerid, playerid, targetid, targetid, GetDiseaseName(targetid));

	MsgF(playerid, COLOR_LIGHTGREEN, "Rape: "C_WHITE"You successfully raped "C_GREY"%p (%i) "C_WHITE"and infected him/her with "C_LGREEN"%s", targetid, targetid, GetDiseaseName(targetid));
	MsgF(targetid, COLOR_LIGHTGREEN, "Rape: "C_GREY"%p (%i) "C_WHITE"infected you with "C_LGREEN"%s"C_WHITE", get to the hospital and get cured asap!", playerid, playerid, GetDiseaseName(targetid));

	jobData[playerid][HasJustUseRape] = gettime();
	return true;
}


hook OnPlayerDeath(playerid, killerid, reason)
{
	if(IsPlayerInfected(playerid) && killerid == INVALID_PLAYER_ID)
	{
		MsgAllF(COLOR_LIGHTGREEN, "Death: "C_GREY"%p (%i) "C_WHITE"died because of "C_LGREEN"%s.", playerid, playerid, GetDiseaseName(playerid));
		GivePlayerDisease(playerid, NONE);
	}
}

