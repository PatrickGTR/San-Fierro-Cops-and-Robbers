ACMD:[3]ban(playerid, params[])
{

    if(isnull(params) || strval(params))
    {
        MsgTag(playerid, TYPE_USAGE, "/ban hour | week | month | year");
        return 1;
    }

    new 
        targetid, reason[MAX_BAN_REASON], duration;

    if(!strcmp(params, "hour", true, 4))
    {
        if(sscanf(params, "{s[5]}ris[50]", targetid, duration, reason))
        {
            MsgTag(playerid, TYPE_USAGE, "/ban hour <playerid> <duration> <reason> ");
            return 1;
        }

        if(!(IsPlayerConnected(targetid)))
        {
            MsgTag(playerid, TYPE_ERROR, "The player you are trying to ban is not connected.");
            return 1;
        }

        if(strlen(reason) > MAX_BAN_REASON)
        {
            MsgTag(playerid, TYPE_ERROR,"The lenght of the reason is too long, maximum characters is 50");
            return 1;
        }
        AddPlayerBan(playerid, targetid, reason, TIMESTAMP_HOUR * duration);
    }
    if(!strcmp(params, "week", true, 4))
    {
        if(sscanf(params, "{s[5]}ris[50]", targetid, duration, reason))
        {
            MsgTag(playerid, TYPE_USAGE, "/ban week <playerid> <duration> <reason>");
            return 1;
        }

        if(!(IsPlayerConnected(targetid)))
        {
            MsgTag(playerid, TYPE_ERROR, "The player you are trying to ban is not connected.");
            return 1;
        }

        if(strlen(reason) > MAX_BAN_REASON)
        {
            MsgTag(playerid, TYPE_ERROR,"The lenght of the reason is too long, maximum characters is 50");
            return 1;
        }
        AddPlayerBan(playerid, targetid, reason, TIMESTAMP_WEEK * duration);
    }
    if(!strcmp(params, "month", true, 5))
    {
        if(sscanf(params, "{s[6]}ris[50]", targetid, duration, reason))
        {
            MsgTag(playerid, TYPE_USAGE, "/ban month <playerid> <duration> <reason>");
            return 1;
        }
        
        if(!(IsPlayerConnected(targetid)))
        {
            MsgTag(playerid, TYPE_ERROR, "The player you are trying to ban is not connected.");
            return 1;
        }

        if(strlen(reason) > MAX_BAN_REASON)
        {
            MsgTag(playerid, TYPE_ERROR,"The lenght of the reason is too long, maximum characters is 50");
            return 1;
        }
        AddPlayerBan(playerid, targetid, reason, TIMESTAMP_MONTH * duration);
    }
    if(!strcmp(params, "year", true, 5))
    {
        if(sscanf(params, "{s[5]}ris[50]", targetid, duration, reason))
        {
            MsgTag(playerid, TYPE_USAGE, "/ban year <playerid> <duration> <reason>");
            return 1;
        }
        
        if(!(IsPlayerConnected(targetid)))
        {
            MsgTag(playerid, TYPE_ERROR, "The player you are trying to ban is not connected.");
            return 1;
        }

        if(strlen(reason) > MAX_BAN_REASON)
        {
            MsgTag(playerid, TYPE_ERROR,"The lenght of the reason is too long, maximum characters is 50");
            return 1;
        }
        AddPlayerBan(playerid, targetid, reason, TIMESTAMP_MONTH * duration);
    }
    MsgTag(playerid, TYPE_SERVER, "You have been banned by admin %C%p %Cfor %C%s", COLOR_GREY, playerid, COLOR_WHITE, COLOR_GREY, reason);
    return 1;
}

ACMD:[3]unban(playerid, params[])
{
    if(isnull(params) || strval(params))
    {
        MsgTag(playerid, TYPE_USAGE, "/unban <playername>");
        return 1;
    }
    RemovePlayerBan(params, playerid);
    return 1;
}