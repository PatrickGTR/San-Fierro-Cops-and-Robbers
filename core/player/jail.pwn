static const Float:jailCoordinate[][] = 
{
//  X          Y         Z         Angle
    {215.6494, 110.1481, 999.0156, 359.7295},
    {219.5778, 110.1481, 999.0156, 359.7295},
    {223.5972, 110.1481, 999.0156, 359.7295},
    {227.4928, 110.1481, 999.0156, 359.7295}
};

static 
    ply_TotalTime[MAX_PLAYERS],
    Timer:ply_JailTime[MAX_PLAYERS];

SendPlayerToJail(playerid, jailtime)
{
    new 
        rand = random(sizeof(jailCoordinate));

    ResetPlayerWeapons(playerid);

    SetPlayerVirtualWorld(playerid, 10);
    SetPlayerInterior(playerid, 10);

    SetPlayerPos(playerid, jailCoordinate[rand][0], jailCoordinate[rand][1], jailCoordinate[rand][2]);
    SetPlayerFacingAngle(playerid, jailCoordinate[rand][3]);
    SetCameraBehindPlayer(playerid);

    ply_TotalTime[playerid] =  jailtime;
    ply_JailTime[playerid] = repeat UpdateJailTime(playerid);
    return 1;
}

timer UpdateJailTime[1000](playerid)
{
    if(ply_TotalTime[playerid] > 0)
    {
        -- ply_TotalTime[playerid];
        printf("jailtime: %i", ply_TotalTime[playerid]);
    }
    else
    {
        MsgTag(playerid, TYPE_SERVER, "You have been released from San Fierro jail, you are free!");
        MsgAllF(COLOR_YELLOW, "[JAIL SENTENCE]: "C_GREY"%p (%i) "C_WHITE"has been released from San Fierro jail he/she served his time.", playerid, playerid);

        SetPlayerPos(playerid, 217.8541, 117.9176, 999.0156);
        SetPlayerFacingAngle(playerid, 3.7652);
        SetCameraBehindPlayer(playerid);
        stop ply_JailTime[playerid];
    }
}