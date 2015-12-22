static const Float:SFSpawn[][] = 
{
//      X           Y         Z        Rot - SF Spawn
    {   -1935.0742, 678.1586, 46.5625, 356.4240     },
    {   -1922.5177, 680.0504, 46.5625, 2.6907       },
    {   -1934.6843, 264.8631, 41.0469, 276.9846     },
    {   -2022.3842, 155.8002, 28.8359, 266.6432     },
    {   -2314.1555, -169.0953, 35.3203, 178.2457    },
    {   -2126.3633, -383.9755, 35.3359, 2.5950      },
    {   -2720.4807, -317.9581, 7.8438, 41.5845      },
    {   -2521.2214, -621.2564, 132.7300, 1.2376     },
    {   -1928.7382, -790.2328, 32.1506, 273.2949    },
    {   -1953.3707, 1339.3734, 7.1875, 174.4267     }
 };

static playerLastSpawnID[MAX_PLAYERS];

public OnPlayerConnect(playerid)
{
    MsgAllF(COLOR_GREY, "%p %Cjoined the server.", playerid, COLOR_WHITE);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    switch(reason)
    {
        case 0:
        {
            MsgAllF(COLOR_GREY, "%p %Clost connection.", playerid, COLOR_WHITE);
        }
        case 1:
        {
            MsgAllF(COLOR_GREY, "%p %Cleft the server.", playerid, COLOR_WHITE);
            
        }
        case 2:
        {
            MsgAllF(COLOR_GREY, "%p %Cgot kicked from the server.", playerid, COLOR_WHITE);
        }
    }
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    SetPlayerPos(playerid, 110.401374, 1040.057495, 13.609375);
    SetPlayerFacingAngle(playerid, 359.325073);
    SetPlayerCameraLookAt(playerid, 110.401374, 1040.057495, 13.609375);
    SetPlayerCameraPos(playerid, 110.401374 + (5 * floatsin(-359.325073, degrees)), 1040.057495 + (5 * floatcos(-359.325073, degrees)), 13.609375);

    switch(classid)
    {
        case 0 .. 22: 
        {
            ShowClassTextdraw(playerid, COLOR_WHITE, "Civilian", "Rob stores and kill players to earn XP and show players you run the streets.");
            SetPlayerColor(playerid, COLOR_WHITE);
            SetPlayerTeam(playerid, TEAM_CIVILIAN);
        }
        case 23 .. 28: 
        {
            ShowClassTextdraw(playerid, COLOR_BLUE, "Police Officer", "Hunt down and arrest criminals for cash and XP~n~- Bring criminals to justice");
            SetPlayerColor(playerid, COLOR_BLUE);
            SetPlayerTeam(playerid, TEAM_POLICE);
        }
        case 29 .. 31: 
        {           
            ShowClassTextdraw(playerid, COLOR_PURPLE, "San Fierro Army", "- Access powerful weaponry and machinery to kill criminals~n~- Hunt down and arrest criminals for cash and XP");
            SetPlayerColor(playerid, COLOR_PURPLE);
            SetPlayerTeam(playerid, TEAM_ARMY);
        }
    }
    return 1;
}

public OnPlayerSpawn(playerid)
{
    switch(GetPlayerTeam(playerid))
    {
        case TEAM_POLICE:
        {
            SetPlayerPos(playerid, -1606.4692, 674.9128, -5.2422);
            SetPlayerFacingAngle(playerid, 1.5953);
            SetCameraBehindPlayer(playerid);
        }
        case TEAM_ARMY:
        {
            SetPlayerPos(playerid, -1347.8856, 499.8250, 18.2344);
            SetPlayerFacingAngle(playerid, 358.7014);
            SetCameraBehindPlayer(playerid);
        }
        case TEAM_CIVILIAN:
        {
            fnewSpawn:
            new randomiseSpawn = random(sizeof(SFSpawn));

            if(playerLastSpawnID[playerid] == randomiseSpawn)
            {
                goto fnewSpawn;
                return 1;
            }

            SetPlayerPos(playerid, SFSpawn[randomiseSpawn][0], SFSpawn[randomiseSpawn][1], SFSpawn[randomiseSpawn][2]);
            SetPlayerFacingAngle(playerid, SFSpawn[randomiseSpawn][3]);
            SetCameraBehindPlayer(playerid);

            playerLastSpawnID[playerid] = randomiseSpawn;

            ShowPlayerDialogJob(playerid);
        }
    }
    playerData[playerid][pSpawned] = true;
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    SendDeathMessage(killerid, playerid, reason); 
 

    if(killerid != INVALID_PLAYER_ID)
    {
        playerData[playerid][pKills] ++;
    }
    playerData[playerid][pDeaths] ++;

    playerData[playerid][pSpawned] = false;
    return 1;
}

ShowPlayerDialogJob(playerid)
{
    if(GetPlayerJob(playerid) != NO_JOB)
        return 1;

    inline dialogShowJob(pid, dialogid, response, listitem, string:inputtext[])
    {
        #pragma unused pid, dialogid, response, listitem, inputtext
        if(!response)
        {
            goto showJobDialogAgain;
            return 1;
        }

        switch(listitem)
        {
            case DRUG_DEALER: 
            {
                Msg(playerid, -1, "Drug Dealer");
                MessageBox(playerid, TYPE_INFORMATION, "Drug Dealer", "Your objective is to create drugs and sell them to earn profit!a", 5000);
                SetPlayerJob(playerid, DRUG_DEALER);
            }
            case WEAPON_DEALER:
            {
                Msg(playerid, -1, "Weapon Dealer");
                MessageBox(playerid, TYPE_INFORMATION, "Weapon Dealer", "Your objective is to sell any kind of weapons and sell them to earn profit!", 5000);
                SetPlayerJob(playerid, WEAPON_DEALER);
            }
            case HITMAN:
            {
                Msg(playerid, -1, "Hitman");
                MessageBox(playerid, TYPE_INFORMATION, "Hitman", "Your objective is to kill players with contract and earn a big amount of money!", 5000);
                SetPlayerJob(playerid, HITMAN);
            }
        }
    }
    showJobDialogAgain:
    Dialog_ShowCallback(playerid, using inline dialogShowJob, DIALOG_STYLE_TABLIST_HEADERS, "User Account", "Job\tObjective\n\
                                                                                                    DRUG DEALER\tMake drugs and make profits by selling\n\
                                                                                                    WEAPON DEALER\tSell weapons to players\n\
                                                                                                    HITMAN\tKill players with a hit\n\
                                                                                                        " , "Register", "Cancel");
    return 1;
}

IsPlayerLEO(playerid) 
{   
    switch(GetPlayerTeam(playerid))
    {
        case TEAM_ARMY: return 1;
        case TEAM_POLICE: return 1;
    }
    return 0;
}
