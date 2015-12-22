static 
    gPlayerRobbedRecently[MAX_PLAYERS];

#include "core/player/globalcmd/message.pwn"
#include "core/player/globalcmd/rules.pwn"
#include "core/player/globalcmd/tie.pwn"

CMD:rob(playerid, params[])
{
    new 
        targetid = GetClosestPlayerFromPlayer(playerid, 5.0);

    if(!IsPlayerConnected(targetid) || !IsPlayerSpawned(targetid))
        return MsgTag(playerid, TYPE_ERROR, "There are no players nearby to rob.");   

    if(gettime() - gPlayerRobbedRecently[playerid] < 30)
        return MsgTag(playerid, TYPE_ERROR, "You just robbed someone recently, please try again later");

    if(playerItems[targetid][pWallet] > 0)
    {
        MsgF(playerid, COLOR_ORANGE, "[ROB]: "C_WHITE"You failed to rob "C_GREY"%p (%i) "C_WHITE"because he had wallet, run away!", targetid, targetid);
        MsgF(targetid, COLOR_ORANGE, "[ROB]: "C_GREY"%p (%i) "C_WHITE"attempted to rob you but failed, chase him! - Wallets Left: %i", playerid, playerid, playerItems[playerid][pWallet]);
        return 1;
    }

    new
        successrate = random(100);

    if(successrate <= 30)
    {
        MsgF(playerid, COLOR_ORANGE, "[ROB]: "C_WHITE"You failed to rob "C_GREY"%p (%i) "C_WHITE"run away!", targetid, targetid);
        MsgF(targetid, COLOR_ORANGE, "[ROB]: "C_GREY"%p (%i) "C_WHITE"attempted to rob you but failed, chase him!", playerid, playerid);
        return 1;
    }

    new 
        robbedcash = random(8500)+500;

    MsgF(playerid, COLOR_ORANGE, "[ROB]: "C_WHITE"You managed to rob "C_GREY"%p (%i) "C_WHITE"and found "C_GREEN"%m "C_WHITE"in his wallet.", targetid, targetid, robbedcash);
    MsgF(targetid, COLOR_ORANGE, "[ROB]: "C_WHITE"You have been robbed by "C_GREY"%p (%i) "C_WHITE"and found "C_GREEN"%m "C_WHITE"on your wallet.", playerid, playerid, robbedcash);
    
    ++ playerAccessories[playerid][totalRob]; 
    ++ playerAccessories[targetid][totalBeenRobbed]; 

    GivePlayerMoney(targetid, -robbedcash);
    GivePlayerMoney(playerid, robbedcash);

    gPlayerRobbedRecently[playerid] = gettime();
    return true;
}
