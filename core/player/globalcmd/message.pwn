static
    BitArray:ply_PMBlocked<MAX_PLAYERS>;

CMD:pm(playerid, params[])
{
    new 
        targetid, msg[128];
    if(sscanf(params, "is[128]", targetid, msg))
        return MsgTag(playerid, TYPE_USAGE, "/pm <playerid> <message>");

    if(!IsPlayerConnected(targetid))
    {
        MsgTag(playerid, TYPE_ERROR, "The player you are trying to PM is invalid");
        return 1;
    }

    if(targetid == playerid)
    {
        MsgTag(playerid, TYPE_ERROR, "You can not PM your own self.");
        return 1;
    }

    if(Bit_Get(ply_PMBlocked, playerid))
    {
        MsgTag(playerid, TYPE_ERROR, "This player has his PM blocked.");
        return 1;
    }

    MsgF(playerid, COLOR_YELLOW, "PM TO %C%p (%i): %C%s", COLOR_GREY, targetid, targetid, COLOR_WHITE, msg);
    MsgF(targetid, COLOR_YELLOW, "PM FROM %C%p (%i): %C%s", COLOR_GREY, playerid, playerid, COLOR_WHITE, msg);
    PlayerPlaySound(targetid, 17802, 0.0, 0.0, 0.0);
    GameTextForPlayer(targetid, "~n~~n~~n~~y~Message Recieved", 1500, 5);
    return 1;
}

CMD:blockpm(playerid, params[])
{   
    MsgTag(playerid, TYPE_SERVER, "You have blocked your private messages.");
    Bit_Let(ply_PMBlocked, playerid);
    return 1;
}

CMD:unblockpm(playerid, params[])
{   
    MsgTag(playerid, TYPE_SERVER, "You have unblocked your private messages.");
    Bit_Vet (ply_PMBlocked, playerid);
    return 1;
}