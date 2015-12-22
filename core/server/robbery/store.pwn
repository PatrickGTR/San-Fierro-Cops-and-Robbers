#include <YSI\y_hooks>

#define ENEX_STREAMER_IDENTIFIER (100)

enum sData
{
    mapIcon,
    Float:entPos[4],
    Float:extPos[4],
    Float:actorPos[4],
    interiorID,
    virtualID,
    entCP,
    extCP
}

static const storeData[][sData] =
{
// MapIcon, {EntX, EntY, EntZ, EntAngle},                         {ExtX, ExtY, ExtZ, ExtAngle},                         {ActorX, ActorY, ActorZ, Actor Angle}           interiorID
    {7,     {-2570.952880, 246.184768, 10.150715, 214.570617 },   {418.724334, -83.729606, 1001.804687, 2.731869     }, {418.1863, -76.2570, 1001.8047, 180.9736   },   3}, // SF Barbershop near SF Ammunation
    {17,    {-1810.357543, 902.086364, 24.890625, 313.132385 },   {-25.719999, -187.820007, 1003.546875, 5.079987    }, {-28.0577, -186.8351, 1003.5469, 3.8993    },   17},
    {6,     {-2625.968261, 208.754470, 4.613268, 356.114105  },   {315.741088, -143.113723, 999.601562, 357.152282   }, {316.1078, -132.3989, 999.6016, 89.9578    },   7}, //SF Ammunation
    {45,    {-1695.482910, 951.206542, 24.890625, 314.203582 },   {226.802993, -8.077754, 1002.210937, 92.674850     }, {204.8530, -9.2142, 1001.2109, 270.1043    },   5},
    {17,    {-2766.786132, 788.700012, 52.781250, 271.583099 },   {377.304656, -192.390274, 1000.632812, 2.908989    }, {380.7103, -189.1101, 1000.6328, 180.6518  },   17}, //Tuff Nut Donuts
    {54,    {-2269.823974, -155.988357, 35.320312, 271.694580},   {774.058593, -49.838584, 1000.585937, 357.403778   }, {754.3979, -40.1885, 1000.5922, 276.7313   },   6}, // SF Gym
    {45,    {-2490.843994, -28.952697, 25.617187, 92.963760  },   {203.738296, -50.123699, 1001.804687, 2.722898     }, {203.2479, -41.6703, 1001.8047, 179.2123   },   1},
    {39,    {-2491.648681, -38.854286, 25.765625, 87.950401  },   {-204.356704, -43.902355, 1002.273437, 357.709625  }, {-201.9782, -42.1274, 1002.2734, 117.6855  },   3},
    {10,    {-1911.995483, 828.446655, 35.178638, 320.104949 },   {363.363952, -74.890876, 1001.507812, 307.571472   }, {376.4918, -65.8485, 1001.5078, 181.3203   },   10}, //SF Burger Shot, Downton
    {45,    {-1882.956176, 865.727233, 35.171875, 138.496170 },   {161.441177, -96.324462, 1001.804687, 3.448270     }, {159.7083, -81.1919, 1001.8120, 180.9010   },   18},
    {21,    {-2624.600097, 1412.293701, 7.093750, 198.490875 },   {-2636.747558, 1402.708984, 906.460937, 4.849049   }, {-2655.5066, 1411.1595, 906.2734, 265.9626 },   3}, //SF Jizzy Club
    {45,    {-2374.372070, 910.113586, 45.445312, 92.353279  },   {207.692260, -110.613677, 1005.132812, 354.134033  }, {206.3147, -98.7046, 1005.2578, 181.8224   },   15},
    {49,    {-2155.633300, 420.710601, 35.171875, 269.676025 },   {459.565338, -88.507835, 999.554687, 85.747474     }, {451.3924, -82.2319, 999.5547, 181.2106    },   4},
    {47,    {-2242.262207, 128.649826, 35.320312, 92.145584  },   {-2240.115478, 137.217895, 1035.414062, 261.010467 }, {-2238.0598, 128.5868, 1035.4141, 358.2259 },   6},
    {14,    {-1816.539672, 617.781005, 35.171875, 176.543548 },   {364.963867, -11.351931, 1001.851562, 353.746887   }, {370.8739, -4.4916, 1001.8589, 182.5842    },   9},
    {55,    {-2026.448974, -101.256446, 35.200000, 359.791564},   {-2027.019653, -104.270217, 1035.171875, 178.682830}, {-2035.0939, -117.5509, 1035.1719, 271.6392},   3},
    {49,    {-2162.509277, 129.075164, 35.320312, 252.340255 },   {501.804626, -68.321372, 998.757812, 174.319519    }, {499.7835, -77.5629, 998.7651, 2.6346      },   11},
    {17,    {-1675.394897, 431.402069, 7.179687, 46.976207   },   {-27.519210, -57.711254, 1003.546875, 2.013339     }, {-22.5939, -57.3682, 1003.5469, 3.6525     },   6},
    {10,    {-2336.175292, -166.787719, 35.554687, 269.559173},   {363.363952, -74.890876, 1001.507812, 307.571472   }, {376.4918, -65.8485, 1001.5078, 181.3203   },   10}, //SF Burger Shot (Bugged Interior)
    {59,    {-2551.768310, 193.532730, 6.175927, 113.444000  },   {493.140014, -24.260000, 1000.679687, 356.990020   }, {501.8498, -18.5173, 1000.6719, 89.2153    },   17}
};                

static DelayTick[MAX_PLAYERS];

hook OnGameModeInit()
{
    new 
        arr[2];

    arr[0] = ENEX_STREAMER_IDENTIFIER;
    for(new i = 0; i != sizeof(storeData); ++i)
    {

        storeData[i][entCP] = CreateDynamicCP(storeData[i][entPos][0],  storeData[i][entPos][1], storeData[i][entPos][2] + 0.5, 1, -1, -1, -1, 50.0);
        storeData[i][extCP] = CreateDynamicCP(storeData[i][extPos][0],  storeData[i][extPos][1], storeData[i][extPos][2] + 0.5, 1, i, storeData[i][interiorID], -1, 50.0);

        CreateDynamic3DTextLabel("[ENTRANCE]", COLOR_YELLOW, storeData[i][entPos][0], storeData[i][entPos][1], storeData[i][entPos][2] + 0.2, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 50.0);
        CreateDynamic3DTextLabel("[EXIT]", COLOR_YELLOW, storeData[i][extPos][0],  storeData[i][extPos][1],  storeData[i][extPos][2] + 0.2, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 50.0);
        CreateDynamicMapIcon(storeData[i][entPos][0], storeData[i][entPos][1], storeData[i][entPos][2], storeData[i][mapIcon], -1, -1, -1, INVALID_PLAYER_ID, 200.0, MAPICON_GLOBAL);

  
    
        CreateRobberyActor(217, storeData[i][actorPos][0],  storeData[i][actorPos][1], storeData[i][actorPos][2], storeData[i][actorPos][3], i);

        storeData[i][virtualID] = i;
        arr[1] = i;

        Streamer_SetArrayData(STREAMER_TYPE_CP, storeData[i][entCP], E_STREAMER_EXTRA_ID, arr);
        Streamer_SetArrayData(STREAMER_TYPE_CP, storeData[i][extCP], E_STREAMER_EXTRA_ID, arr);
    }   
}


public OnPlayerEnterDynamicCP(playerid, checkpointid)    
{
    new 
        arr[2];

    Streamer_GetArrayData(STREAMER_TYPE_CP, checkpointid, E_STREAMER_EXTRA_ID, arr);

    if(arr[0] == ENEX_STREAMER_IDENTIFIER)
    {
        if((gettime() - DelayTick[playerid]) < 3)
            return 1; 

        if(checkpointid == storeData[arr[1]][entCP])
        {
            DelayTick[playerid] = gettime();

            SetPlayerVirtualWorld(playerid, storeData[arr[1]][virtualID]);
            SetPlayerInterior(playerid, storeData[arr[1]][interiorID]);

            SetPlayerPos(playerid, storeData[arr[1]][extPos][0], storeData[arr[1]][extPos][1], storeData[arr[1]][extPos][2]);
            SetPlayerFacingAngle(playerid, storeData[arr[1]][extPos][3]);
            SetCameraBehindPlayer(playerid);
        }
        if(checkpointid == storeData[arr[1]][extCP])
        {
            DelayTick[playerid] = gettime();

            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);

            SetPlayerPos(playerid, storeData[arr[1]][entPos][0], storeData[arr[1]][entPos][1], storeData[arr[1]][entPos][2]);
            SetPlayerFacingAngle(playerid, storeData[arr[1]][entPos][3]);
            SetCameraBehindPlayer(playerid);
        }
    }

    #if defined hk_OnPlayerEnterDynamicCP
        return hk_OnPlayerEnterDynamicCP(playerid, checkpointid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OPPDP 
    #undef OnPlayerEnterDynamicCP
#else
    #define _ALS_OPPDP 
#endif
 
#define OnPlayerEnterDynamicCP hk_OnPlayerEnterDynamicCP

#if defined hk_OnPlayerEnterDynamicCP
    forward hk_OnPlayerEnterDynamicCP(playerid, checkpointid);
#endif