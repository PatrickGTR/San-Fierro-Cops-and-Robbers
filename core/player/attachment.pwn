#include <YSI\y_hooks>

#include "utils/attachment.pwn"

#define TABLE_ATTACHMENT			"attachments"	
#define COLUMN_ATTACHMENT_SLOT		"slot"				
#define COLUMN_ATTACHMENT_MODEL		"model"			
#define COLUMN_ATTACHMENT_BONE		"bone"			
#define COLUMN_ATTACHMENT_OFFX		"offsetX"		
#define COLUMN_ATTACHMENT_OFFY		"offsetY"		
#define COLUMN_ATTACHMENT_OFFZ		"offsetZ"		
#define COLUMN_ATTACHMENT_ROTX		"rotationX"		
#define COLUMN_ATTACHMENT_ROTY		"rotationY"		
#define COLUMN_ATTACHMENT_ROTZ		"rotationZ"		
#define COLUMN_ATTACHMENT_SCALEX	"scaleX"		
#define COLUMN_ATTACHMENT_SCALEY	"scaleY"		
#define COLUMN_ATTACHMENT_SCALEZ	"scaleZ"		
	
#define MAX_SLOTS (5)
#define NEXT_PAGE (20)

enum aData
{
	modelID,
	boneID,
	Float:offset[3],
	Float:rotation[3],
	Float:scale[3],
	bool:attached
}
static 
	attachmentData[MAX_PLAYERS][MAX_SLOTS][aData],
	attachmentSlot[MAX_PLAYERS],
	attachmentPrice[MAX_PLAYERS],
	Iterator:attachmentIndex[MAX_PLAYERS]<MAX_SLOTS>,
	BitArray:ply_editingAttachments<MAX_PLAYERS>;

/*======================================================================================================
										[Hooked Callbacks]
=======================================================================================================*/

hook OnGameModeInit()
{
	yoursql_verify_table(serverDB, TABLE_ATTACHMENT);
	yoursql_verify_column(serverDB, ""TABLE_ATTACHMENT"/"COLUMN_NAME"", 				SQL_STRING);
	yoursql_verify_column(serverDB, ""TABLE_ATTACHMENT"/"COLUMN_ATTACHMENT_SLOT"", 		SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ATTACHMENT"/"COLUMN_ATTACHMENT_MODEL"", 	SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ATTACHMENT"/"COLUMN_ATTACHMENT_BONE"", 		SQL_NUMBER);
	yoursql_verify_column(serverDB, ""TABLE_ATTACHMENT"/"COLUMN_ATTACHMENT_OFFX"", 		SQL_FLOAT);
	yoursql_verify_column(serverDB, ""TABLE_ATTACHMENT"/"COLUMN_ATTACHMENT_OFFY"", 		SQL_FLOAT);
	yoursql_verify_column(serverDB, ""TABLE_ATTACHMENT"/"COLUMN_ATTACHMENT_OFFZ"", 		SQL_FLOAT);
	yoursql_verify_column(serverDB, ""TABLE_ATTACHMENT"/"COLUMN_ATTACHMENT_ROTX"", 		SQL_FLOAT);
	yoursql_verify_column(serverDB, ""TABLE_ATTACHMENT"/"COLUMN_ATTACHMENT_ROTY"", 		SQL_FLOAT);
	yoursql_verify_column(serverDB, ""TABLE_ATTACHMENT"/"COLUMN_ATTACHMENT_ROTZ"", 		SQL_FLOAT);
	yoursql_verify_column(serverDB, ""TABLE_ATTACHMENT"/"COLUMN_ATTACHMENT_SCALEX"", 	SQL_FLOAT);
	yoursql_verify_column(serverDB, ""TABLE_ATTACHMENT"/"COLUMN_ATTACHMENT_SCALEY"", 	SQL_FLOAT);
	yoursql_verify_column(serverDB, ""TABLE_ATTACHMENT"/"COLUMN_ATTACHMENT_SCALEZ"", 	SQL_FLOAT);
}

hook OnPlayerConnect(playerid)
{
	Iter_Init(attachmentIndex);

	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; ++i)
		RemovePlayerAttachedObject(playerid, i);

}

hook OnPlayerDisconnect(playerid, reason)
{
   	new 
        ResetInfo[aData];
    for(new i; i < MAX_SLOTS; ++i) 
		attachmentData[playerid][i] = ResetInfo;

    for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; ++i)
		RemovePlayerAttachedObject(playerid, i);

	attachmentSlot[playerid] = -1;
	Iter_Clear(attachmentIndex[playerid]);
	Bit_Vet(ply_editingAttachments, playerid);
}

hook OnPlayerEditAttachedObj(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	new SQLRow:rowid, name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);

	if(!response)
	{
		RemovePlayerAttachedObject(playerid, index);
		SetPlayerAttachedObject(playerid, index, attachmentData[playerid][index][modelID], attachmentData[playerid][index][boneID], 
			attachmentData[playerid][index][offset][0], attachmentData[playerid][index][offset][1], attachmentData[playerid][index][offset][2], 
			attachmentData[playerid][index][rotation][0], attachmentData[playerid][index][rotation][1], attachmentData[playerid][index][rotation][2], 
			attachmentData[playerid][index][scale][0], attachmentData[playerid][index][scale][1], attachmentData[playerid][index][scale][2]);

		Bit_Vet(ply_editingAttachments, playerid);
		return true;
	}

	if(Bit_Get(ply_editingAttachments, playerid))
	{
		attachmentData[playerid][index][offset][0] = fOffsetX;
		attachmentData[playerid][index][offset][1] = fOffsetY;
		attachmentData[playerid][index][offset][2] = fOffsetZ;
		attachmentData[playerid][index][rotation][0] = fRotX;
		attachmentData[playerid][index][rotation][1] = fRotY;
		attachmentData[playerid][index][rotation][2] = fRotZ;
		attachmentData[playerid][index][scale][0] = fScaleY;
		attachmentData[playerid][index][scale][1] = fScaleY;
		attachmentData[playerid][index][scale][2] = fScaleY;
		attachmentData[playerid][index][attached] = true;

		RemovePlayerAttachedObject(playerid, index);
		SetPlayerAttachedObject(playerid, index, attachmentData[playerid][index][modelID], attachmentData[playerid][index][boneID], 
			attachmentData[playerid][index][offset][0], attachmentData[playerid][index][offset][1], attachmentData[playerid][index][offset][2], 
			attachmentData[playerid][index][rotation][0], attachmentData[playerid][index][rotation][1], attachmentData[playerid][index][rotation][2], 
			attachmentData[playerid][index][scale][0], attachmentData[playerid][index][scale][1], attachmentData[playerid][index][scale][2]);

		rowid = yoursql_multiget_row(serverDB, TABLE_ATTACHMENT, "si", COLUMN_NAME, name, COLUMN_ATTACHMENT_SLOT, index);

		yoursql_multiset_fields(serverDB, TABLE_ATTACHMENT, rowid, "ifffffffff",
			COLUMN_ATTACHMENT_BONE,		attachmentData[playerid][index][boneID],
			COLUMN_ATTACHMENT_OFFX, 	attachmentData[playerid][index][offset][0],
			COLUMN_ATTACHMENT_OFFY, 	attachmentData[playerid][index][offset][1],
			COLUMN_ATTACHMENT_OFFZ, 	attachmentData[playerid][index][offset][2],
			COLUMN_ATTACHMENT_ROTX, 	attachmentData[playerid][index][rotation][0],
			COLUMN_ATTACHMENT_ROTY, 	attachmentData[playerid][index][rotation][1],
			COLUMN_ATTACHMENT_ROTZ, 	attachmentData[playerid][index][rotation][2],
			COLUMN_ATTACHMENT_SCALEX,  	attachmentData[playerid][index][scale][0],
			COLUMN_ATTACHMENT_SCALEY,  	attachmentData[playerid][index][scale][1],
			COLUMN_ATTACHMENT_SCALEZ,  	attachmentData[playerid][index][scale][2]);

		MsgTag(playerid, TYPE_SERVER, "You have edited attachment id %C%i", COLOR_GREY, index);

		Bit_Vet(ply_editingAttachments, playerid);
	}
	else
	{
		attachmentData[playerid][index][modelID] = modelid;
		attachmentData[playerid][index][boneID] = boneid;
		attachmentData[playerid][index][offset][0] = fOffsetX;
		attachmentData[playerid][index][offset][1] = fOffsetY;
		attachmentData[playerid][index][offset][2] = fOffsetZ;
		attachmentData[playerid][index][rotation][0] = fRotX;
		attachmentData[playerid][index][rotation][1] = fRotY;
		attachmentData[playerid][index][rotation][2] = fRotZ;
		attachmentData[playerid][index][scale][0] = fScaleY;
		attachmentData[playerid][index][scale][1] = fScaleY;
		attachmentData[playerid][index][scale][2] = fScaleY;
		attachmentData[playerid][index][attached] = true;

		RemovePlayerAttachedObject(playerid, index);
		SetPlayerAttachedObject(playerid, index, attachmentData[playerid][index][modelID], attachmentData[playerid][index][boneID], 
			attachmentData[playerid][index][offset][0], attachmentData[playerid][index][offset][1], attachmentData[playerid][index][offset][2], 
			attachmentData[playerid][index][rotation][0], attachmentData[playerid][index][rotation][1], attachmentData[playerid][index][rotation][2], 
			attachmentData[playerid][index][scale][0], attachmentData[playerid][index][scale][1], attachmentData[playerid][index][scale][2]);

		yoursql_multiset_row(serverDB, TABLE_ATTACHMENT, "si", COLUMN_NAME, name, COLUMN_ATTACHMENT_SLOT, index);

		rowid = yoursql_multiget_row(serverDB, TABLE_ATTACHMENT, "si", COLUMN_NAME, name, COLUMN_ATTACHMENT_SLOT, index);
		
		yoursql_multiset_fields(serverDB, TABLE_ATTACHMENT, rowid, "iifffffffff",
			COLUMN_ATTACHMENT_MODEL, 	attachmentData[playerid][index][modelID],
			COLUMN_ATTACHMENT_BONE,		attachmentData[playerid][index][boneID],
			COLUMN_ATTACHMENT_OFFX, 	attachmentData[playerid][index][offset][0],
			COLUMN_ATTACHMENT_OFFY, 	attachmentData[playerid][index][offset][1],
			COLUMN_ATTACHMENT_OFFZ, 	attachmentData[playerid][index][offset][2],
			COLUMN_ATTACHMENT_ROTX, 	attachmentData[playerid][index][rotation][0],
			COLUMN_ATTACHMENT_ROTY, 	attachmentData[playerid][index][rotation][1],
			COLUMN_ATTACHMENT_ROTZ, 	attachmentData[playerid][index][rotation][2],
			COLUMN_ATTACHMENT_SCALEX,  	attachmentData[playerid][index][scale][0],
			COLUMN_ATTACHMENT_SCALEY,  	attachmentData[playerid][index][scale][1],
			COLUMN_ATTACHMENT_SCALEZ,  	attachmentData[playerid][index][scale][2]);

		MsgTag(playerid, TYPE_SERVER, "You have bought an attachment and it has been inserted in id %C%i", COLOR_GREY, index);
		GivePlayerMoney(playerid, -attachmentPrice[playerid]);
		Iter_Add(attachmentIndex[playerid], index);
	}
	return true;
}

hook OnPlayerLogin(playerid)
{
	new 
		name[MAX_PLAYER_NAME], DBResult:result;

	GetPlayerName(playerid, name, sizeof(name));

	result = yoursql_query(serverDB, false, "SELECT "COLUMN_NAME", \
			"COLUMN_ATTACHMENT_SLOT", "COLUMN_ATTACHMENT_MODEL", "COLUMN_ATTACHMENT_BONE", \
			"COLUMN_ATTACHMENT_OFFX", "COLUMN_ATTACHMENT_OFFY", "COLUMN_ATTACHMENT_OFFZ", \
			"COLUMN_ATTACHMENT_ROTX", "COLUMN_ATTACHMENT_ROTY", "COLUMN_ATTACHMENT_ROTZ", \
			"COLUMN_ATTACHMENT_SCALEX", "COLUMN_ATTACHMENT_SCALEY", "COLUMN_ATTACHMENT_SCALEZ" \
	FROM "TABLE_ATTACHMENT" WHERE "COLUMN_NAME" = '%q'", name);	
 
	if(db_num_rows(result))
	{
		new id;
		for(new i = 0; i < db_num_rows(result); ++i)
		{	
			id 	= db_get_field_assoc_int(result, COLUMN_ATTACHMENT_SLOT);
			attachmentData[playerid][id][modelID]		= 	db_get_field_assoc_int(result, COLUMN_ATTACHMENT_MODEL);
			attachmentData[playerid][id][boneID] 		= 	db_get_field_assoc_int(result, COLUMN_ATTACHMENT_BONE);

			attachmentData[playerid][id][offset][0] 	= 	db_get_field_assoc_float(result, COLUMN_ATTACHMENT_OFFX);
			attachmentData[playerid][id][offset][1] 	= 	db_get_field_assoc_float(result, COLUMN_ATTACHMENT_OFFY);
			attachmentData[playerid][id][offset][2] 	= 	db_get_field_assoc_float(result, COLUMN_ATTACHMENT_OFFZ);
			attachmentData[playerid][id][rotation][0] 	= 	db_get_field_assoc_float(result, COLUMN_ATTACHMENT_ROTX);
			attachmentData[playerid][id][rotation][1] 	= 	db_get_field_assoc_float(result, COLUMN_ATTACHMENT_ROTY);
			attachmentData[playerid][id][rotation][2] 	= 	db_get_field_assoc_float(result, COLUMN_ATTACHMENT_ROTZ);
			attachmentData[playerid][id][scale][0] 		= 	db_get_field_assoc_float(result, COLUMN_ATTACHMENT_SCALEX);
			attachmentData[playerid][id][scale][1] 		= 	db_get_field_assoc_float(result, COLUMN_ATTACHMENT_SCALEY);
			attachmentData[playerid][id][scale][2] 		= 	db_get_field_assoc_float(result, COLUMN_ATTACHMENT_SCALEZ);

			Iter_Add(attachmentIndex[playerid], id);	
			db_next_row(result);
		}
	}
}

/*======================================================================================================
										[Functions]
=======================================================================================================*/

DeleteAttachment(playerid, slot)
{
	new 
		SQLRow:rowid, name[MAX_PLAYER_NAME], ResetInfo[aData];

	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	rowid = yoursql_multiget_row(serverDB, TABLE_ATTACHMENT, "si", COLUMN_NAME, name, COLUMN_ATTACHMENT_SLOT, slot);

    attachmentData[playerid][slot] = ResetInfo;
	RemovePlayerAttachedObject(playerid, slot);
	yoursql_delete_row(serverDB, TABLE_ATTACHMENT, rowid);
	Iter_Remove(attachmentIndex[playerid], slot);
}

ShowAttachmentsList(playerid, slot)
{
	globalString[0] = EOS;
	for(new i = slot; i < slot + NEXT_PAGE; i++)
	{
		if(i < sizeof(mInfo))
		{
			format(globalString, sizeof(globalString), "%s%d - %s - %C$%d\n", globalString, i+1, mInfo[i][modelName], COLOR_GREEN, mInfo[i][modelPrice]);
		}
		if(i == (slot + NEXT_PAGE) - 1)
			strcat(globalString, "{FFFFFF}Next Page\n");
	}
	attachmentSlot[playerid] = slot;


	inline dialogAttachment(pid, dialogid, response, listitem, string:inputtext[])
	{
    	#pragma unused pid, dialogid, inputtext
    	if(!response)
			return 1; 

		if(listitem == NEXT_PAGE)
		{
			ShowAttachmentsList(playerid, attachmentSlot[playerid] + NEXT_PAGE);
		}
		else
		{
			new 
				i = attachmentSlot[playerid] + listitem,
				freeslot = Iter_Free(attachmentIndex[playerid]);

			if(freeslot == -1)
			{
				MsgTag(playerid, TYPE_ERROR, "You have used all of your attachment slots.");
				return 1;
			}

			MsgTag(playerid, TYPE_SERVER, "You bought a "C_GREY"%s "C_WHITE"for "C_GREEN"%m", GetModelName(mInfo[i][modelID]), mInfo[i][modelPrice]);
			SetPlayerAttachedObject(playerid, freeslot, mInfo[i][modelID], mInfo[i][modelBone]);
			attachmentPrice[playerid] = mInfo[i][modelPrice];
			EditAttachedObject(playerid, freeslot);
		}
    }

	Dialog_ShowCallback(playerid, using inline dialogAttachment, DIALOG_STYLE_LIST, "Purchasing Attachments", globalString, "Select", "Cancel");
	return 1;
}

/*======================================================================================================
										[Commands]
=======================================================================================================*/

CMD:attachment(playerid, params[])
{
	if(isnull(params))
		return MsgTag(playerid, TYPE_USAGE, "/attachments buy | delete | edit | view | attach | detach");

	new 
		index = 0;

	if(!strcmp(params, "buy", false, 3))
	{
		ShowAttachmentsList(playerid, 0);
	}
	if(!strcmp(params, "delete", false, 6))
	{
		if(sscanf(params, "{s[7]}i", index))
			return MsgTag(playerid, TYPE_USAGE, "/attachments delete <slot>");

		if(!Iter_Contains(attachmentIndex[playerid], index))
			return MsgTag(playerid, TYPE_ERROR, "The slot you are trying to delete is invalid.");

		MsgTag(playerid, TYPE_SERVER, "You successfully deleted attachment id %i (%s)", index, GetModelName(attachmentData[playerid][index][modelID]));

		DeleteAttachment(playerid, index);
	}
	if(!strcmp(params, "edit", false, 4))
	{
		if(sscanf(params, "{s[5]}i", index))
			return MsgTag(playerid, TYPE_USAGE, "/attachments edit <slot>");

		if(!Iter_Contains(attachmentIndex[playerid], index))
			return MsgTag(playerid, TYPE_ERROR, "The slot you are trying to edit is invalid.");

		MsgTag(playerid, TYPE_SERVER, "You are editing attachment id %i (%s)", index, GetModelName(attachmentData[playerid][index][modelID]));

		SetPlayerAttachedObject(playerid, index, attachmentData[playerid][index][modelID], attachmentData[playerid][index][boneID], 
				attachmentData[playerid][index][offset][0], attachmentData[playerid][index][offset][1], attachmentData[playerid][index][offset][2], 
				attachmentData[playerid][index][rotation][0], attachmentData[playerid][index][rotation][1], attachmentData[playerid][index][rotation][2], 
				attachmentData[playerid][index][scale][0], attachmentData[playerid][index][scale][1], attachmentData[playerid][index][scale][2]);
		EditAttachedObject(playerid, index);

		Bit_Let(ply_editingAttachments, playerid);
	}
	if(!strcmp(params, "view", false, 4))
	{
		Msg(playerid, COLOR_LIGHTGREEN, "================== [Attachments] ==================");	
		
		for(new i = 0; i < MAX_SLOTS; i++)
		{
			if(Iter_Contains(attachmentIndex[playerid], i)) 
				MsgF(playerid, COLOR_WHITE, "Slot %i: %s", i, GetModelName(attachmentData[playerid][i][modelID]));
			else
			 	MsgF(playerid, COLOR_WHITE, "Slot %i: EMPTY", i);
			
		}
		Msg(playerid, COLOR_LIGHTGREEN, "================== [Attachments] ==================");	
	}
	if(!strcmp(params, "attach", false, 6))
	{
		if(sscanf(params, "{s[7]}i", index))
			return MsgTag(playerid, TYPE_USAGE, "/attachments attach <slot>");

		if(!Iter_Contains(attachmentIndex[playerid], index))
			return MsgTag(playerid, TYPE_ERROR, "The slot you are trying to attach is invalid.");

		SetPlayerAttachedObject(playerid, index, attachmentData[playerid][index][modelID], attachmentData[playerid][index][boneID], 
				attachmentData[playerid][index][offset][0], attachmentData[playerid][index][offset][1], attachmentData[playerid][index][offset][2], 
				attachmentData[playerid][index][rotation][0], attachmentData[playerid][index][rotation][1], attachmentData[playerid][index][rotation][2], 
				attachmentData[playerid][index][scale][0], attachmentData[playerid][index][scale][1], attachmentData[playerid][index][scale][2]);

		MsgTag(playerid, TYPE_SERVER, "You have successfully attached attachment id %i (%s)", index, GetModelName(attachmentData[playerid][index][modelID]));
	}
	if(!strcmp(params, "detach", false, 6))
	{
		if(sscanf(params, "{s[7]}i", index))
			return MsgTag(playerid, TYPE_USAGE, "/attachments detach <slot>");

		if(!Iter_Contains(attachmentIndex[playerid], index))
			return MsgTag(playerid, TYPE_ERROR, "The slot you are trying to detach is invalid.");

		RemovePlayerAttachedObject(playerid, index);
		MsgTag(playerid, TYPE_SERVER, "You have successfully detached attachment id %i (%s)", index, GetModelName(attachmentData[playerid][index][modelID]));
	}
	return true;
}

