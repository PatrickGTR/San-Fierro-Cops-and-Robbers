#include <YSI\y_hooks>

#define TABLE_BANS 			"bans"
//COLUMN_NAME - for player name. found in accounts.pwn
#define COLUMN_BANNER		"bannedby"
#define COLUMN_REASON		"reason"
#define COLUMN_BANDATE		"bandate"
#define COLUMN_UNBANDATE	"unbandate"
#define COLUMN_GCPI			"gcpi"
#define COLUMN_IP 			"ipadress"

#define MAX_BAN_REASON		(50)

hook OnGameModeInit()
{
	yoursql_verify_table(serverDB, TABLE_BANS);
	yoursql_verify_column(serverDB, ""TABLE_BANS"/"COLUMN_NAME"", 		SQL_STRING);
	yoursql_verify_column(serverDB, ""TABLE_BANS"/"COLUMN_BANNER"", 	SQL_STRING);
	yoursql_verify_column(serverDB, ""TABLE_BANS"/"COLUMN_REASON"", 	SQL_STRING);
	yoursql_verify_column(serverDB, ""TABLE_BANS"/"COLUMN_BANDATE"", 	SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_BANS"/"COLUMN_UNBANDATE"", 	SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_BANS"/"COLUMN_GCPI"", 		SQL_STRING);
	yoursql_verify_column(serverDB, ""TABLE_BANS"/"COLUMN_IP"", 		SQL_STRING);
}

hook OnPlayerConnect(playerid)
{
	BanCheck(playerid);
}

AddPlayerBan(playerid, byid, reason[MAX_BAN_REASON], banduration)
{
	new 
		SQLRow:rowid,
		IP[16+1],
		ply_name[MAX_PLAYER_NAME],
		bannername[MAX_PLAYER_NAME], 
		ply_gpci[60];

	GetPlayerIp(playerid, IP, sizeof(IP));
	gpci(playerid, ply_gpci, sizeof(ply_gpci)); 

	if(byid == INVALID_PLAYER_ID)
		bannername = "SERVER";
	else 
		GetPlayerName(byid, bannername, sizeof(bannername));


	GetPlayerName(playerid, ply_name, sizeof(ply_name));

	yoursql_set_row(serverDB, TABLE_BANS, ""COLUMN_NAME" = %s", ply_name); 
	rowid = yoursql_get_row(serverDB, TABLE_BANS, ""COLUMN_NAME" = '%q'", ply_name);

	yoursql_multiset_fields(serverDB, TABLE_BANS, rowid, "sssiissis", 
		COLUMN_NAME, ply_name, 
		COLUMN_BANNER, bannername, 
		COLUMN_REASON, reason, 
		COLUMN_BANDATE, gettime(),  
		COLUMN_UNBANDATE,  gettime() + banduration,  
		COLUMN_GCPI, ply_gpci, 
		COLUMN_IP, IP);
	Kick(playerid);
	return 1;
}

RemovePlayerBan(username[], playerid = INVALID_PLAYER_ID)
{
	new SQLRow:rowid = yoursql_get_row(serverDB, TABLE_BANS, ""COLUMN_NAME" = '%q'", username);

	if(rowid != SQL_INVALID_ROW)
	{
		yoursql_delete_row(serverDB, TABLE_BANS, rowid);
		if(playerid != INVALID_PLAYER_ID)
			return MsgAdminF(3, "%p unbanned %s", playerid, username);
	}
	else 
	{
		if(playerid != INVALID_PLAYER_ID)
			return MsgTag(playerid, TYPE_ERROR, "The person you're trying to unban (%s) is not banned", username);
	}
	return 1;
}

BanCheck(playerid)
{
	new
		retrieveName[MAX_PLAYER_NAME],
		retrieveBannedBy[MAX_PLAYER_NAME],
		retrieveReason[MAX_BAN_REASON],
		retrieveBanDate,
		retrieveDuration,
		retrieveGCPI[60],
		retrieveIP[16 + 1],
		DBResult:result;

	GetPlayerName(playerid, retrieveName, sizeof(retrieveName));
	GetPlayerIp(playerid, retrieveIP, sizeof(retrieveIP));
	gpci(playerid, retrieveGCPI, sizeof(retrieveGCPI));

	result = yoursql_query(serverDB, false, "SELECT "COLUMN_NAME", "COLUMN_BANNER", "COLUMN_REASON", "COLUMN_BANDATE", "COLUMN_UNBANDATE", "COLUMN_GCPI", "COLUMN_IP" \
		FROM "TABLE_BANS" WHERE "COLUMN_NAME" = '%q' OR "COLUMN_GCPI" = '%q' OR "COLUMN_IP" = '%q' LIMIT 1", 
		retrieveName, retrieveGCPI, retrieveIP);

	if(db_num_rows(result))
	{
		retrieveName[0] = EOS; //Just to make sure retrieveName is empty before we use it again.

		db_get_field_assoc(result, COLUMN_NAME, retrieveName, sizeof(retrieveName));
		db_get_field_assoc(result, COLUMN_BANNER, retrieveBannedBy, sizeof(retrieveBannedBy));
		db_get_field_assoc(result, COLUMN_REASON, retrieveReason, sizeof(retrieveReason));
		retrieveBanDate = db_get_field_assoc_int(result, COLUMN_BANDATE);
		retrieveDuration = db_get_field_assoc_int(result, COLUMN_UNBANDATE);

		if(gettime() - retrieveDuration > (retrieveDuration - retrieveBanDate))
		{
			MsgTag(playerid, TYPE_SERVER, "Your ban expired on %C%s %C\nWelcome back %p!", COLOR_GREY, TimestampToDateTime(retrieveDuration), COLOR_WHITE, playerid);
			RemovePlayerBan(retrieveName, INVALID_PLAYER_ID);
		}
		else
		{
			format(globalString, sizeof(globalString), "\
				%CUsername: %C%s\n\
				%CBanned IP: %C%s\n\
				%CAdmin banned you: %C%s\n\
				%CReason of Ban: %C%s\n\
				%CDate of Ban: %C%s\n\
				%CDate of Unban: %C%s", COLOR_GREY, COLOR_WHITE, retrieveName, COLOR_GREY, COLOR_WHITE, retrieveIP, COLOR_GREY, COLOR_WHITE, retrieveBannedBy,
				COLOR_GREY, COLOR_WHITE, retrieveReason, COLOR_GREY, COLOR_WHITE, TimestampToDateTime(retrieveBanDate), COLOR_GREY, COLOR_WHITE, TimestampToDateTime(retrieveDuration));
			Dialog_Show(playerid, DIALOG_STYLE_MSGBOX, "Ban Information", globalString, "Close", "");
			globalString[0] = EOS;
			Kick(playerid);
		}
	}
	return 1;
}
