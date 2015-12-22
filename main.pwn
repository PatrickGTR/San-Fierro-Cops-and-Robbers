#include <a_samp>

native gpci (playerid, serial [], len);

#undef MAX_PLAYERS
#define MAX_PLAYERS 			(50)

//#include <SAMP_Fixer/fix_attachments>

/* - 
	How it happens behind the console
	--------------------------------------
	* OnGameModeInitEx - first
		* hooks of OnGameModeInit - second
	--------------------------------------


	"OnGameModeInitEx" will be called first to avoid crashes and confusion within the hooks.

	Everything that you have to do regarding OnGameModeInit
	You have to place them in "OnGameModeInitEx" to make sure other hooks will not mess up on start up.

*/

public OnGameModeInit()
{

	OnGameModeInitEx();

	#if defined main_OnGameModeInit
		return main_OnGameModeInit();
	#else
		return 1;
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
 
#define OnGameModeInit main_OnGameModeInit
#if defined main_OnGameModeInit
	forward main_OnGameModeInit();
#endif

/*======================================================================================================
										[Includes]
=======================================================================================================*/

#include <YSI\y_timers>
#include <YSI\y_dialog>
#include <YSI\y_inline>
#include <YSI\y_va>
#include <YSI\y_iterate>
#include <YSI\y_bit>
							// Y_Less 		Source: https://github.com/Misiur/YSI-Includes 	
															
#include <sscanf2>			// Y_Less 		Source: http://forum.sa-mp.com/showthread.php?t=570927
#include <CTime>			// Ryder 		Source: http://forum.sa-mp.com/showthread.php?t=294054	
#include <geolocation>		// Whitetiger 	Source: http://forum.sa-mp.com/showthread.php?t=296171
#include <yoursql> 			// Gammix 		Source: http://forum.sa-mp.com/showthread.php?t=592661
#include <streamer>			// Icognito 	Source: http://forum.sa-mp.com/showthread.php?t=102865
#include <formatex> 		// Slice 		Source: http://forum.sa-mp.com/showthread.php?t=313488
	/*
		----- [Specifiers of formatex] -----
		____________________________________

		%p 	- 	Name of the player ID given.-
		%P 	- 	Name of the player ID given, with the player's color before it.
		%C 	- 	Inline color (ex. {FFFFFF}) from a normal color (ex. colors you get from GetPlayerColor).
		%v 	- 	Vehicle model name from the model given (not vehicle ID, vehicle model).
		%w 	- 	Weapon name, lower-case singular (to be used in sentences). Example: "an M4", "a combat shotgun", "a knife".
		%W 	- 	Weapon's name.
		%X 	- 	8-byte, unsigned hex string (ex. FFFFFFFF).
		%u 	- 	Unsigned integer.
		%m 	- 	format the money instead of 100000 it will be formatted to 100,000
		____________________________________
	*/

#define ACCOUNT_DEBUG

/*======================================================================================================
										[Macros]
=======================================================================================================*/

#define HOLDING(%0) 				((newkeys & (%0)) == (%0))
#define PRESSED(%0) 				(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define PRESSING(%0,%1) 			(%0 & (%1))
#define RELEASED(%0) 				(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
	
#define MAX_PASSWORD 				(65)

#define SERVER_DATABASE				"sfcnr.db"

#define IsPlayerSpawned(%0)         playerData[%0][pSpawned]

#define SetPlayerJob(%0,%1)         playerData[%0][pJob] =          (%1)
#define GetPlayerJob(%0)            playerData[%0][pJob]

#define SetPlayerWeed(%0,%1)        playerItems[%0][pWeed] =        (%1)
#define GivePlayerWeed(%0,%1)       playerItems[%0][pWeed] +=       (%1)
#define GetPlayerWeed(%0)           playerItems[%0][pWeed]

#define SetPlayerCrack(%0,%1)       playerItems[%0][pCrack] =       (%1)
#define GivePlayerCrack(%0,%1)      playerItems[%0][pCrack] +=      (%1)
#define GetPlayerCrack(%0)          playerItems[%0][pCrack]

#define SetPlayerRope(%0,%1)        playerItems[%0][pRope] =       	(%1)
#define GivePlayerRope(%0,%1)       playerItems[%0][pRope] +=      	(%1)
#define GetPlayerRope(%0)           playerItems[%0][pRope]

#define SetPlayerCondom(%0,%1)    	playerItems[%0][pCondom] =		(%1)
#define GivePlayerCondom(%0,%1)    	playerItems[%0][pCondom] += 	(%1)
#define GetPlayerCondom(%0)         playerItems[%0][pCondom]

#define SetPlayerWallet(%0,%1)    	playerItems[%0][pWallet] =		(%1)
#define GivePlayerWallet(%0,%1)    	playerItems[%0][pWallet] += 	(%1)
#define GetPlayerWallet(%0)         playerItems[%0][pWallet]

#define SetPlayerPickLock(%0,%1)    playerItems[%0][pPickLock] =    (%1)
#define GivePlayerPickLock(%0,%1)   playerItems[%0][pPickLock] +=   (%1)
#define GetPlayerPickLock(%0)       playerItems[%0][pPickLock]

#define SetPlayerScissors(%0,%1)    playerItems[%0][pScissors] =    (%1)
#define GivePlayerScissors(%0,%1)   playerItems[%0][pScissors] +=   (%1)
#define GetPlayerScissors(%0)       playerItems[%0][pScissors]

/*======================================================================================================
										[Declarations]
=======================================================================================================*/

enum pData
{
    //non-saveable variables.
    bool:pLoggedIn,
    bool:pSpawned,
    //saveable variables.
    pAccountID,
    pPassword[MAX_PASSWORD],
    pSalt[11],
    pAdmin,
    pJob,
    pKills,
    pDeaths
}

enum pAccessories
{
	totalRape,
	totalBeenRaped,
	totalRob,
	totalBeenRobbed,
	totalStoreRobbed,
	totalCuffEscape,
	totalArrest,
	totalBeenArrested,
}

enum pItems
{
    pWeed,
    pCrack,
    pRope,
    pPickLock,
    pScissors,
    pCondom,
    pWallet
}

enum pJobs
{	
	//Hitman
	HitAmount,
	HitReason[32],
	HitPlacedBy[MAX_PLAYER_NAME],
	bool:HasHit,

	//Weapon Dealer
	WeaponPrice,
	WeaponID,
	WeaponAmmo,
	WeaponSeller,
	bool:HasBeenOffered,

	//Properties of Weapon Dealer Job.
	HasJustSoldWeapon,
	HasJustSoldArmour,

	//Rapist
	DiseaseType,
	HasJustUseRape,
}


#define TEAM_CIVILIAN	NO_TEAM
#define TEAM_POLICE		(0)
#define TEAM_ARMY		(1)

#define NO_JOB			NO_TEAM	
#define DRUG_DEALER		(0)
#define WEAPON_DEALER	(1)
#define HITMAN			(2)
#define HACKER			(3)
#define RAPIST			(4)

new 
    playerData[MAX_PLAYERS][pData],
    playerAccessories[MAX_PLAYERS][pAccessories],
    playerItems[MAX_PLAYERS][pItems], 
    jobData[MAX_PLAYERS][pJobs],
	SQL:serverDB,
	globalString[1024];

new 
	resetPJobs[pJobs],
	resetPItems[pItems],
	resetPData[pData],
	resetPAccessories[pAccessories];

forward OnPlayerLogin(playerid);
forward OnPlayerRegister(playerid);


/*======================================================================================================
										[Modules]
=======================================================================================================*/

//Main
#include "utils/fixes.pwn"
#include "utils/cmd.pwn"
#include "utils/colours.pwn"
#include "utils/string.pwn"
#include "utils/time.pwn"
#include "utils/zones.pwn"
#include "utils/players.pwn"


//Graphical User Interfacex
#include "gui/boxinfo.pwn"
#include "gui/requestclassTD.pwn"
#include "gui/zoneTD.pwn"

//Server
#include "core/server/carspawns.pwn"
#include "core/server/bribery.pwn"

//Robbery
#include "core/server/robbery/core.pwn"
#include "core/server/robbery/callback.pwn"
#include "core/server/robbery/store.pwn"

//Player
#include "core/player/core.pwn"
#include "core/player/account.pwn"
#include "core/player/jail.pwn"
#include "core/player/attachment.pwn"

//Player commands
#include "core/player/globalcmd/core.pwn"

//Team Commands
#include "core/player/teamcmd/core.pwn"

//Class Commands
#include "core/player/classcmd/core.pwn"

//Admin
#include "core/admin/core.pwn"
#include "core/admin/ban.pwn"
#include "core/admin/bancmd.pwn"

/*======================================================================================================
									[Global Timer]
======================================================================================================*/

task playerGlobalTimer[1000]()
{
    foreach(new playerid : Player)
    {
        if(!IsPlayerSpawned(playerid))
            return 1;
        
        SetPlayerLocationTD(playerid, GetPlayerLocation(playerid));
        UpdatePlayerDiseaseDamage(playerid);

      	switch(GetPlayerAnimationIndex(playerid)) //IsPlayerAiming (avoid calling the callback if the player isn't aiming)
    	{
        	case 1167, 1365, 1643, 1453, 220: OnPlayerRobberyAimCheck(playerid);
   	 	}
    }
    return 1;
}

/*======================================================================================================
										[Main]
======================================================================================================*/

main(){}


OnGameModeInitEx()
{
	serverDB = yoursql_open(SERVER_DATABASE);

	UsePlayerPedAnims();
	DisableInteriorEnterExits();	

	AddPlayerClassEx(TEAM_CIVILIAN, 56, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0); 
	AddPlayerClassEx(TEAM_CIVILIAN, 119, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 55, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 60, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 11, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 2, 		0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 299, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 296, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 297, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 294, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 293, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0); 
	AddPlayerClassEx(TEAM_CIVILIAN, 289, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 272, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 264, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0); 
	AddPlayerClassEx(TEAM_CIVILIAN, 268, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0); 
	AddPlayerClassEx(TEAM_CIVILIAN, 259, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 250, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 240, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 221, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 134, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 29, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 22, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_CIVILIAN, 19, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

	// Police Officer Skins
	AddPlayerClassEx(TEAM_POLICE, 	280, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_POLICE, 	281, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_POLICE, 	282, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_POLICE, 	283, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(-TEAM_POLICE, 	284, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_POLICE, 	285, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

	// Army Skins
	AddPlayerClassEx(TEAM_ARMY,		121, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_ARMY,		191, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClassEx(TEAM_ARMY,		287, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}
	
public OnGameModeExit()
{
	yoursql_close(serverDB);
	return 1;
}


CMD:kill(playerid, params[])
{
	SetPlayerHealth(playerid, 0);
	return 1;
}

CMD:weapon(playerid, params[])
{
	GivePlayerWeapon(playerid, 24, 9999);
	return 1;
}