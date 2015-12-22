CMD:sellgun(playerid, params[])
{
	
	new 
		weaponid, targetid,weaponprice, weaponammo;

	if(GetPlayerJob(playerid) != WEAPON_DEALER || GetPlayerTeam(playerid) != TEAM_CIVILIAN)
		return MsgTag(playerid, TYPE_ERROR, "You are not allowed to use this command if you are not a weapon dealer.");

	if(gettime() - jobData[playerid][ HasJustSoldWeapon ] < 40)
		return MsgTag(playerid, TYPE_ERROR, "You just sold a weapon, please wait %i seconds ", gettime() - jobData[playerid][ HasJustSoldWeapon]);

	if(sscanf(params, "riii", targetid, weaponid, weaponprice, weaponammo))
		return MsgTag(playerid, TYPE_USAGE, "/sellweapon <playerid> <weaponid> <price> <ammo (max 1,000)>");

	if(!IsPlayerConnected(targetid))
		return MsgTag(playerid, TYPE_ERROR, "The player you are trying to sell weapon is not connected.");

	if(!IsPlayerSpawned(targetid))
		return MsgTag(playerid, TYPE_ERROR, "The player you are trying to sell weapon is not spawned.");

	if(!IsPlayerNearPlayer(playerid, targetid, 4.0))
		return MsgTag(playerid, TYPE_ERROR, "The player you are trying to sell weapon is not near you.");

	if(targetid == playerid)
		return MsgTag(playerid, TYPE_ERROR, "You can not sell a gun to your self.");

	if( 1000 <= weaponprice < 8000)
		return MsgTag(playerid, TYPE_ERROR, "Weapon price could not go lower than 1,000 and higher than 8,000");

	if(!(22 <= weaponid <= 34))
		return MsgTag(playerid, TYPE_ERROR, "Invalid weapon id. Weapon id can only go up to 22 - 34");

	if(!(0 <= weaponammo <= 1000))
		return MsgTag(playerid, TYPE_ERROR, "Invalid weapon ammo. Weapon ammo can only go up to 0 - 1000");

	jobData[targetid][HasBeenOffered] = true;
	jobData[targetid][WeaponID] = weaponid;
	jobData[targetid][WeaponPrice] = weaponprice;
	jobData[targetid][WeaponAmmo] = weaponammo;
 	jobData[targetid][WeaponSeller] = playerid;

	MsgF(playerid, COLOR_ORANGE, "Weapon: "C_WHITE" You have offered %p (%i) a %W for "C_GREEN"$%i"C_WHITE", wish you luck that he'll accept it!", targetid, targetid, weaponid, weaponprice);
	MsgF(targetid, COLOR_ORANGE, "Weapon: "C_WHITE" Weapon dealer "C_GREY"%p (%i) "C_WHITE"offered you a %W for "C_GREEN"$%i"C_WHITE", /acceptgun to accept his offer.", playerid, playerid, weaponid, weaponprice);
	
	jobData[playerid][ HasJustSoldWeapon ] = gettime();
	return true;
}

CMD:acceptgun(playerid, params[])
{
	if(!jobData[playerid][HasBeenOffered])
		return MsgTag(playerid, TYPE_ERROR, "No one offered you a gun.");

	if(GetPlayerMoney( playerid ) < jobData[playerid][WeaponPrice])
		return MsgTag(playerid, TYPE_ERROR, "You do not have enough money to buy the weapon.");

	GivePlayerMoney(playerid, -jobData[playerid][WeaponPrice]);
	GivePlayerMoney(jobData[playerid][WeaponSeller], jobData[playerid][WeaponPrice]);

	GivePlayerWeapon(playerid, jobData[playerid][WeaponID], jobData[playerid][WeaponAmmo]);

	MsgF(jobData[playerid][WeaponSeller], COLOR_ORANGE, "Weapon: "C_WHITE"%p (%i) accepted your offer, today you earned "C_GREEN"$%i"C_WHITE" for selling guns.", playerid, playerid, jobData[playerid][WeaponPrice]);
	MsgF(playerid, COLOR_ORANGE, "Weapon: "C_WHITE"You "C_GREEN"successfully "C_WHITE"bought a %W for "C_GREEN"$%i"C_WHITE" from "C_GREY"%p(%i)", jobData[playerid][WeaponID], jobData[playerid][WeaponPrice], 
	jobData[playerid][WeaponSeller], jobData[playerid][WeaponSeller] );

	jobData[playerid][HasBeenOffered] = false, 
	jobData[playerid][WeaponID] = -1, 
	jobData[playerid][WeaponPrice] = -1, 
	jobData[playerid][WeaponAmmo] = -1, 
	jobData[playerid][WeaponSeller] = INVALID_PLAYER_ID;

	return true;
}

CMD:sellarmour(playerid, params[])
{
	new 
		targetid, armourprice, armouramount; 

	if(GetPlayerJob(playerid) != WEAPON_DEALER || GetPlayerTeam(playerid) != TEAM_CIVILIAN)
		return MsgTag(playerid, TYPE_ERROR, "You are not allowed to use this command if you are not a weapon dealer.");

	if(gettime() - jobData[playerid][HasJustSoldArmour] < 40)
		return MsgTag(playerid, TYPE_ERROR, "You just sold a weapon, please wait %i seconds ", gettime() - jobData[playerid][ HasJustSoldWeapon]);

	if(sscanf(params, "rii", targetid, armourprice, armouramount))
		return MsgTag(playerid, TYPE_USAGE, "/sellarmour <PlayerID> <Price> <Amount>");

	if(!IsPlayerConnected(targetid))
		return MsgTag(playerid, TYPE_ERROR, "The player you are trying to sell weapon is not connected.");

	if(!IsPlayerSpawned(targetid))
		return MsgTag(playerid, TYPE_ERROR, "The player you are trying to sell weapon is not spawned.");

	if(!IsPlayerNearPlayer(playerid, targetid, 4.0))
		return MsgTag(playerid, TYPE_ERROR, "The player you are trying to sell armour is not near you.");

	if(targetid == playerid)
		return MsgTag(playerid, TYPE_ERROR, "You can not sell an armour to your self.");

	if(!(0 <= armouramount <= 100))
		return MsgTag(playerid, TYPE_ERROR, "Invalid armour amount. armour can only go up to 1 - 100"); 

	new 
		Float:PlayerArmour;

	GetPlayerArmour(playerid, PlayerArmour);

	if(PlayerArmour >= 80.0)
		return MsgTag(playerid, TYPE_ERROR, "The player you are trying to sell armour has got enough (%.1f).", PlayerArmour);

	jobData[targetid][HasBeenOffered] = true,
	jobData[targetid][WeaponPrice] = armourprice, 
	jobData[targetid][WeaponAmmo] = armouramount, 
	jobData[targetid][WeaponSeller] = playerid;

	MsgF(playerid, COLOR_ORANGE, "Weapon: "C_WHITE" You have offered "C_GREY"%p (%i) "C_WHITE"an armour(%i) for "C_GREEN"$%i"C_WHITE", wish you luck that he'll accept it!", targetid, targetid, armouramount, armourprice);
	MsgF(targetid, COLOR_ORANGE, "Weapon: "C_WHITE" Weapon dealer "C_GREY"%p (%i) "C_WHITE"offered you an armour(%i) for "C_GREEN"$%i"C_WHITE", /acceptarmour to accept his offer.", playerid, playerid, armouramount, armourprice);
	
	jobData[playerid][ HasJustSoldArmour ] = gettime();
	return true;
}

CMD:acceptarmour(playerid, params[])
{
	if(!jobData[playerid][HasBeenOffered])
		return MsgTag(playerid, TYPE_ERROR, "No one offered you a gun.");

	if(GetPlayerMoney( playerid ) < jobData[playerid][WeaponPrice])
		return MsgTag(playerid, TYPE_ERROR, "You do not have enough money to buy the weapon.");

	GivePlayerMoney(playerid, -jobData[playerid][WeaponPrice] );
	GivePlayerMoney(jobData[playerid][WeaponSeller], jobData[playerid][WeaponPrice]);

	new 
		Float:ply_armour;

	GetPlayerArmour(playerid, ply_armour);

	SetPlayerArmour(playerid, ply_armour + jobData[playerid][WeaponAmmo]);
	

	MsgF(jobData[playerid][WeaponSeller], COLOR_ORANGE, "Weapon: "C_WHITE"%p (%i) accepted your offer, today you earned "C_GREEN"$%i"C_WHITE" for selling an armour.", playerid, playerid, jobData[playerid][WeaponPrice]);
	MsgF(playerid, COLOR_ORANGE, "Weapon: "C_WHITE"You "C_GREEN"successfully "C_WHITE"bought an armour(%i) for "C_GREEN"$%i"C_WHITE" from "C_GREY"%p(%i)", jobData[playerid][WeaponAmmo], jobData[playerid][WeaponPrice], 
	jobData[playerid][WeaponSeller], jobData[playerid][WeaponSeller] );

	jobData[playerid][HasBeenOffered] = false, 
	jobData[playerid][WeaponPrice] = -1, 
	jobData[playerid][WeaponAmmo] = -1, 
	jobData[playerid][WeaponSeller] = INVALID_PLAYER_ID;
	return true;
}