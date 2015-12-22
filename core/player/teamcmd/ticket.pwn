static
    BitArray:gPlayerHasTicket<MAX_PLAYERS>;
    
CMD:ticket(playerid, params[])
{
    if(!IsPlayerLEO(playerid))
        return MsgTag(playerid, TYPE_ERROR, "You are not allowed to use this command. You are not a cop/army/cia.");

    new 
        targetid = GetClosestPlayerFromPlayer(playerid, 5.0);

    if(targetid == INVALID_PLAYER_ID || GetPlayerWantedLevel(targetid) == 0)
        return MsgTag(playerid, TYPE_ERROR, "No ticketable players nearby.");

    if(GetPlayerWantedLevel(targetid) >= 5)
        return MsgTag(playerid, TYPE_ERROR, "This player wanted level is too high, arrest him!");

    MsgF(targetid, COLOR_BLUE, "[TICKET]: "C_GREY"%p (%i) "C_WHITE"issued you a ticket, use "C_GREY"/payticket "C_WHITE"to pay your ticket.", playerid, playerid);
    MsgF(playerid, COLOR_BLUE, "[TICKET]: "C_WHITE"You have issued "C_GREY"%p (%i) "C_WHITE"a ticket, hopefully he pays.", targetid, targetid);
    Bit_Let(gPlayerHasTicket, targetid);
    return true;
}

CMD:payticket(playerid, params[])
{
    if(!Bit_Get(gPlayerHasTicket, playerid))
        return MsgTag(playerid, TYPE_ERROR, "No one offered you a ticket.");

    Msg(playerid, COLOR_BLUE, "[TICKET]: "C_WHITE"You have paid "C_GREEN"$5,000 for your ticket, you are now clean.");
    SetPlayerWantedLevel(playerid, 0);
    GivePlayerMoney(playerid, -5000);
    Bit_Vet(gPlayerHasTicket, playerid);
    return true;
}