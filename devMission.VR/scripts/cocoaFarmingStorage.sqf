// This file contains the functionality for handling the storage of player-harvested crops into a designated receptacle.
// Written by Andrew Spicher 08/12/2022

// Params array from addAction ["_target", "_caller", "_actionId", "_arguments"].
storageObject = _this select 0;
playerUnit = _this select 1;
args = _this select 3;

// This function transfers the number of harvested crops from the player's inventory into the designated storage container.
storePlayerCrops =
{
	if (playerUnit getVariable "playerHarvestedCrops" > 0) then 
	{
		// Transfer player inventory.
	_containerInventory = (storageObject getVariable "storedCrops") + (playerUnit getVariable "playerHarvestedCrops");

	// Set container inventory.
	storageObject setVariable["storedCrops", _containerInventory];

	// Clear player crops inventory.
	playerUnit setVariable["playerHarvestedCrops", 0];

	// Play player animation.
	playerUnit playMove "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
	sleep 1.2;

	// Display success message.
	["tasksucceeded",["","Harvested Crops Stored."]] call BIS_fnc_showNotification;
	} else 
	{
		// Display error.
		["taskfailed",["","No Crops to Store"]] call BIS_fnc_showNotification;
	};
};

// This function displays the number of stored crops in the storage container.
checkContainerCropInvenotry = 
{
	hint parseText format["<t color='#21ff76'>Stored Crop Units: %1 </t>", storageObject getVariable "storedCrops"];
};

switch (args) do 
{
	// Store all player-harvested crops.
	case "store": 
	{
		[] spawn storePlayerCrops;
	};

	// Display number of stored crops in container.
	case "checkInventory": 
	{ 
		[] spawn checkContainerCropInvenotry;
	};

	default { };
};



