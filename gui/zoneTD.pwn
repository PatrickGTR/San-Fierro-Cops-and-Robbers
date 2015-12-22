#include <YSI\y_hooks>

static 
	PlayerText:playerZone;

hook OnPlayerConnect(playerid)
{
	playerZone = CreatePlayerTextDraw(playerid,55.000000, 330.000000, "New Textdraw");
	PlayerTextDrawBackgroundColor(playerid,playerZone, 85);
	PlayerTextDrawFont(playerid,playerZone, 1);
	PlayerTextDrawLetterSize(playerid,playerZone, 0.300000, 0.899999);
	PlayerTextDrawColor(playerid,playerZone, -1);
	PlayerTextDrawSetOutline(playerid,playerZone, 1);
	PlayerTextDrawSetProportional(playerid,playerZone, 1);
	PlayerTextDrawSetSelectable(playerid,playerZone, 0);
}

hook OnPlayerDisconnect(playerid, reason)
{
    PlayerTextDrawHide(playerid, playerZone);
    PlayerTextDrawDestroy(playerid, playerZone);
}

SetPlayerLocationTD(playerid, text[])
{
    PlayerTextDrawHide(playerid, playerZone);
    PlayerTextDrawSetString(playerid, playerZone, text);
    PlayerTextDrawShow(playerid, playerZone);
}