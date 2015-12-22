static
    BitArray:gPlayerCuffed<MAX_PLAYERS>,
    gPlayerCuffEscapeDelay[MAX_PLAYERS];

CMD:cuff(playerid, params[])
{
    if(!IsPlayerLEO(playerid))
        return MsgTag(playerid, TYPE_ERROR, "You are not allowed to use this command. You are not a cop/army/cia.");

    if(isnull(params))
        return MsgTag(playerid, TYPE_USAGE, "/cuff <playerid>");

    new targetid = strval(params); 

    if(targetid == playerid)
        return MsgTag(playerid, TYPE_ERROR, "You are not allowed to cuff your own self.");

    if(!IsPlayerConnected(targetid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to cuff is not connected.");

    if(!IsPlayerSpawned(targetid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to cuff is not spawned.");

    if(!IsPlayerNearPlayer(playerid, targetid, 4.0))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to cuff is not near you.");

    if(GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_CUFFED && Bit_Get(gPlayerCuffed, playerid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to cuff is already cuffed.");

    if(IsPlayerInAnyVehicle(targetid))
        return MsgTag(playerid, TYPE_ERROR, "Its impossible to cuff someone whilst inside a vehicle.");

    SetPlayerSpecialAction(targetid, SPECIAL_ACTION_CUFFED);
    SetPlayerAttachedObject(targetid, 8, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977, -81.700035, 0.891999, 1.000000, 1.168000);
    Bit_Let(gPlayerCuffed, targetid);

    MsgTag(playerid, TYPE_SERVER, "You successfully cuffed %C%p%C. Arrest him before he breaks the cuffs.", COLOR_WHITE, COLOR_GREY, targetid, COLOR_WHITE);
    MsgTag(targetid, TYPE_SERVER, "You have been cuffed by %C%p%C. Break the cuffs before he/she arrest you.", COLOR_WHITE, COLOR_GREY, playerid, COLOR_WHITE);
    return 1;
}

CMD:uncuff(playerid, params[])
{
    if(!IsPlayerLEO(playerid))
        return MsgTag(playerid, TYPE_ERROR, "You are not allowed to use this command. You are not a cop/army/cia.");

    if(isnull(params))
        return MsgTag(playerid, TYPE_USAGE, "/uncuff <playerid>");

    new targetid = strval(params); 

    if(targetid == playerid)
        return MsgTag(playerid, TYPE_ERROR, "You are not allowed to uncuff your own self.");

    if(!IsPlayerConnected(targetid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to uncuff is not connected.");

    if(!IsPlayerSpawned(targetid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to uncuff is not spawned.");

    if(!IsPlayerNearPlayer(playerid, targetid, 4.0))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to uncuff is not near you.");

    if(GetPlayerSpecialAction(targetid) != SPECIAL_ACTION_CUFFED && !Bit_Get(gPlayerCuffed, playerid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to uncuff does not have cuffs behind his back.");

    if(IsPlayerInAnyVehicle(targetid))
        return MsgTag(playerid, TYPE_ERROR, "Its impossible to uncuff someone whilst inside a vehicle.");

    SetPlayerSpecialAction(targetid, SPECIAL_ACTION_NONE);
    RemovePlayerAttachedObject(playerid, 8);
    Bit_Vet(gPlayerCuffed, targetid);
    
    MsgTag(playerid, TYPE_SERVER, "You successfully uncuffed "C_GREY"%p"C_WHITE".", targetid);
    MsgTag(targetid, TYPE_SERVER, "You have been uncuffed by "C_GREY"%p. "C_WHITE"You are free to go!", playerid);
    return 1;
}  

CMD:breakcuff(playerid, params[])
{
    if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_CUFFED && !Bit_Get(gPlayerCuffed, playerid))
        return MsgTag(playerid, TYPE_ERROR, "You are not cuffed, how is that possible?");

    if(gettime() - gPlayerCuffEscapeDelay[playerid] < 60)
        return MsgTag(playerid, TYPE_ERROR, "You just used this command recently, try again later.");

    if(playerItems[playerid][pPickLock] < 1)
        return MsgTag(playerid, TYPE_ERROR, "You need a picklock to escape from cuffs.");


    new successrate = random(100);
    if(successrate <= 30)
    {
        gPlayerCuffEscapeDelay[playerid] = gettime();
        MsgTag(playerid, TYPE_SERVER, "You failed to escape from cuffs");
        return 1;
    }

    gPlayerCuffEscapeDelay[playerid] = gettime();
    MsgTag(playerid, TYPE_SERVER, "You have managed to picklock the cuffs! Run away from the police!");

    ++ playerAccessories[playerid][totalCuffEscape]; 

    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    RemovePlayerAttachedObject(playerid, 8);
    Bit_Vet(gPlayerCuffed, playerid);
    return true;
}