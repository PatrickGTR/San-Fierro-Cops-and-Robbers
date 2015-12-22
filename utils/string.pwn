//Thanks to Southclaw - https://github.com/Southclaw/ScavengeSurvive/blob/master/gamemodes/SS/utils/message.pwn
static 
    formatex_string[144 + 1];

Msg(playerid, colour, string[])
{
    if(strlen(string) > 127)
    {
        new
            string2[128],
            splitpos;

        for(new c = 128; c > 0; c--)
        {
            if(string[c] == ' ' || string[c] ==  ',' || string[c] ==  '.')
            {
                splitpos = c;
                break;
            }
        }

        strcat(string2, string[splitpos]);
        string[splitpos] = EOS;
        
        SendClientMessage(playerid, colour, string);
        SendClientMessage(playerid, colour, string2);
    }
    else SendClientMessage(playerid, colour, string);
    
    return 1;
}

MsgAll(colour, string[])
{
    if(strlen(string) > 127)
    {
        new
            string2[128],
            splitpos;

        for(new c = 128; c>0; c--)
        {
            if(string[c] == ' ' || string[c] ==  ',' || string[c] ==  '.')
            {
                splitpos = c;
                break;
            }
        }

        strcat(string2, string[splitpos]);
        string[splitpos] = EOS;

        SendClientMessageToAll(colour, string);
        SendClientMessageToAll(colour, string2);
    }
    else SendClientMessageToAll(colour, string);

    return 1;
}


MsgF(playerid, colour, fmat[], va_args<>)
{
    va_formatex(formatex_string, sizeof(formatex_string), fmat, va_start<3>);
    Msg(playerid, colour, formatex_string);
    return 1;
}

MsgAllF(colour, fmat[], va_args<>)
{
    va_formatex(formatex_string, sizeof(formatex_string), fmat, va_start<2>);
    MsgAll(colour, formatex_string);
    return 1;
}

#define TYPE_ERROR      (0)
#define TYPE_USAGE      (1)
#define TYPE_SERVER     (2)

MsgTag(playerid, msg_type, fmat[], va_args<>)
{
    va_formatex(formatex_string, sizeof(formatex_string), fmat, va_start<3>);
    switch(msg_type)
    {
        case TYPE_ERROR:
        {
            MsgF(playerid, COLOR_RED, "<ERROR>: %C%s", COLOR_WHITE, formatex_string);
        } 
        case TYPE_USAGE:
        {
            MsgF(playerid, COLOR_YELLOW, "<USAGE>: %C%s", COLOR_WHITE, formatex_string);
        }
        case TYPE_SERVER:
        {
            MsgF(playerid, COLOR_GREY, "<SERVER>: %C%s", COLOR_WHITE, formatex_string);
        }
    }
    return 1;
}

