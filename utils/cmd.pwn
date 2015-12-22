/*
    Reference: http://forum.sa-mp.com/showpost.php?p=3535720&postcount=1176
    Credits to Nero_3D: http://forum.sa-mp.com/member.php?u=9765
*/
#define CMD:%1(%2) \
                    forward C%1(%2); \
                                        public C%1(%2)
#define ACMD:[%0]%1(%2,%3) CMD:%1(%2,%3) \
                                            if(playerData[%2][pAdmin] < %0) \
                                                                                    return MsgTag(%2, TYPE_ERROR, "Your admin level is too low, this command is for admin level %C%i", COLOR_YELLOW, %0); else

public OnPlayerCommandText(playerid, cmdtext[]) 
{


    // Initialization code - Gets called only once
    static
        offset,
        cell,
        adr
    ;
    // To prevent recalling the code if someone tries to call this function manually
    if(offset == 0) // that would be the case with the latest hooking method
    { 
        // Offset to the public table
        #emit lctrl 1 // dat
        #emit neg
        #emit move.alt
        #emit add.c 32 // publics
        #emit stor.pri offset
        #emit lref.pri offset
        #emit add
        #emit stor.pri offset
        // Public index of the current function
        funcidx(#OnPlayerCommandText);
        // Adding public index to offset
        #emit shl.c.pri 3
        #emit load.alt offset
        #emit add
        #emit stor.pri cell
        // Overwriting internal address with new one
        #emit lctrl 6
        #emit add.c 32
        #emit sref.pri cell
        #emit add.c 4
        #emit sctrl 6
        // New start of the this function
        #emit proc
    } {}
    // Calls the new OnPlayerCommandText
    #if defined ncmd_OnPlayerCommandText
        if(ncmd_OnPlayerCommandText(playerid, cmdtext)) 
        {
            return true; // Stops execution if the command already exists
        } // Or any other reason why you would return true :)
    #endif
    // cmdtext[0] = 'C', adr = cmdtext
    #emit load.s.alt cmdtext
    #emit stor.alt adr
    #emit const.pri 'C'
    #emit stor.i
    // Looping till EOS or Space
    do // skipping first cell, it is always '\'
    { 
        #emit load.pri adr
        #emit add.c 4
        #emit stor.pri adr
        #emit load.i
        #emit stor.pri cell
    } while(cell > ' ');
    // Replacing Space with EOS and adr += 4
    if(cell == ' ') 
    {
        #emit load.alt adr
        #emit zero.pri
        #emit stor.i
        #emit const.pri 4
        #emit add
        #emit stor.pri adr
    } // Getting funcidx of command
    if((cell = funcidx(cmdtext)) != -1) 
    {
        // Overwritting address of cmdtext
        #emit load.pri adr
        #emit stor.s.pri cmdtext
        // Calling command
        #emit load.pri cell
        #emit shl.c.pri 3
        #emit load.alt offset
        #emit add
        #emit stor.pri cell
        #emit lref.pri cell
        #emit add.c 4
        #emit sctrl 6
    } // Return false if no command was found
    return false;
}
// ALS macros
#if defined _ALS_OnPlayerCommandText
    #undef OnPlayerCommandText
#else
    #define _ALS_OnPlayerCommandText
#endif
#define OnPlayerCommandText ncmd_OnPlayerCommandText
// Forward for the hooked function
#if defined ncmd_OnPlayerCommandText
    forward ncmd_OnPlayerCommandText(playerid, cmdtext[]);
#endif