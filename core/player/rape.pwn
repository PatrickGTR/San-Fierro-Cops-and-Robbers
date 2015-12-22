#define NONE (0)
#define GONORRHEA (1)
#define HIV (2)
#define AIDS (3)
#define CHLAMYDIA (4)
#define HERPES (5)

IsPlayerInfected(playerid) 
{
	return (jobData[playerid][DiseaseType] > 0) ? 1 : 0;
}

GivePlayerDisease(playerid, diseasetype)
{
	switch(diseasetype)
	{
		case NONE: jobData[playerid][DiseaseType] = NONE;
		case GONORRHEA: jobData[playerid][DiseaseType] = GONORRHEA;
		case HIV: jobData[playerid][DiseaseType] = HIV;
		case AIDS: jobData[playerid][DiseaseType] = AIDS;
		case CHLAMYDIA: jobData[playerid][DiseaseType] = CHLAMYDIA;
		case HERPES: jobData[playerid][DiseaseType] = HERPES;
	}
	return true;
}

GetDiseaseName(playerid)
{
	new 
		diseaseName[ 10 ];
	switch(jobData[playerid][ DiseaseType ])
	{
		case NONE: strcat(diseaseName, "None");
		case GONORRHEA: strcat(diseaseName, "Gonorrhea");
		case HIV: strcat(diseaseName, "HIV");
		case AIDS: strcat(diseaseName, "AIDS");
		case CHLAMYDIA: strcat(diseaseName, "Chlamydia");
		case HERPES: strcat(diseaseName, "Herpes");
	}
	return diseaseName;
}

Float:GetDiseaseDamage(diseasetype)
{
    switch(diseasetype)
    {
        case NONE: return 0.0;
        case GONORRHEA: return 0.5;
        case HIV: return 0.8;
        case AIDS: return 1.0;
        case CHLAMYDIA: return 0.7;
        case HERPES: return 0.1;
    }
    return 0.0;
}

UpdatePlayerDiseaseDamage(playerid)
{
	if(IsPlayerInfected(playerid))
	{
		new 
			Float:ply_health;

		GetPlayerHealth(playerid, ply_health);
		SetPlayerHealth(playerid, ply_health - GetDiseaseDamage(jobData[playerid][DiseaseType]) );
	}
}
