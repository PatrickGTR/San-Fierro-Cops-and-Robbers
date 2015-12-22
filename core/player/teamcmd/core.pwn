#include "core/player/teamcmd/cuff.pwn"
#include "core/player/teamcmd/ticket.pwn"

CMD:arrest(playerid, params[])
{

    if(!IsPlayerLEO(playerid))
        return MsgTag(playerid, TYPE_ERROR, "You are not allowed to use this command. You not in Law Enforcement");

    if(isnull(params))
        return MsgTag(playerid, TYPE_USAGE, "/ar <playerid>");

    new targetid = strval(params);

    if(targetid == playerid)
       return MsgTag(playerid, TYPE_ERROR, "You are not allowed to arrest your own self.");

    if(!IsPlayerConnected(targetid))
       return MsgTag(playerid, TYPE_ERROR, "The player you are trying to arrest is not connected.");

    if(!IsPlayerSpawned(targetid))
       return MsgTag(playerid, TYPE_ERROR, "The player you are trying to arrest is not spawned.");

    if(GetPlayerSpecialAction(targetid) != SPECIAL_ACTION_CUFFED)
       return MsgTag(playerid, TYPE_ERROR, "The player you are trying to arrest is not cuffed.");

    if(!IsPlayerNearPlayer(playerid, targetid, 4.0))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to arrest is not near you.");

    if(IsPlayerInAnyVehicle(targetid))
        return MsgTag(playerid, TYPE_ERROR, "Its impossible to arrest someone whilst inside a vehicle.");

    if(GetPlayerWantedLevel(targetid) <= 5)
        return MsgTag(playerid, TYPE_ERROR, "Its impossible to arrest this person, he's wanted level is too low, /ticket him/her.");

    SetPlayerSpecialAction(targetid, SPECIAL_ACTION_NONE);

    new 
        jailtime = 0,
        ply_wantedlvl = GetPlayerWantedLevel(targetid);

    if(5 <= ply_wantedlvl <= 15)
        jailtime = 120;
    else 
        jailtime = ply_wantedlvl * 2;

    ++ playerAccessories[playerid][totalArrest];
    ++ playerAccessories[targetid][totalBeenArrested];

    MsgAllF(COLOR_YELLOW, "[JAIL SENTENCE]: "C_GREY"%p (%i) "C_WHITE"sent "C_GREY"%p (%i) "C_WHITE"to jail for "C_GREY"%i "C_WHITE"seconds.", playerid, playerid, targetid, targetid, jailtime);

    SendPlayerToJail(targetid, jailtime);
    return 1;
}

CMD:loc(playerid, params[])
{   
    if(!IsPlayerLEO(playerid))
        return MsgTag(playerid, TYPE_ERROR, "You are not allowed to use this command. You not in Law Enforcement");

    if(isnull(params))
        return MsgTag(playerid, TYPE_USAGE, "/loc <playerid>");

    new targetid = strval(params);

    if(targetid == playerid)
        return MsgTag(playerid, TYPE_ERROR, "You are not allowed to locate your own self.");

    if(!IsPlayerConnected( targetid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to locate is not connected.");

    if(!IsPlayerSpawned(targetid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to locate is not spawned.");

    if(GetPlayerInterior(targetid) > 1)
    {
        MsgF(playerid, COLOR_BLUE, "Location of "C_GREY"%p (%i) "C_BLUE"near "C_GREY"inside an interior", targetid, targetid);
    }
    else MsgF(playerid, COLOR_BLUE, "Location of "C_GREY"%p (%i) "C_BLUE"near "C_GREY"%s", targetid, targetid, GetPlayerLocation(playerid));
    return true;
}       

CMD:pullover(playerid, params[])
{
    if(!IsPlayerLEO(playerid))
        return MsgTag(playerid, TYPE_ERROR, "You are not allowed to use this command. You not in Law Enforcement");

    if(isnull(params))
        return MsgTag(playerid, TYPE_USAGE, "/pullover <playerid>");

    new targetid = strval(params);

    if(targetid == playerid)
        return MsgTag(playerid, TYPE_ERROR, "You are not allowed to pullover your own self.");

    if(!IsPlayerConnected(targetid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to pullover is not connected.");

    if(!IsPlayerSpawned(targetid))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to pullover is not spawned.");

    if(!IsPlayerNearPlayer(playerid, targetid, 4.0))
        return MsgTag(playerid, TYPE_ERROR, "The player you are trying to pullover is not near you.");

    MsgF(playerid, COLOR_BLUE, "[PULLOVER]: "C_WHITE"You have told %p (%i) to pull over on the side of the road.", targetid, targetid);
    MsgF(targetid, COLOR_BLUE, "[PULLOVER]: "C_WHITE"You have been told by %p (%i) to pull over on the side of the road.", playerid, playerid);
    return true;
}
