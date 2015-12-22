#include <YSI\y_hooks>

/* Hooked Callbacks */

hook OnPlayerConnect(playerid)
{
	jobData[playerid] = resetPJobs;
	return true;
}

hook OnPlayerDisconnect(playerid, reason)
{
	jobData[playerid] = resetPJobs;
	return true;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	jobData[playerid][HasBeenOffered] = false,  jobData[playerid][WeaponID] = -1, 
	jobData[playerid][WeaponPrice] = -1, jobData[playerid][WeaponAmmo] = -1, jobData[playerid][WeaponSeller] = INVALID_PLAYER_ID;
}

#include "core/player/classcmd/hitman.pwn"
#include "core/player/classcmd/rape.pwn"
#include "core/player/classcmd/weapdealer.pwn"