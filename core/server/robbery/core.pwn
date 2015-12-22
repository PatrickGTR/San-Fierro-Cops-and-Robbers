#include <YSI\y_hooks>

#define MAX_ROBBERY_ACTOR   (50)

#define TYPE_SUCCESS        (0)
#define TYPE_FAILED         (1)
#define TYPE_UNFINISHED     (2)

#define MIN_MONEY_ROB       500
#define MAX_MONEY_ROB       5000

forward OnPlayerRobbery(playerid, actorid, robbedmoney, type);

enum rData
{
    actorID, 
    actorSkinID,
    Float:actorPos[4],
    actorvW,
    actorJustBeenRobbed
}
new
    robberyData[MAX_ROBBERY_ACTOR][rData],
    Iterator:robberyIndex<MAX_ROBBERY_ACTOR>;

CreateRobberyActor(skinid, Float:x, Float:y, Float:z, Float:a, vwid)
{
    if(Iter_Count(robberyIndex) == -1)
    {
        print("ERROR: MAX_ROBBERY_ACTOR reached, increase the limit size.");
        return -1;
    }

    new 
        findID = Iter_Free(robberyIndex);

    robberyData[findID][actorID] = CreateActor(skinid, x, y, z, a);
    SetActorVirtualWorld(robberyData[findID][actorID], vwid);
    robberyData[findID][actorSkinID] = skinid;
    robberyData[findID][actorPos][0] = x;
    robberyData[findID][actorPos][1] = y;
    robberyData[findID][actorPos][2] = z;
    robberyData[findID][actorPos][3] = a;

    CreateDynamic3DTextLabel("[AIM TO ROB]", COLOR_BLUE, robberyData[findID][actorPos][0],  robberyData[findID][actorPos][1],  robberyData[findID][actorPos][2] + 1.2, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, vwid, -1, -1, 50.0);

    Iter_Add(robberyIndex, findID);
    return findID;
}

OnPlayerRobberyAimCheck(playerid)
{
    new 
        actorid = GetPlayerTargetActor(playerid);

    if(actorid == INVALID_ACTOR_ID)
        return 1;

    if(!IsPlayerInRangeOfPoint(playerid, 10.0, robberyData[actorid][actorPos][0], robberyData[actorid][actorPos][1], robberyData[actorid][actorPos][2]))
        return 1;

    if(gettime() - robberyData[actorid][actorJustBeenRobbed] < 60 * 5)
        return MsgTag(playerid, TYPE_ERROR, "This store just got robbed recently, come back later!");

    robberyData[actorid][actorJustBeenRobbed] = gettime();

    MsgF(playerid, COLOR_ORANGE, "<ROBBERY IN PROGRESS>");
    ClearActorAnimations(actorid);
    ApplyActorAnimation(actorid, "SHOP", "SHP_Rob_HandsUp", 4.1, 0, 1, 1, 1, 0);

    defer playActorAnim(playerid, actorid, 0);
    defer clearActorAnim(actorid);
    return 1;
}

timer playActorAnim[1000 * 5](playerid, actorid, animation_pattern) 
{
    switch(animation_pattern)
    {
        case 0:
        {
            if(!IsPlayerInRangeOfPoint(playerid, 10.0, robberyData[actorid][actorPos][0], robberyData[actorid][actorPos][1], robberyData[actorid][actorPos][2]))
            {
               OnPlayerRobbery(playerid, actorid, 0, TYPE_UNFINISHED);
            }
            else 
            {
                ClearActorAnimations(actorid);
                ApplyActorAnimation(actorid, "SHOP", "SHP_Rob_GiveCash", 4.1, 0, 1, 1, 1, 0);
                defer playActorAnim(playerid, actorid, 1);
            }
        }
        case 1:
        {
            ClearActorAnimations(actorid);
            ApplyActorAnimation(actorid, "PED", "DUCK_cower", 4.1, 1, 1, 1, 1, 1);

            new 
                robberyChance = random(100);
            if(robberyChance > 45)
            {
                OnPlayerRobbery(playerid, actorid, (random(MAX_MONEY_ROB - MIN_MONEY_ROB) + MIN_MONEY_ROB), TYPE_SUCCESS);
            }
            else OnPlayerRobbery(playerid, actorid, 0, TYPE_FAILED);
        }
    }
}

timer clearActorAnim[1000 * 60 * 5](actorid)
{
    ClearActorAnimations(actorid);
}

