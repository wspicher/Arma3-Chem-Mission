// This file contains all general store item inventory management and player funds functionality for a simple general store
// Written by Andrew Spicher 08/13/2022

#define firstAidKitCost 10
#define toolKitCost 20
#define messengerBagCost 35
#define everydayBagCost 50
#define kitbagCost 65
#define carryallBagCost 100
#define levelOneToolCost 75
#define levelTwoToolCost 90
#define levelThreeToolCost 120

// Params array from addAction ["_target", "_caller", "_actionId", "_arguments"].
// Params: _item = the item the player wishes to purchase.
requestedItem = _this select 3;
playerUnit = _this select 1;

// This helper function adds an object to the players inventory if they have the necessary space.
// Params: _playerUnit, _itemToAdd.
addPlayerInventoryItem = 
{
	params ["_playerUnit", "_itemToAdd"];

	// Check to see if the playeUnit has enough space.
	if (_playerUnit canAdd [_itemToAdd, 1]) then 
	{
		// Add item to player inventory.
		_playerUnit addItem _itemToAdd;	
	} else 
	{
		// Display inventory full error.
		["taskfailed",["","Not Enough Inventory Space"]] call BIS_fnc_showNotification;

		// Place purchased item on the ground by player.
		_tempItem = createVehicle[_itemToAdd, getPos _playerUnit, [], 0, "CAN_COLLIDE"];
	};
};

// This helper function handles the playerUnit backpack purchase and invenotry transfer.
// Params: _playerUnit, _backpackToAdd.
addPlayerInventoryBackpack = 
{
	params ["_playerUnit", "_backpackToAdd"];

	// Check to see if the playerUnit has a backpack.
	if (backpack _playerUnit != "") then 
	{
		// Current playerUnit backpack.
		oldPlayerBackpack = backpack _playerUnit;

		// Store old backpack items.
		oldPlayerBackpackItems = backpackItems _playerUnit;
			
		// Remove the player's old backpack.
		removeBackpack _playerUnit;

		// Add new player backpack.
		_playerUnit addBackpack _backpackToAdd;

		// Loop through old backpack items and add them to the inventory of the new backpack.
		// If player purchased a smaller backpack, place items that don't fit on the ground.
		{
			if (_playerUnit canAddItemToBackpack _x) then 
			{
				_playerUnit addItemToBackpack _x;
			} else 
			{
				// Throw item on the ground by the player.
				_temp = createVehicle[_x, getPos _playerUnit, [], 0, "CAN_COLLIDE"];
			};
		} forEach oldPlayerBackpackItems;
	} else 
	{
		// Player isn't wearing backpack, add backpack to player inventory.
		_playerUnit addBackpack _backpackToAdd;
	};
};

// This helper function handles the playerUnit farming tool purchasing functionality
// Params: _playerUnit, _toolLevel.
addPlayerFarmingTool =
{
	params ["_playerUnit", "_toolLevel"];

	switch (_toolLevel) do 
	{
		// Shovel.
		case 1:
		{ 
			_playerUnit setVariable["playerFarmingToolLevel", 1];
		};
		 
		// Woodaxe.
		case 2: 
		{ 
			_playerUnit setVariable["playerFarmingToolLevel", 2];
		};

		// Fireaxe
		case 3: 
		{ 
			_playerUnit setVariable["playerFarmingToolLevel", 3];
		};

		default { };
	};
};

// This function handles the transfer of cash between player and store.
// Params: _playerUnit, _itemPrice.
// Returns bool.
playerCanPurchaseItem = 
{
	params ["_playerUnit", "_itemPrice"];
	_currentPlayerMoney = _playerUnit getVariable "playerMoney";
	_output = false;

	if (_itemPrice < _currentPlayerMoney) then 
	{
		// Deduct item price from player.
		_newPlayerMoney = _currentPlayerMoney - _itemPrice;
		_playerUnit setVariable["playerMoney", _newPlayerMoney];
		["tasksucceeded",["","Item Purchased"]] call BIS_fnc_showNotification;
		_output = true;
	} else 
	{
		// Player unit does not have enough money, display error and return false.
		["taskFailed",["","Cannot Purchase Item, Insufficient Funds"]] call BIS_fnc_showNotification;
		_output = false;
	};

	// Return.
	_output; 
};

// This helper function initiates a player grabbing animation loop for a set period of time.
// Params: _iterations = the number of animation loop iterations.
playerGrabAnimationLoopHelper =
{
	params ["_playerUnit", "_iterations"];
	for [{_i = 0}, {_i < _iterations}, {_i = _i + 1}] do 
	{
		// Animate the player
		_playerUnit playMove "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
		// Funtion sleep
		sleep 2;
	};
};

// Determine what inventory item the player is purchasing.
switch (requestedItem) do 
{
	// Arma objects.
	case "firstAidKit": 
	{
		// Check if player can afford item.
		if ([playerUnit, firstAidKitCost] call playerCanPurchaseItem) then 
		{
			// Add item to player inventory and animate.
			[playerUnit, "Item_FirstAidKit"] spawn addPlayerInventoryItem;
			[playerUnit, 1] spawn playerGrabAnimationLoopHelper;
		};
	};

	case "toolKit": 
	{
		if ([playerUnit, toolKitCost] call playerCanPurchaseItem) then 
		{
			[playerUnit, "Item_ToolKit"] spawn addPlayerInventoryItem;
			[playerUnit, 1] spawn playerGrabAnimationLoopHelper;
		};
	};

	// Backpacks.
	case "messengerBagGrey": 
	{ 
		if ([playerUnit, messengerBagCost] call playerCanPurchaseItem) then 
		{
			[playerUnit, "B_Messenger_Gray_F"] spawn addPlayerInventoryBackpack;
			[playerUnit, 1] spawn playerGrabAnimationLoopHelper;
		};
	};

	case "messengerBagTan": 
	{ 
		if ([playerUnit, messengerBagCost] call playerCanPurchaseItem) then 
		{
			[playerUnit, "B_Messenger_Coyote_F"] spawn addPlayerInventoryBackpack;
			[playerUnit, 1] spawn playerGrabAnimationLoopHelper;
		};
	};

	case "everydayBagBlack": 
	{ 
		if ([playerUnit, everydayBagCost] call playerCanPurchaseItem) then 
		{
			[playerUnit, "B_CivilianBackpack_01_Everyday_Black_F"] spawn addPlayerInventoryBackpack;
			[playerUnit, 1] spawn playerGrabAnimationLoopHelper;
		};
	};

	case "kitbagGreen": 
	{
		if ([playerUnit, kitbagCost] call playerCanPurchaseItem) then 
		{
			[playerUnit, "B_Kitbag_rgr"] spawn addPlayerInventoryBackpack;
			[playerUnit, 1] spawn playerGrabAnimationLoopHelper;
		};
	};

	case "kitbagCoyote": 
	{ 
		if ([playerUnit, kitbagCost] call playerCanPurchaseItem) then 
		{
			[playerUnit, "B_Kitbag_cbr"] spawn addPlayerInventoryBackpack;
			[playerUnit, 1] spawn playerGrabAnimationLoopHelper;
		};
	};

	case "carryallBagGreen": 
	{
		if ([playerUnit, carryallBagCost] call playerCanPurchaseItem) then 
		{
			[playerUnit, "B_Carryall_green_F"] spawn addPlayerInventoryBackpack;
			[playerUnit, 1] spawn playerGrabAnimationLoopHelper;
		};
	};

	case "carryallBagKhaki": 
	{ 
		if ([playerUnit, carryallBagCost] call playerCanPurchaseItem) then 
		{
			[playerUnit, "B_Carryall_khk"] spawn addPlayerInventoryBackpack;
			[playerUnit, 1] spawn playerGrabAnimationLoopHelper;
		};
	};

	// Player farming tools.
	case "farmingTool1": 
	{ 
		if ([playerUnit, levelOneToolCost] call playerCanPurchaseItem) then 
		{
			[playerUnit, 1] spawn addPlayerFarmingTool;
			[playerUnit, 1] spawn playerGrabAnimationLoopHelper;
		};
	};

	case "farmingTool2": 
	{ 
		if ([playerUnit, levelTwoToolCost] call playerCanPurchaseItem) then 
		{
			[playerUnit, 2] spawn addPlayerFarmingTool;
			[playerUnit, 1] spawn playerGrabAnimationLoopHelper;
		};
	};

	case "farmingTool3": 
	{ 
		if ([playerUnit, levelThreeToolCost] call playerCanPurchaseItem) then 
		{
			[playerUnit, 3] spawn addPlayerFarmingTool;
			[playerUnit, 1] spawn playerGrabAnimationLoopHelper;
		};
	};

	default { };
};

// Store Worker commands 
// this addAction["Purchase Messenger Bag (Grey)", "scripts\generalStore.sqf", "messengerBagGrey", 1.5, true, true];
// this addAction["Purchase Messenger Bag (Coyote)", "scripts\generalStore.sqf", "messengerBagTan", 1.5, true, true];
// this addAction["Purchase Everyday Backpack (Black)", "scripts\generalStore.sqf", "everydayBagBlack", 1.5, true, true];
// this addAction["Purchase Kitbag (Olive Green)", "scripts\generalStore.sqf", "kitbagGreen", 1.5, true, true];
// this addAction["Purchase Kitbag (Coyote)", "scripts\generalStore.sqf", "kitbagCoyote", 1.5, true, true];
// this addAction["Purchase Carryall Bag (Olive Green)", "scripts\generalStore.sqf", "carryallBagGreen", 1.5, true, true];
// this addAction["Purchase Carryall Bag (Khaki)", "scripts\generalStore.sqf", "carryallBagKhaki", 1.5, true, true];