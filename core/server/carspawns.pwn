#include <YSI\y_hooks>

hook OnGameModeInit()
{
 	defer DelayLoadVehicles();
}

timer DelayLoadVehicles[100]()
{
	LoadStaticVehiclesFromFile("vehicles/sf_law.txt");
    LoadStaticVehiclesFromFile("vehicles/sf_airport.txt");
    LoadStaticVehiclesFromFile("vehicles/sf_gen.txt");

    LoadStaticVehiclesFromFile("vehicles/whetstone.txt");
}

stock LoadStaticVehiclesFromFile(const filename[])
{
	new 
		line[55],
		File:file_ptr,
		vehicletype,
		Float:SpawnX,
		Float:SpawnY,
		Float:SpawnZ,
		Float:SpawnRot,
   		col1, 
   		col2, 
   		vehicles_loaded;

	file_ptr = fopen(filename, filemode:io_read);

	if(!file_ptr) return 0;

	vehicles_loaded = 0;

	while(fread(file_ptr, line, sizeof(line)) > 0)
	{
	    sscanf(line, "p<,>iffffii", vehicletype, SpawnX, SpawnY, SpawnZ, SpawnRot, col1, col2);
 
	 	if(vehicletype < 400 || vehicletype > 611) continue;
  		
  		AddStaticVehicleEx(vehicletype, SpawnX, SpawnY, SpawnZ, SpawnRot, col1, col2,(30*60)); // respawn 30 minutes
		vehicles_loaded++;
	}

	fclose(file_ptr);
	printf("Loaded %d vehicles from: %s",vehicles_loaded, filename);
	return vehicles_loaded;
}