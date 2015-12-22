#include <YSI\y_hooks>

#define TABLE_ACCOUNTS				"accounts"
#define COLUMN_NAME					"username"
#define COLUMN_SCORE				"score"
#define COLUMN_PASS					"password"
#define COLUMN_SALT					"salt"
#define COLUMN_ADM					"adminlvl"
#define COLUMN_CLASS				"playerclass"
#define COLUMN_KILLS				"kills"
#define COLUMN_DEATHS				"deaths"
			
#define TABLE_ITEMS					"items"
#define COLUMN_WEED					"weed"
#define COLUMN_CRACK				"crack"
#define COLUMN_ROPE					"rope"
#define COLUMN_PICKLOCK				"picklock"
#define COLUMN_SCISSORS				"scissors"
#define COLUMN_CONDOM				"condom"
#define COLUMN_WALLET				"wallet"
	
#define TABLE_ACCESSORIES			"accessories"
#define COLUMN_TOTALRAPE			"totalrape"
#define COLUMN_TOTALBEENRAPED		"totalbeenraped"
#define COLUMN_TOTALROB 			"totalrob"
#define COLUMN_TOTALBEENROBBED		"totalbeenrobbed"
#define COLUMN_TOTALSTOREROB 		"totalstorerob"
#define COLUMN_TOTALARREST			"totalarrest"
#define COLUMN_TOTALBEENARRESTED	"totalbeenarrested"


hook OnGameModeInit()
{
	yoursql_verify_table(serverDB, TABLE_ACCOUNTS);
	yoursql_verify_column(serverDB, ""TABLE_ACCOUNTS"/"COLUMN_NAME"", 	SQL_STRING);
	yoursql_verify_column(serverDB, ""TABLE_ACCOUNTS"/"COLUMN_SCORE"", 	SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ACCOUNTS"/"COLUMN_PASS"", 	SQL_STRING);
	yoursql_verify_column(serverDB, ""TABLE_ACCOUNTS"/"COLUMN_SALT"", 	SQL_STRING);
	yoursql_verify_column(serverDB, ""TABLE_ACCOUNTS"/"COLUMN_ADM"", 	SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ACCOUNTS"/"COLUMN_CLASS"", 	SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ACCOUNTS"/"COLUMN_KILLS"", 	SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ACCOUNTS"/"COLUMN_DEATHS"", SQL_NUMBER);

	yoursql_verify_table(serverDB, TABLE_ACCESSORIES);
	yoursql_verify_column(serverDB, ""TABLE_ACCESSORIES"/"COLUMN_NAME"", 				SQL_STRING);
	yoursql_verify_column(serverDB, ""TABLE_ACCESSORIES"/"COLUMN_TOTALRAPE"", 			SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ACCESSORIES"/"COLUMN_TOTALBEENRAPED"", 		SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ACCESSORIES"/"COLUMN_TOTALROB"", 			SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ACCESSORIES"/"COLUMN_TOTALBEENROBBED"", 	SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ACCESSORIES"/"COLUMN_TOTALSTOREROB"", 		SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ACCESSORIES"/"COLUMN_TOTALARREST"", 		SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ACCESSORIES"/"COLUMN_TOTALBEENARRESTED"", 	SQL_NUMBER);

	yoursql_verify_table(serverDB, TABLE_ITEMS);
	yoursql_verify_column(serverDB, ""TABLE_ITEMS"/"COLUMN_NAME"", 		SQL_STRING);
	yoursql_verify_column(serverDB, ""TABLE_ITEMS"/"COLUMN_WEED"", 		SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ITEMS"/"COLUMN_CRACK"", 	SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ITEMS"/"COLUMN_ROPE"", 		SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ITEMS"/"COLUMN_PICKLOCK"", 	SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ITEMS"/"COLUMN_SCISSORS"", 	SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ITEMS"/"COLUMN_CONDOM"", 	SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ITEMS"/"COLUMN_WALLET"", 	SQL_NUMBER);
}

hook OnPlayerConnect(playerid)
{
	playerData[playerid] = resetPData;
	playerAccessories[playerid] = resetPAccessories;
	playerItems[playerid] = resetPItems;

	RetrievePlayerData(playerid);
}

hook OnPlayerDisconnect(playerid, reason)
{
	SavePlayerData(playerid);

	playerData[playerid] = resetPData;
	playerAccessories[playerid] = resetPAccessories;
	playerItems[playerid] = resetPItems;
}

RetrievePlayerData(playerid)
{
	new 
		name[MAX_PLAYER_NAME], SQLRow:rowid, string[128];

	GetPlayerName(playerid, name, sizeof(name));
	rowid = yoursql_get_row(serverDB, TABLE_ACCOUNTS, ""COLUMN_NAME" = %s", name);
	if(rowid != SQL_INVALID_ROW)
	{
		inline dialogLogin(pid, dialogid, response, listitem, string:inputtext[])
		{
        	#pragma unused pid, dialogid, response, listitem, inputtext
        
			if(!response)
			{
				Kick(playerid);
				return 1;
			}

			yoursql_multiget_fields(serverDB, TABLE_ACCOUNTS, rowid, "ss", COLUMN_SALT, playerData[playerid][pSalt], COLUMN_PASS, playerData[playerid][pPassword]);

			new password[MAX_PASSWORD];
			SHA256_PassHash(inputtext, playerData[playerid][pSalt], password, sizeof(password));

			if(!inputtext[0] || strcmp(password, playerData[playerid][pPassword]))
			{
				MsgTag(playerid, TYPE_ERROR, "The password doesn't match with the account's password.");
				goto showRDIALOG;
				return 1;
			}
			
			new 
				score;

			yoursql_multiget_fields(serverDB, TABLE_ACCOUNTS, rowid, "iiiii", 
				COLUMN_SCORE, 	score,
				COLUMN_ADM, 	playerData[playerid][pAdmin], 
				COLUMN_CLASS, 	playerData[playerid][pJob], 
				COLUMN_KILLS, 	playerData[playerid][pKills], 
				COLUMN_DEATHS, 	playerData[playerid][pDeaths]);
			
			SetPlayerScore(playerid, score);

			#if defined ACCOUNT_DEBUG	
				printf("\n[LOADING %s's DATA] - TABLE: %s - ACC ID: %i", name, TABLE_ACCOUNTS, _:rowid);
				printf("COLUMN_%s: %i", COLUMN_SCORE, GetPlayerScore(playerid));
				printf("COLUMN_%s: %i - COLUMN_%s: %i", COLUMN_ADM, playerData[playerid][pAdmin], COLUMN_CLASS, GetPlayerJob(playerid));
				printf("COLUMN_%s: %i - COLUMN_%s: %i\n", COLUMN_KILLS, playerData[playerid][pKills], COLUMN_DEATHS, playerData[playerid][pDeaths]);
			#endif

			rowid = yoursql_get_row(serverDB, TABLE_ACCESSORIES, ""COLUMN_NAME" = %s", name);

			yoursql_multiget_fields(serverDB, TABLE_ACCESSORIES, rowid, "iiiiiii", 
				COLUMN_TOTALRAPE, 			playerAccessories[playerid][totalRape], 
				COLUMN_TOTALBEENRAPED, 		playerAccessories[playerid][totalBeenRaped], 
				COLUMN_TOTALROB,		 	playerAccessories[playerid][totalRob], 
				COLUMN_TOTALBEENROBBED, 	playerAccessories[playerid][totalBeenRobbed], 
				COLUMN_TOTALSTOREROB, 		playerAccessories[playerid][totalStoreRobbed],
				COLUMN_TOTALARREST, 		playerAccessories[playerid][totalArrest],
				COLUMN_TOTALBEENARRESTED, 	playerAccessories[playerid][totalBeenArrested]);

			#if defined ACCOUNT_DEBUG	
				printf("\n[LOADING %s's DATA] - TABLE: %s - ACC ID: %i", name, TABLE_ACCESSORIES, _:rowid);
				printf("COLUMN_%s: %i - COLUMN_%s: %i", COLUMN_TOTALRAPE, playerAccessories[playerid][totalRape], COLUMN_TOTALBEENRAPED, playerAccessories[playerid][totalBeenRaped]);
				printf("COLUMN_%s: %i - COLUMN_%s: %i", COLUMN_TOTALROB, playerAccessories[playerid][totalRob], COLUMN_TOTALBEENROBBED, playerAccessories[playerid][totalBeenRobbed]);
				printf("COLUMN_%s: %i - COLUMN_%s: %i", COLUMN_TOTALSTOREROB, playerAccessories[playerid][totalStoreRobbed], COLUMN_TOTALARREST, playerAccessories[playerid][totalArrest]);
				printf("COLUMN_%s: %i\n", COLUMN_TOTALBEENARRESTED, playerAccessories[playerid][totalBeenArrested]);
			#endif

			rowid = yoursql_get_row(serverDB, TABLE_ITEMS, ""COLUMN_NAME" = %s", name);

			yoursql_multiget_fields(serverDB, TABLE_ITEMS, rowid, "iiiiiii", 
				COLUMN_WEED, 		playerItems[playerid][pWeed], 
				COLUMN_CRACK, 		playerItems[playerid][pCrack], 
				COLUMN_ROPE, 		playerItems[playerid][pRope], 
				COLUMN_PICKLOCK, 	playerItems[playerid][pPickLock], 
				COLUMN_SCISSORS, 	playerItems[playerid][pScissors],
				COLUMN_CONDOM, 		playerItems[playerid][pCondom],
				COLUMN_WALLET, 		playerItems[playerid][pWallet]);
			
			#if defined ACCOUNT_DEBUG
				printf("\n[LOADING %s's DATA] - TABLE: %s - ACC ID: %i", name, TABLE_ITEMS, _:rowid);
				printf("COLUMN_%s: %i - COLUMN_%s: %i", COLUMN_WEED, GetPlayerWeed(playerid), COLUMN_CRACK, GetPlayerCrack(playerid));
				printf("COLUMN_%s: %i - COLUMN_%s: %i", COLUMN_ROPE, GetPlayerRope(playerid), COLUMN_PICKLOCK, GetPlayerPickLock(playerid));
				printf("COLUMN_%s: %i - COLUMN_%s: %i", COLUMN_SCISSORS, GetPlayerScissors(playerid), COLUMN_CONDOM, GetPlayerCondom(playerid));
				printf("COLUMN_%s: %i\n", COLUMN_WALLET, GetPlayerWallet(playerid));
			#endif
			MessageBoxF(playerid, TYPE_MSGBOX, "~g~Welcome back!", "You have successfully logged in your account, enjoy playing!");

			playerData[playerid][pLoggedIn] = true;

			CallLocalFunction("OnPlayerLogin", "i", playerid);
        }

        showRDIALOG:
        format(string, sizeof(string), "Welcome back %p!\nPlease insert your password to continue:", playerid);
        Dialog_ShowCallback(playerid, using inline dialogLogin, DIALOG_STYLE_PASSWORD, "User Account", string, "Login", "Cancel");
     
	}
	else
	{
		inline dialogRegister(pid, dialogid, response, listitem, string:inputtext[])
    	{
	        #pragma unused pid, dialogid, response, listitem, inputtext

        	if(!response)
		    {
		        Kick(playerid);
		        return 1;
		    }
	        if(!inputtext[0] || strlen(inputtext) < 4 || strlen(inputtext) > 50)
	        {
	        	MsgTag(playerid, TYPE_ERROR, "Your password must be between 4 - 50 characters.");
	            goto showLDIALOG;
	        	return 1;
	        }

	        yoursql_set_row(serverDB, TABLE_ACCOUNTS, ""COLUMN_NAME" = %s", name);
	        yoursql_set_row(serverDB, TABLE_ITEMS, ""COLUMN_NAME" = %s", name); 
	        yoursql_set_row(serverDB, TABLE_ACCESSORIES, ""COLUMN_NAME" = %s", name); 

	        rowid = yoursql_get_row(serverDB, TABLE_ACCOUNTS, ""COLUMN_NAME" = %s", name);

	        new 
	        	password[MAX_PASSWORD],
	        	salt[11];

			for(new i; i < 10; i++)
			{
				salt[i] = random(79) + 47;
			}
			salt[10] = 0;

			SHA256_PassHash(inputtext, salt, password, sizeof(password));

			yoursql_set_field(serverDB, ""TABLE_ACCOUNTS"/"COLUMN_PASS"", rowid, password);
			yoursql_set_field(serverDB, ""TABLE_ACCOUNTS"/"COLUMN_SALT"", rowid, salt);

			MessageBoxF(playerid, TYPE_MSGBOX, "~g~Welcome!", "You have successfully registered your account in the server.");
	      	
	      	SetPlayerJob(playerid, NO_JOB);
	        playerData[playerid][pLoggedIn] = true;

	        CallLocalFunction("OnPlayerRegister", "i", playerid);

	        #if defined ACCOUNT_DEBUG
				printf("Account Created. Account ID: %i - Account Name: %s", _:rowid, name);
			#endif
	    }
	    
	    showLDIALOG:
	    format(string, sizeof(string), "Welcome %p!\nYou are not recognized on our database, please insert a password to sing-in and continue:", playerid);
	    Dialog_ShowCallback(playerid, using inline dialogRegister, DIALOG_STYLE_PASSWORD, "User Account", string, "Register", "Cancel");
	}
	return 1;
}

SavePlayerData(playerid)
{
	if(!playerData[playerid][pLoggedIn])
		return 1;

	new 
		name[MAX_PLAYER_NAME], SQLRow:rowid;

	GetPlayerName(playerid, name, sizeof(name));

	rowid = yoursql_get_row(serverDB, TABLE_ACCOUNTS, ""COLUMN_NAME" = %s", name);
	yoursql_multiset_fields(serverDB, TABLE_ACCOUNTS, rowid, "iiiii", 
			COLUMN_SCORE,	GetPlayerScore(playerid),
			COLUMN_ADM, 	playerData[playerid][pAdmin], 
			COLUMN_CLASS, 	GetPlayerJob(playerid), 
			COLUMN_KILLS, 	playerData[playerid][pKills], 
			COLUMN_DEATHS, 	playerData[playerid][pDeaths]);
	
	#if defined ACCOUNT_DEBUG
		printf("\n[SAVING %s's DATA] - TABLE: %s - ACC ID: %i", name, TABLE_ACCOUNTS, _:rowid);
		printf("COLUMN_%s: %i", COLUMN_SCORE, GetPlayerScore(playerid));
		printf("COLUMN_%s: %i - COLUMN_%s: %i", COLUMN_ADM, playerData[playerid][pAdmin], COLUMN_CLASS, GetPlayerJob(playerid));
		printf("COLUMN_%s: %i - COLUMN_%s: %i\n", COLUMN_KILLS, playerData[playerid][pKills], COLUMN_DEATHS, playerData[playerid][pDeaths]);
	#endif

	rowid = yoursql_get_row(serverDB, TABLE_ACCESSORIES, ""COLUMN_NAME" = %s", name);

	yoursql_multiset_fields(serverDB, TABLE_ACCESSORIES, rowid, "iiiiiii", 
		COLUMN_TOTALRAPE, 			playerAccessories[playerid][totalRape], 
		COLUMN_TOTALBEENRAPED, 		playerAccessories[playerid][totalBeenRaped], 
		COLUMN_TOTALROB,		 	playerAccessories[playerid][totalRob], 
		COLUMN_TOTALBEENROBBED, 	playerAccessories[playerid][totalBeenRobbed], 
		COLUMN_TOTALSTOREROB, 		playerAccessories[playerid][totalStoreRobbed],
		COLUMN_TOTALARREST, 		playerAccessories[playerid][totalArrest],
		COLUMN_TOTALBEENARRESTED, 	playerAccessories[playerid][totalBeenArrested]);

	#if defined ACCOUNT_DEBUG	
		printf("\n[SAVING %s's DATA] - TABLE: %s - ACC ID: %i", name, TABLE_ACCESSORIES, _:rowid);
		printf("COLUMN_%s: %i - COLUMN_%s: %i", COLUMN_TOTALRAPE, playerAccessories[playerid][totalRape], COLUMN_TOTALBEENRAPED, playerAccessories[playerid][totalBeenRaped]);
		printf("COLUMN_%s: %i - COLUMN_%s: %i", COLUMN_TOTALROB, playerAccessories[playerid][totalRob], COLUMN_TOTALBEENROBBED, playerAccessories[playerid][totalBeenRobbed]);
		printf("COLUMN_%s: %i - COLUMN_%s: %i", COLUMN_TOTALSTOREROB, playerAccessories[playerid][totalStoreRobbed], COLUMN_TOTALARREST, playerAccessories[playerid][totalArrest]);
		printf("COLUMN_%s: %i\n", COLUMN_TOTALBEENARRESTED, playerAccessories[playerid][totalBeenArrested]);
	#endif

		
	rowid = yoursql_get_row(serverDB, TABLE_ITEMS, ""COLUMN_NAME" = %s", name);
	yoursql_multiset_fields(serverDB, TABLE_ITEMS, rowid, "iiiiiii", 
			COLUMN_WEED, 		GetPlayerWeed(playerid), 
			COLUMN_CRACK, 		GetPlayerCrack(playerid), 
			COLUMN_ROPE, 		GetPlayerRope(playerid), 
			COLUMN_PICKLOCK, 	GetPlayerPickLock(playerid), 
			COLUMN_SCISSORS, 	GetPlayerScissors(playerid),
			COLUMN_CONDOM,		GetPlayerCondom(playerid),
			COLUMN_WALLET, 		GetPlayerWallet(playerid));
	
	#if defined ACCOUNT_DEBUG
		printf("\n[SAVING %s's DATA] - TABLE: %s - ACC ID: %i", name, TABLE_ITEMS, _:rowid);
		printf("COLUMN_%s: %i - COLUMN_%s: %i", COLUMN_WEED, GetPlayerWeed(playerid), COLUMN_CRACK, GetPlayerCrack(playerid));
		printf("COLUMN_%s: %i - COLUMN_%s: %i", COLUMN_ROPE, GetPlayerRope(playerid), COLUMN_PICKLOCK, GetPlayerPickLock(playerid));
		printf("COLUMN_%s: %i - COLUMN_%s: %i", COLUMN_SCISSORS, GetPlayerScissors(playerid), COLUMN_CONDOM, GetPlayerCondom(playerid));
		printf("COLUMN_%s: %i\n", COLUMN_WALLET, GetPlayerWallet(playerid));
	#endif
	return 1;
}

