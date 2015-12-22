#define Kick(%0) defer KickTimer(%0)
#define Ban(%0) defer BanTimer(%0)

native KickxTimer(playerid) = Kick;
native BanxTimer(playerid) = Ban;
 

timer KickTimer[50](playerid)
{
	KickxTimer(playerid);
}
 
timer BanTimer[50](playerid)
{
	BanxTimer(playerid);
}