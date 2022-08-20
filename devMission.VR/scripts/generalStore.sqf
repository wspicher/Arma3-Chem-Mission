// This file contains all general store item inventory management and player funds functionality for a simple general store
// Written by Andrew Spicher 08/13/2022

// Params array from addAction ["_target", "_caller", "_actionId", "_arguments"].
// Player tool levels go 0-3.

// Params: _item = the item the player wishes to purchase
item = _this select 3;

// This helper function adds an object to the players inventory if they have the necessary space.
addPlayerInventoryItem = 
{
	params ["_playerUnit", "_itemToAdd"];

	// Check to see if the playeUnit has enough space.
	if (_playerUnit canAdd _itemToAdd) then 
	{
		// Add item to player inventory.
		_playerUnit addItem _itemToAdd;
		
	} else 
	{
		// Display inventory full error.
		["taskfailed",["","Not Enough Inventory Space."]] call BIS_fnc_showNotification;
	};
};

// This helper function handles the playerUnit backpack purchase and invenotry transfer.
addPlayerInventoryBackpack = 
{
	params ["_playerUnit", "_backpackToAdd"];

	// Check to see if the playerUnit has a backpack.
	if (backpack _playerUnit != "") then 
	{
		// Copy backpack inventory. returns array of all player backpack items
		playerCurrentBackpackItems = backpackItems _playerUnit;

	} else 
	{
		// Player isn't wearing backpack, add backpack to player inventory.
		_playerUnit addItem _backpackToAdd;
		_playerUnit assignItem _backpackToAdd;
	};
};

// Determine what inventory item the player is purchasing.
switch (key) do 
{
	// Arma objects.
	case "firstAidKit": 
	{ 

	};

	case "toolKit": 
	{

	};

	// Backpacks.
	case "messengerBagGrey": 
	{ 

	};

	case "messengerBagTan": 
	{ 

	};

	case "everydayBagBlack": 
	{ 

	};

	case "kitbagGreen": 
	{
		
	};

	case "kitbagCoyote": 
	{ 

	};

	case "carryallBagGreen": 
	{

	};

	case "carryallBagKhaki": 
	{ 

	};

	// Player farming tools.
	case "farmingTool1": 
	{ 

	};

	case "farmingTool2": 
	{ 

	};

	case "farmingTool3": 
	{ 

	};

	default { };
};

