CMD:rules(playerid, params[])
{
    globalString[0] = EOS;
    strcat(globalString, "Global Rules\n\n");
    strcat(globalString, "- Do not cheat or exploit bugs.\n");
    strcat(globalString, "- Do not use mods that gives you advantage\n");
    strcat(globalString, "- Do not spam in global chat.\n");
    strcat(globalString, "- Do not ask for admin in global chat.\n");
    strcat(globalString, "- Do not car park to kill a player.\n");
    strcat(globalString, "- Do not quit to avoid arrest, hit or an admin punishment\n");
    strcat(globalString, "- Do not heli blade to kill a player.\n");
    strcat(globalString, "- Do not advertise in global chat such as server ip, porn website and other game websites.\n");
    strcat(globalString, "- Do not disrespect other players, respect them so they would respect you the way you respect them.");
    strcat(globalString, "\n\nPolice and Army Rules\n\n");
    strcat(globalString, "- Do not kill innocent or yellow players.\n");
    strcat(globalString, "- Do not work with civilians, you may accept bribes.\n");
    strcat(globalString, "- Do not abuse specialized vehicles. (For example: camping outside an interior with a hunter)");
    Dialog_Show(playerid, DIALOG_STYLE_MSGBOX, "Server Rules", globalString, "Close", "");
    return 1;
}