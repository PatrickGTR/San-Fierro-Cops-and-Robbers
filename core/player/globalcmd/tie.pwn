static 
    gPlayerTieEscapeDelay[MAX_PLAYERS],
    BitArray:gIsPlayerTied<MAX_PLAYERS>;

CMD:tie(playerid, params[])
{
    new 
        targetid,
        successrate = random(100);

    if(isnull(params))
        return MsgTag(playerid, TYPE_USAGE, "/tie <playerid>");

    targetid = strval(params);

    if(targetid == INVALID_PLAYER_ID)
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to tie is invalid.");

    if(targetid == playerid)
        return MsgTag(playerid, TYPE_ERROR, "You can not tie your own self.");

    if(Bit_Get(gIsPlayerTied, playerid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to tie is already tied");

    if(!IsPlayerSpawned(targetid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to tie is not spawned");

    if(!IsPlayerNearPlayer(playerid, targetid, 5.0))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to tie is not nearby.");

    if(IsPlayerInAnyVehicle(targetid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to tie is inside a vehicle");

    if(successrate <= 35)
    {
        MsgF(targetid, COLOR_LIGHTGREEN, "[TIE]: "C_GREY"%p (%i) "C_WHITE"attempted to tie you.", playerid, playerid);
        MsgF(playerid, COLOR_LIGHTGREEN, "[TIE]: "C_WHITE"You failed to tie "C_GREY"%p (%i)", targetid, targetid);
        return true;
    }

    MsgF(targetid, COLOR_LIGHTGREEN, "[TIE]: "C_WHITE"You have been tied by "C_GREY"%p (%i)", playerid, playerid);
    MsgF(playerid, COLOR_LIGHTGREEN, "[TIE]: "C_WHITE"You successfully tied "C_GREY"%p (%i)", targetid, targetid);

    TogglePlayerControllable(targetid, false);
    SetPlayerSpecialAction(targetid, SPECIAL_ACTION_CUFFED);
    Bit_Let(gIsPlayerTied, targetid);
    return true;
}

CMD:untie(playerid, params[])
{
    new 
        targetid; 

    if(isnull(params))
        return MsgTag(playerid, TYPE_USAGE, "/tie <playerid>");

    targetid = strval(params);

    if(targetid == INVALID_PLAYER_ID)
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to tie is invalid");

    if(targetid == playerid)
        return MsgTag(playerid, TYPE_ERROR, "You can not untie your own self.");

    if(!Bit_Get(gIsPlayerTied, playerid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to untie is not tied");

    if(!IsPlayerSpawned(targetid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to tie is not spawned");

    if(!IsPlayerNearPlayer(playerid, targetid, 5.0))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to tie is not nearby.");

    if(IsPlayerInAnyVehicle(targetid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to tie is inside a vehicle");

    MsgF(targetid, COLOR_LIGHTGREEN, "[TIE]: "C_WHITE"You have been untied by "C_GREY"%p (%i)", playerid, playerid);
    MsgF(playerid, COLOR_LIGHTGREEN, "[TIE]: "C_WHITE"You successfully untied "C_GREY"%p (%i)", targetid, targetid);

    TogglePlayerControllable(targetid, true);
    SetPlayerSpecialAction(targetid, SPECIAL_ACTION_NONE);
    Bit_Vet(gIsPlayerTied, targetid);
    return true;
}

CMD:breaktie(playerid, params[])
{
    new 
        successrate = random(100);

    if(gettime() - gPlayerTieEscapeDelay[playerid] < 60 * 3)
        return MsgTag(playerid, TYPE_ERROR, "You just escaped from tie recently, please try again later");

    if(playerItems[playerid][pScissors] < 1)
        return MsgTag(playerid, TYPE_ERROR, "You need a pair of scissors to break ropes.");

    if(successrate <= 35)   
        return MsgTag(playerid, TYPE_ERROR, "You have failed to escape from tie.");

    MsgF(playerid, COLOR_LIGHTGREEN, "[TIE]: "C_WHITE"You managed to cut the rope with a scissors, run forrest run!");

    TogglePlayerControllable(playerid, true);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    Bit_Vet(gIsPlayerTied, playerid);
    
    gPlayerTieEscapeDelay[playerid] = gettime();
    return true;
}
