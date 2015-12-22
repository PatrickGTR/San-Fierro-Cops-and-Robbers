Float:Distance(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
    return VectorSize(x1-x2, y1-y2, z1-z2);

IsPlayerNearPlayer(playerid, targetid, Float:radius = 2.50)
{
    new 
        Float: x, Float: y, Float: z;
    GetPlayerPos(targetid, x, y, z);

    if(IsPlayerInRangeOfPoint(playerid, radius, x, y, z)) 
    {
        return true;
    }
    return false;
}

GetClosestPlayerFromPlayer(playerid, Float:range = 10000.0) 
{
    new
        Float:x,
        Float:y,
        Float:z;

    GetPlayerPos(playerid, x, y, z);
   
    return GetClosestPlayerFromPoint(x, y, z, range, playerid);
}

GetClosestPlayerFromPoint(Float:x, Float:y, Float:z, &Float:lowestdistance = 10000.0, exceptionid = INVALID_PLAYER_ID) 
{
    new
        Float:px,
        Float:py,
        Float:pz,
        Float:distance,
        closestplayer = -1;

    foreach(new i : Player)
    {
        if(i == exceptionid)
            continue;

        GetPlayerPos(i, px, py, pz);

        distance = Distance(px, py, pz, x, y, z);

        if(distance < lowestdistance)
        {
            lowestdistance = distance;
            closestplayer = i;
        }
    }

    return closestplayer;
}