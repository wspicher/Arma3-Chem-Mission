// This init file executes its code at mission start.
// Written by Andrew Spicher 08/11/2022.

test = compile preprocessFile "scripts\cocoaFarming.sqf";

// Player variables.
p1 setVariable["playerMoney", 1000];
p1 setVariable["playerHarvestedCrops", 0];
p1 setVariable["playerFarmingToolLevel", 0];
p1 setVariable["playerNumGasCans", 0];

// TODO: change where player backpack capacity values are handled so that functionality can be removed from the farming script.

