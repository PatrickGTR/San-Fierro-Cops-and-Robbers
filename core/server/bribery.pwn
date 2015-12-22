//Thanks to Slice for the coordination - Source: http://forum.sa-mp.com/showpost.php?p=984484&postcount=14

#include <YSI\y_hooks>

#define BRIBERY_PICKUP_IDENTIFIER (100)

enum bData
{
	Float:pickupPosX,
	Float:pickupPosY,
	Float:pickupPosZ,
	pickupID,
	pickupWait
}

new const briberyData[][bData] = {	
	{2743.0, 	1316.0, 	8.0},
	{2168.66, 	2267.96, 	15.34},
	{2408.0, 	1389.0, 	22.0},
	{2034.0, 	842.0, 		10.0},
	{2096.0, 	1287.0, 	10.8},
	{1987.0, 	1543.0, 	16.0},
	{1854.0, 	912.0, 		10.8},
	{2540.38, 	2527.85, 	10.39},
	{1548.02, 	1024.47, 	10.39},
	{1592.91, 	2053.83, 	10.26},
	{1971.29, 	2330.26, 	10.41},
	{1700.74, 	1792.7, 	10.41},
	{2581.0, 	-1491.0, 	24.0},
	{2296.0, 	-1696.0, 	14.0},
	{2273.0, 	-1099.0, 	38.0},
	{2716.0, 	-1048.0, 	66.0},
	{2614.0, 	-2496.0, 	33.0},
	{1183.85, 	-1250.68, 	14.7},
	{1970.0, 	-1158.0, 	21.0},
	{734.0, 		-1137.0, 	18.0},
	{2553.76, 	-2464.31, 	13.62},
	{1204.06, 	-1613.89, 	13.28},
	{611.21, 	-1459.63, 	14.01},
	{1116.67, 	-719.91, 	100.17},
	{-1903.1, 	-466.44, 	25.18},
	{-2657.0, 	-144.0, 	4.0},
	{-2454.0, 	-166.0, 	35.0},
	{-2009.0, 	1227.0, 	32.0},
	{-2120.0, 	96.39, 		39.0},
	{-2411.0, 	-334.0, 	37.0},
	{-1690.0,	 450.0, 	13.0},
	{-1991.26, 	-1144.13, 	29.6},
	{-2636.13, 	-492.83, 	70.09},
	{-2022.68,	 345.98, 	35.17},
	{-2683.2, 	784.13, 	49.98},
	{-1820.67, 	-154.12, 	9.4},
	{-736.0, 	66.0, 		24.0},
	{262.33, 	-149.12, 	1.58},
	{1643.0, 	264.0, 		20.0},
	{601.98, 	2150.38, 	39.41},
	{-1407.0, 	-2039.0, 	1.0},
	{-2156.0, 	-2371.0, 	31.0},
	{-419.25, 	1362.36, 	12.21},
	{629.04, 	2842.83, 	25.21},
	{690.49,	 	-209.59, 	25.6},
	{88.82, 		-125.1, 	0.85},
	{215.69, 	1089.1, 	16.4},
	{-2305.24, 	2310.11, 	4.98},
	{-213.61, 	2717.44, 	62.68}
};	

hook OnGameModeInit()
{
	new 
		arr[2];

	arr[0] = BRIBERY_PICKUP_IDENTIFIER;

	for(new i = 0; i != sizeof(briberyData); ++i)
	{

		briberyData[i][pickupID] = CreateDynamicPickup(1247, 15, briberyData[i][pickupPosX], briberyData[i][pickupPosY], briberyData[i][pickupPosZ]);

		arr[1] = i;
		Streamer_SetArrayData(STREAMER_TYPE_PICKUP, briberyData[i][pickupID], E_STREAMER_EXTRA_ID, arr, sizeof(arr));

 	}
}

hook OnPlayerPickUpDynPickup(playerid, pickupid)
{
	new 
		arr[2];

	Streamer_GetArrayData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_EXTRA_ID, arr, sizeof(arr));

	if(arr[0] == BRIBERY_PICKUP_IDENTIFIER && briberyData[arr[1]][pickupID] == pickupid && GetPlayerWantedLevel(playerid) > 0)
	{

		if(gettime() - briberyData[arr[1]][pickupWait] < 60 * 5)				
			return 1;

		if(GetPlayerTeam(playerid) != TEAM_CIVILIAN)
			return 1;

		SetPlayerWantedLevel(playerid, GetPlayerWantedLevel(playerid) - 4);
		MsgF(playerid, COLOR_YELLOW, "** Bribery **%CYou have found a bribery pickup and your wanted level went down by 4. Current Wanted Level: %C%i", COLOR_WHITE, COLOR_YELLOW, GetPlayerWantedLevel(playerid));

		briberyData[arr[1]][pickupWait] = gettime();
	}
	return 1;
}

