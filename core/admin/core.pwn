MsgAdmin(adminlvl, fmat[])
{
    foreach(new i : Player)
    {
        if(playerData[i][pAdmin] >= adminlvl)
        {
            MsgF(i, COLOR_PINK, "[ADMIN]: %C%s", COLOR_WHITE, fmat);
        }
    }
    return 1;
}

MsgAdminF(adminlvl, fmat[], va_args<>)
{
    static formatex_string[144 + 1];
    va_formatex(formatex_string, sizeof(formatex_string), fmat, va_start<2>);
    MsgAdmin(adminlvl, formatex_string);
    return 1;
}

