// This function handles the player farming mechanics.
// The number of crops the player can hold is determined by the player's current backpack.
// The efficiency of the crop harvesting is determined by the player's current farming tool level.
// Written by Andrew Spicher 08/11/2022

#define noBackpackCapacity 5
#define messengerBagCapacity 15
#define everydayBagCapacity 25
#define kitbagCapacity 35
#define carryallBagCapacity 50



// Get player tool level.
_playerFarmingToolLevel = p1 getVariable "playerFarmingToolLevel";


// This helper function initiates a player grabbing animation loop for a set period of time.
// Params: _iterations = the number of animation loop iterations.
playerGrabAnimationLoopHelper =
{
	params ["_iterations"];
	for [{_i = 0}, {_i < _iterations}, {_i = _i + 1}] do 
	{
		// Animate the player
		p1 playMove "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
		// Funtion sleep
		sleep 2;
	};
};

// This helper function returns the available backpack capacity for a player's current backpack.
// Params: _player = the player to check.
playerBackpackCapacityCheck = 
{
	params ["_player"];

	// Perform a backpack check on the player.
	_playerBackpack = backpack _player;

	// Default capacity.
	_playerBackpackCapacity = noBackpackCapacity;

	// Check playerBackpack class names to determine appropriate size
	switch (_playerBackpack) do 
	{
		// Messenger bags.
		case "B_Messenger_Gray_F": 
		{ 
			_playerBackpackCapacity = messengerBagCapacity;
		};

		case "B_Messenger_Coyote_F": 
		{ 
			_playerBackpackCapacity = messengerBagCapacity;
		};

		// Everyday bag.
		case "B_CivilianBackpack_01_Everyday_Black_F": 
		{ 
			_playerBackpackCapacity = everydayBagCapacity;
		};

		// Kit bags.
		case "B_Kitbag_rgr": 
		{ 
			_playerBackpackCapacity = kitbagCapacity;
		};

		case "B_Kitbag_cbr": 
		{ 
			_playerBackpackCapacity = kitbagCapacity;
		};
		
		// Carryall bags.
		case "B_Carryall_green_F": 
		{ 
			_playerBackpackCapacity = carryallBagCapacity;
		};

		case "B_Carryall_khk": 
		{ 
			_playerBackpackCapacity = carryallBagCapacity;
		};
		default { };
	};

	// Return calculated backpack capacity.
	_playerBackpackCapacity;
};

// This helper function check how much backpack capacity the player has and adds the appropriate number of harvested crops to his inventory.
// Params: _cropsToadd = the number of harvested crops to attempt to store in the player's crop inventory.
addPlayerHarvestedCrops = 
{
	params ["_cropsToAdd", "_toolLevel"];

	// Perform backpack capacity check.
	_playerBackpackCapacity = p1 call playerBackpackCapacityCheck;

	// Get the player's current crop inventory.
	_playerHarvestedCrops = p1 getVariable "playerHarvestedCrops";

	// Check the the player's harvested crops against backpack capacity
	if (_playerHarvestedCrops < _playerBackpackCapacity) then //if there is room in the backpack
	{
		// Add harvested crops to player inventory.
		for [{_i = 0}, {_i < _cropsToAdd}, {_i = _i + 1}] do 
		{
			if (_playerHarvestedCrops < _playerBackpackCapacity) then 
			{
				_playerHarvestedCrops = _playerHarvestedCrops + 1;
			};
		};
		
		// Update player crop inventory level.
		p1 setVariable["playerHarvestedCrops", _playerHarvestedCrops];

		// Trigger appropriate animation.
		switch (_toolLevel) do 
		{
			// No tools.
			case 0: 
			{ 
				5 spawn playerGrabAnimationLoopHelper;				
			};
			// Level 1 tools.
			case 1: 
			{ 
				4 spawn playerGrabAnimationLoopHelper;
			};

			// Level 2 tools.
			case 2: 
			{ 
				3 spawn playerGrabAnimationLoopHelper;
			};

			//Level 3 tools.
			case 3: 
			{ 
				2 spawn playerGrabAnimationLoopHelper;
			};
			default { };
		};
	} else 
	{
		// Player crop inventory full, display message.
		["taskFailed",["","Cannot Colllect Crops, Inventory Full."]] call BIS_fnc_showNotification;
	};
};

// Determine the efficiency of the collection process.
switch (_playerFarmingToolLevel) do 
{
	// No tools.
	case 0: 
	{
		// Add crops to player inventory.
		[5,0] spawn addPlayerHarvestedCrops;
	};

	// Level 1 tools.
	case 1: 
	{
		// Add crops to player inventory.
		[10,1] spawn addPlayerHarvestedCrops;
	};

	// Level 2 tools.
	case 2: 
	{
		// Add crops to player inventory.
		[15,2] spawn addPlayerHarvestedCrops;
	};

	// Level 3 tools.
	case 3: 
	{
		// Add crops to player inventory.
		[20,3] spawn addPlayerHarvestedCrops;
	};

	default { };
};