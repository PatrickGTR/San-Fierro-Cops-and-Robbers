public OnPlayerRobbery(playerid, actorid, robbedmoney, type)
{
	switch(type)
	{
		case TYPE_SUCCESS:
		{
			Msg(playerid, COLOR_ORANGE, "<ROBBERY SUCCESS>");
			new string[32];
			format(string, sizeof(string), "~w~You stole~n~~g~$%i", robbedmoney);
			GameTextForPlayer(playerid, string, 8000, 1);	

			++ playerAccessories[playerid][totalStoreRobbed];
			GivePlayerMoney(playerid, robbedmoney);
			MsgAllF(COLOR_ORANGE, "<ROBBERY> %p robbed %m from a shop in %s.", playerid, robbedmoney, GetPlayerLocation(playerid));
		}
		case TYPE_FAILED:
		{
			Msg(playerid, COLOR_ORANGE, "<ROBBERY FAILED> - Cashier refused to give money");
			GameTextForPlayer(playerid, "~r~Robbery Failed", 8000, 1);
			MsgAllF(COLOR_ORANGE, "<ROBBERY> %p tried to rob a shop in %s but the cashier refused to give the money.", playerid, GetPlayerLocation(playerid));
		}
		case TYPE_UNFINISHED:
		{
			Msg(playerid, COLOR_ORANGE, "<ROBBERY FAILED> - You left the cashiers area.");
			GameTextForPlayer(playerid, "~r~Robbery Failed", 8000, 1);
			MsgAllF(COLOR_ORANGE, "<ROBBERY> %p tried to rob a shop in %s but he went to far for the cashier to call 911", playerid, GetPlayerLocation(playerid));
		}
	}
	SetPlayerWantedLevel(playerid, GetPlayerWantedLevel(playerid) + 2);
	return 1;
}