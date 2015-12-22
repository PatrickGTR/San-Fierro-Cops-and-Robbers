/*
        MessageBox script
    
        edited version.

        Thanks to [KHK]Khalid - Taken from Bulletproof Gamemode.
*/

#include <YSI\y_hooks>

// Message box types
#define MAX_MSGBOX_TYPES        (2)

#define TYPE_MSGBOX             (0)
#define TYPE_INFORMATION        (1)

enum MsgBoxStruct
{
    PlayerText:caption_TD[MAX_MSGBOX_TYPES],
    PlayerText:info_TD[MAX_MSGBOX_TYPES],
    MsgBoxtimer[MAX_MSGBOX_TYPES],
    bool:MsgBoxClick[MAX_MSGBOX_TYPES]

}

static 
    MsgBoxData[MAX_PLAYERS][MsgBoxStruct];

hook OnPlayerConnect(playerid)
{
    for(new i = 0; i < MAX_MSGBOX_TYPES; i ++)
        MsgBoxData[playerid][MsgBoxtimer][i] = -1;
    
    // Middle textdraws
    MsgBoxData[playerid][caption_TD][TYPE_MSGBOX] = CreatePlayerTextDraw(playerid, 21.000000, 204.000000, "~y~~h~caption");
    PlayerTextDrawBackgroundColor(playerid, MsgBoxData[playerid][caption_TD][TYPE_MSGBOX], TD_OUTLINE_COLOUR);
    PlayerTextDrawFont(playerid, MsgBoxData[playerid][caption_TD][TYPE_MSGBOX], 3);
    PlayerTextDrawLetterSize(playerid, MsgBoxData[playerid][caption_TD][TYPE_MSGBOX], 0.449999, 1.500000);
    PlayerTextDrawColor(playerid, MsgBoxData[playerid][caption_TD][TYPE_MSGBOX], -1);
    PlayerTextDrawSetOutline(playerid, MsgBoxData[playerid][caption_TD][TYPE_MSGBOX], 0);
    PlayerTextDrawSetProportional(playerid, MsgBoxData[playerid][caption_TD][TYPE_MSGBOX], 1);
    PlayerTextDrawSetShadow(playerid, MsgBoxData[playerid][caption_TD][TYPE_MSGBOX], 1);

    MsgBoxData[playerid][info_TD][TYPE_MSGBOX] = CreatePlayerTextDraw(playerid, 22.000000, 220.000000, "This is a text. This is another one. The whole paragraph is supposed to be quite long. So, yeah!");
    PlayerTextDrawBackgroundColor(playerid, MsgBoxData[playerid][info_TD][TYPE_MSGBOX], TD_OUTLINE_COLOUR);
    PlayerTextDrawFont(playerid, MsgBoxData[playerid][info_TD][TYPE_MSGBOX], 1);
    PlayerTextDrawLetterSize(playerid, MsgBoxData[playerid][info_TD][TYPE_MSGBOX], 0.159999, 1.100000);
    PlayerTextDrawColor(playerid, MsgBoxData[playerid][info_TD][TYPE_MSGBOX], -1);
    PlayerTextDrawSetOutline(playerid, MsgBoxData[playerid][info_TD][TYPE_MSGBOX], 0);
    PlayerTextDrawSetProportional(playerid, MsgBoxData[playerid][info_TD][TYPE_MSGBOX], 1);
    PlayerTextDrawSetShadow(playerid, MsgBoxData[playerid][info_TD][TYPE_MSGBOX], 1);
    PlayerTextDrawUseBox(playerid, MsgBoxData[playerid][info_TD][TYPE_MSGBOX], 1);
    PlayerTextDrawBoxColor(playerid, MsgBoxData[playerid][info_TD][TYPE_MSGBOX], 68);
    PlayerTextDrawTextSize(playerid, MsgBoxData[playerid][info_TD][TYPE_MSGBOX], 179.000000, 0.000000);
    
    // Bottom textdraws
    MsgBoxData[playerid][caption_TD][TYPE_INFORMATION] = CreatePlayerTextDraw(playerid, 162.000000, 363.000000, "~y~~h~caption");
    PlayerTextDrawBackgroundColor(playerid, MsgBoxData[playerid][caption_TD][TYPE_INFORMATION], TD_OUTLINE_COLOUR);
    PlayerTextDrawFont(playerid, MsgBoxData[playerid][caption_TD][TYPE_INFORMATION], 3);
    PlayerTextDrawLetterSize(playerid, MsgBoxData[playerid][caption_TD][TYPE_INFORMATION], 0.519999, 1.899999);
    PlayerTextDrawColor(playerid, MsgBoxData[playerid][caption_TD][TYPE_INFORMATION], -1);
    PlayerTextDrawSetOutline(playerid, MsgBoxData[playerid][caption_TD][TYPE_INFORMATION], 0);
    PlayerTextDrawSetProportional(playerid, MsgBoxData[playerid][caption_TD][TYPE_INFORMATION], 1);
    PlayerTextDrawSetShadow(playerid, MsgBoxData[playerid][caption_TD][TYPE_INFORMATION], 1);

    MsgBoxData[playerid][info_TD][TYPE_INFORMATION] = CreatePlayerTextDraw(playerid, 161.000000, 393.000000, "This is the message. We tell the user what's going on here!");
    PlayerTextDrawBackgroundColor(playerid, MsgBoxData[playerid][info_TD][TYPE_INFORMATION], TD_OUTLINE_COLOUR);
    PlayerTextDrawFont(playerid, MsgBoxData[playerid][info_TD][TYPE_INFORMATION], 1);
    PlayerTextDrawLetterSize(playerid, MsgBoxData[playerid][info_TD][TYPE_INFORMATION], 0.199999, 1.199999);
    PlayerTextDrawColor(playerid, MsgBoxData[playerid][info_TD][TYPE_INFORMATION], -1);
    PlayerTextDrawSetOutline(playerid, MsgBoxData[playerid][info_TD][TYPE_INFORMATION], 0);
    PlayerTextDrawSetProportional(playerid, MsgBoxData[playerid][info_TD][TYPE_INFORMATION], 1);
    PlayerTextDrawSetShadow(playerid, MsgBoxData[playerid][info_TD][TYPE_INFORMATION], 1);
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PRESSED(KEY_FIRE))
    {
        if(MsgBoxData[playerid][MsgBoxClick][TYPE_MSGBOX])
            HideMessageBox(playerid, TYPE_MSGBOX);
    }
}

// -1 = all types
forward HideMessageBox(playerid, type);
public HideMessageBox(playerid, type)
{
    switch(type)
    {
        case -1: // all
        {
            for(new i = 0; i < MAX_MSGBOX_TYPES; i ++)
            {
                if(MsgBoxData[playerid][MsgBoxtimer][i] != -1)
                {
                    KillTimer(MsgBoxData[playerid][MsgBoxtimer][i]);
                    MsgBoxData[playerid][MsgBoxtimer][i] = -1;
                }
                PlayerTextDrawHide(playerid, MsgBoxData[playerid][info_TD][i]);
                PlayerTextDrawHide(playerid, MsgBoxData[playerid][caption_TD][i]);
            }
        }
        default:
        {
            PlayerTextDrawHide(playerid, MsgBoxData[playerid][info_TD][type]);
            PlayerTextDrawHide(playerid, MsgBoxData[playerid][caption_TD][type]);
            KillTimer(MsgBoxData[playerid][MsgBoxtimer][type]);
            MsgBoxData[playerid][MsgBoxtimer][type] = -1;
        }
    }
    return 1;
}

MessageBox(playerid, type, caption[], info[], interval = 6000)
{
    if(playerid == INVALID_PLAYER_ID)
        return 0;

    if(type < 0 || type == MAX_MSGBOX_TYPES)
        return 0;
    
    if(strlen(caption) < 1)
        return 0;

    if(strlen(info) < 1)
        return 0;
    
    switch(type)
    {
        case TYPE_MSGBOX:
        {
            PlayerTextDrawSetString(playerid, MsgBoxData[playerid][caption_TD][type], caption);
            PlayerTextDrawSetString(playerid, MsgBoxData[playerid][info_TD][type], info);
            PlayerTextDrawShow(playerid, MsgBoxData[playerid][caption_TD][type]);
            PlayerTextDrawShow(playerid, MsgBoxData[playerid][info_TD][type]);
        }
        case TYPE_INFORMATION:
        {
            PlayerTextDrawSetString(playerid, MsgBoxData[playerid][caption_TD][type], caption);
            PlayerTextDrawSetString(playerid, MsgBoxData[playerid][info_TD][type], info);
            PlayerTextDrawShow(playerid, MsgBoxData[playerid][caption_TD][type]);
            PlayerTextDrawShow(playerid, MsgBoxData[playerid][info_TD][type]);
        }
        default:
            return 0;
    }

    if(interval != -1)
    {
        MsgBoxData[playerid][MsgBoxtimer][type] = SetTimerEx("HideMessageBox", interval, false, "ii", playerid, type);
    }
    else
    {
        MsgBoxData[playerid][MsgBoxClick][type] = true;
        KillTimer(MsgBoxData[playerid][MsgBoxtimer][type]);
    }
    return 1;
}

MessageBoxF(playerid, type, caption[], info[], interval = 6000, va_args<>)
{
    new string[256];
    va_formatex(string, sizeof(string), info, va_start<5>);
    return MessageBox(playerid, type, caption, string, interval);
}