//Bern City Bitches
//by Peschmae
//November 2014
//With help from Neuron & dietermoreno
 
void main(void){ 

	rmSetStatusText("Welcome to Bern",0.01);
	
	rmSetMapSize(800, 800);
	
	rmSetLightingSet("Great Lakes");	
	
	rmSetMapElevationParameters(cElevTurbulence, 0.05, 1, 0.8, 2.0);
	rmSetMapElevationHeightBlend(2);
	
	// Picks a default water height
	rmSetSeaLevel(1.0); // this is height of river surface compared to surrounding land. River depth is in the river XML.
	
	rmEnableLocalWater(true);
	rmTerrainInitialize("great_lakes\ground_grass1_gl", 1.0);
	rmSetMapType("greatlakes");
	rmSetMapType("grass");
	rmSetMapType("water");

	string forestType = "great lakes forest";
	string forestTypeAlt = "new england forest";
	string startTreeType = "TreeNewEngland";
	int numberOfForests = 5;
	
	string huntable = "cow";

	rmSetWorldCircleConstraint(true);

	int classPlayer=rmDefineClass("player");
	rmDefineClass("classHill");
	rmDefineClass("classPatch");
	rmDefineClass("starting settlement");
	rmDefineClass("startingUnit");
	rmDefineClass("classForest");
	rmDefineClass("importantItem");
	rmDefineClass("natives");
	rmDefineClass("classCliff");
	rmDefineClass("secrets");
	rmDefineClass("nuggets");
	rmDefineClass("center");
	rmDefineClass("tradeIslands");
	int classGreatLake=rmDefineClass("great lake");

	rmSetStatusText("Welcome to Bern", 0.10);
 
// ************************* DEFINE CONSTRAINTS **************************
	// ------------- general constraints
	int playerEdgeConstraint=rmCreateBoxConstraint("player edge of map", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10), 0.01);
	int longPlayerEdgeConstraint=rmCreateBoxConstraint("long avoid edge of map", rmXTilesToFraction(20), rmZTilesToFraction(20), 1.0-rmXTilesToFraction(20), 1.0-rmZTilesToFraction(20), 0.01);
	int centerConstraint=rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), 30.0);
	int centerConstraintFar=rmCreateClassDistanceConstraint("stay away from center far", rmClassID("center"), 60.0);
	int circleConstraint=rmCreatePieConstraint("circle Constraint", 0.5, 0.5, 0, rmZFractionToMeters(0.47), rmDegreesToRadians(0), rmDegreesToRadians(360));
	int Northward=rmCreatePieConstraint("northMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(315), rmDegreesToRadians(135));
	int Southward=rmCreatePieConstraint("southMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(135), rmDegreesToRadians(315));
	int Eastward=rmCreatePieConstraint("eastMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(45), rmDegreesToRadians(225));
	int Westward=rmCreatePieConstraint("westMapConstraint", 0.5, 0.5, 0, rmZFractionToMeters(0.5), rmDegreesToRadians(225), rmDegreesToRadians(45));
	int playerConstraintForest=rmCreateClassDistanceConstraint("forests kinda stay away from players", classPlayer, 20.0);
	int longPlayerConstraint=rmCreateClassDistanceConstraint("land stays away from players", classPlayer, 70.0);  
	int mediumPlayerConstraint=rmCreateClassDistanceConstraint("medium stay away from players", classPlayer, 40.0);  
	int playerConstraint=rmCreateClassDistanceConstraint("stay away from players", classPlayer, 45.0);
	int shortPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players short", classPlayer, 20.0);
	int avoidTradeIslands=rmCreateClassDistanceConstraint("stay away from trade islands", rmClassID("tradeIslands"), 40.0);
	int smallMapPlayerConstraint=rmCreateClassDistanceConstraint("stay away from players a lot", classPlayer, 70.0);

	int topConstraint=rmCreateBoxConstraint("stay on top of map", 0, .65, 1, 1);
	int bottomConstraint=rmCreateBoxConstraint("stay on bottom of map", 0, 0, 1, .35);
	int middleConstraint=rmCreateBoxConstraint("stay in middle of map", 0, .35, 1, .65);

	// Nature avoidance
	// int fishVsFishID=rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);

	int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
	int forestConstraintNear=rmCreateClassDistanceConstraint("forest vs. forest near", rmClassID("classForest"), 20.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest vs. forest", rmClassID("classForest"), 40.0);
	int forestConstraintFar=rmCreateClassDistanceConstraint("forest vs. forest far", rmClassID("classForest"), 80.0);
	int avoidResource=rmCreateTypeDistanceConstraint("resource avoid resource", "resource", 20.0);
	int avoidCoin=rmCreateTypeDistanceConstraint("avoid coin", "Mine", 40.0);
	int shortAvoidCoin=rmCreateTypeDistanceConstraint("short avoid coin", "gold", 10.0);
	int avoidStartResource=rmCreateTypeDistanceConstraint("start resource no overlap", "resource", 10.0);

	// Avoid impassable land
	int avoidImpassableLand=rmCreateTerrainDistanceConstraint("avoid impassable land", "Land", false, 6.0);
	int shortAvoidImpassableLand=rmCreateTerrainDistanceConstraint("short avoid impassable land", "Land", false, 2.0);
	int longAvoidImpassableLand=rmCreateTerrainDistanceConstraint("long avoid impassable land", "Land", false, 10.0);
	int hillConstraint=rmCreateClassDistanceConstraint("hill vs. hill", rmClassID("classHill"), 10.0);
	int shortHillConstraint=rmCreateClassDistanceConstraint("patches vs. hill", rmClassID("classHill"), 5.0);
	int patchConstraint=rmCreateClassDistanceConstraint("patch vs. patch", rmClassID("classPatch"), 5.0);
	int avoidCliffs=rmCreateClassDistanceConstraint("cliff vs. cliff", rmClassID("classCliff"), 30.0);
	int avoidWater4 = rmCreateTerrainDistanceConstraint("avoid water", "Land", false, 4.0);
	int avoidWater20 = rmCreateTerrainDistanceConstraint("avoid water medium", "Land", false, 20.0);
	int nearShore=rmCreateTerrainMaxDistanceConstraint("near shore", "water", false, 15.0);

	// Unit avoidance
	int avoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units", rmClassID("startingUnit"), 45.0);
	int shortAvoidStartingUnits=rmCreateClassDistanceConstraint("objects avoid starting units short", rmClassID("startingUnit"), 10.0);
	int avoidImportantItem=rmCreateClassDistanceConstraint("secrets etc avoid each other", rmClassID("importantItem"), 10.0);
	int avoidNatives=rmCreateClassDistanceConstraint("stuff avoids natives", rmClassID("natives"), 30.0);
	int avoidSecrets=rmCreateClassDistanceConstraint("stuff avoids secrets", rmClassID("secrets"), 20.0);
	int avoidNuggets=rmCreateClassDistanceConstraint("stuff avoids nuggets", rmClassID("nuggets"), 60.0);
	int deerConstraint=rmCreateTypeDistanceConstraint("avoid the deer", "deer", 40.0);
	int shortNuggetConstraint=rmCreateTypeDistanceConstraint("avoid nugget objects", "AbstractNugget", 7.0);
	int shortDeerConstraint=rmCreateTypeDistanceConstraint("short avoid the deer", "deer", 20.0);
	int mooseConstraint=rmCreateTypeDistanceConstraint("avoid the moose", "moose", 40.0);
	int avoidSheep=rmCreateTypeDistanceConstraint("sheep avoids sheep", "sheep", 40.0);

	// Decoration avoidance
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

	// Trade route avoidance.
	int avoidTradeRoute = rmCreateTradeRouteDistanceConstraint("trade route", 5.0);
	int shortAvoidTradeRoute = rmCreateTradeRouteDistanceConstraint("short trade route", 3.0);
	int avoidTradeRouteFar = rmCreateTradeRouteDistanceConstraint("trade route far", 20.0);
	int avoidTradeSockets = rmCreateTypeDistanceConstraint("avoid trade sockets", "sockettraderoute", 10.0);
	int farAvoidTradeSockets = rmCreateTypeDistanceConstraint("far avoid trade sockets", "sockettraderoute", 40.0);
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
	int HCspawnLand = rmCreateTerrainDistanceConstraint("HC spawn away from land", "land", true, 12.0);

	rmSetStatusText("Constraints loaded", 0.15);
	
// ************************* PLACE TRADE ROUTES **************************

	int tradeRouteID = rmCreateTradeRoute();
 
	rmAddTradeRouteWaypoint(tradeRouteID, 0.6, 1.0 ); // Entry point
	
	rmAddTradeRouteWaypoint(tradeRouteID, 0.52, 0.84 ); // Waypoint 1 (shallow at river)
	rmAddTradeRouteWaypoint(tradeRouteID, 0.4, 0.7 ); // Waypoint 2 (on the island)
	rmAddTradeRouteWaypoint(tradeRouteID, 0.23, 0.5); // Waypoint 3 (shallow at river)
	
	rmAddTradeRouteWaypoint(tradeRouteID, 0.0, 0.1); // Exit point
	
    rmBuildTradeRoute(tradeRouteID, "dirt");
	
	// initialize trade post socket
	int socketID=rmCreateObjectDef("sockets to dock Trade Posts");
	rmAddObjectDefItem(socketID, "SocketTradeRoute", 1, 0.0);
	rmSetObjectDefAllowOverlap(socketID, true);
	rmAddObjectDefToClass(socketID, rmClassID("importantItem"));
	rmSetObjectDefMinDistance(socketID, 0.0);
	rmSetObjectDefMaxDistance(socketID, 6.0);
	
	// Trade stations are going to be added, after the river is drawn
	// this is to ensure, that trade stations don't get erased by the river
	
 
// ************************* PLACE THE RIVER **************************


	int rivermin = 5;
	int rivermax = 5;
	int riverPlacement = -1;
	int riverWiggle = 5;
	int aare = rmRiverCreate(riverPlacement, "Great Lakes", 2, riverWiggle, rivermin, rivermax); 

	rmSetStatusText("Creating Aare",0.20);

	rmRiverAddWaypoint(aare, 0.0, 0.44); // Start

	rmRiverAddWaypoint(aare, 0.22, 0.58); // Waypoint 1
	rmRiverAddWaypoint(aare, 0.32, 0.55); // Waypoint 2
	rmRiverAddWaypoint(aare, 0.52, 0.35); // Waypoint 3
	rmRiverAddWaypoint(aare, 0.68, 0.31); // Waypoint 4
	rmRiverAddWaypoint(aare, 0.81, 0.41); // Waypoint 5
	rmRiverAddWaypoint(aare, 0.75, 0.55); // Waypoint 6
	rmRiverAddWaypoint(aare, 0.58, 0.68); // Waypoint 7
	rmRiverAddWaypoint(aare, 0.5, 0.85); // Waypoint 8

	rmRiverAddWaypoint(aare, 0.5, 1.0); // End
	
	rmRiverSetShallowRadius(aare, 6+cNumberNonGaiaPlayers);
	rmRiverAddShallow(aare, 0.1);
	rmRiverAddShallow(aare, 0.19);
	rmRiverAddShallow(aare, 0.35);
	rmRiverAddShallow(aare, 0.5);
	rmRiverAddShallow(aare, 0.7);
	rmRiverAddShallow(aare, 0.9);

	rmRiverSetBankNoiseParams(aare, 0.07, 2, 1.5, 20.0, 0.667, 3.0);
	rmRiverBuild(aare);
	
	rmRiverReveal(aare, 2); 

	rmSetStatusText("Aare complete", 0.30);
	
// ************* TRADE STATIONS*********************
	// have to be added after the river was drawn, due to collision issues
	rmSetObjectDefTradeRouteID(socketID, tradeRouteID);
	vector socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.03);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	
	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.36);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);

	socketLoc = rmGetTradeRouteWayPoint(tradeRouteID, 0.8);
	rmPlaceObjectDefAtPoint(socketID, 0, socketLoc);
	
// ************************* PLACE THE MOUNTAINS **************************

	int gurtenBotId=rmCreateArea("Gurten Bot");
	rmSetAreaSize(gurtenBotId, 0.1, 0.06);
	rmSetAreaLocation(gurtenBotId, 0.2, 0.9);
	rmSetAreaBaseHeight(gurtenBotId, 4.0);	
	rmAddAreaInfluencePoint(gurtenBotId, 0.2, 1.0);
	rmSetAreaObeyWorldCircleConstraint(gurtenBotId, false);
	rmSetAreaSmoothDistance(gurtenBotId, 100);
	rmSetAreaCoherence(gurtenBotId, 0.9);
	
	// highlights the area, but the forest has to be removed to make it work
	// for debugging purposes only
	//rmSetAreaTerrainType(gurtenBotId, "great_lakes\ground_ice1_gl");
	
	rmSetAreaForestType(gurtenBotId, forestType);
	rmAddAreaToClass(gurtenBotId, rmClassID("classForest")); 
	rmSetAreaForestDensity(gurtenBotId, 0.9);
	rmSetAreaForestClumpiness(gurtenBotId, 0.1);
	rmSetAreaForestUnderbrush(gurtenBotId, 0.4);
	rmSetAreaCoherence(gurtenBotId, 0.8);
	
	rmBuildArea(gurtenBotId);
	
	int gurtenTopId=rmCreateArea("Gurten Top");
	rmSetAreaSize(gurtenTopId, 0.03, 0.03);
	rmSetAreaLocation(gurtenTopId, 0.17, 0.9);
	
	rmSetAreaBaseHeight(gurtenTopId, 6.0);
	rmSetAreaObeyWorldCircleConstraint(gurtenTopId, false);
	rmSetAreaSmoothDistance(gurtenTopId, 80);
	rmSetAreaCoherence(gurtenTopId, 0.8);
	
	rmSetAreaForestType(gurtenTopId, forestTypeAlt);
	rmAddAreaToClass(gurtenTopId, rmClassID("classForest")); 
	rmSetAreaForestDensity(gurtenTopId, 0.8);
	rmSetAreaForestClumpiness(gurtenTopId, 0.1);
	rmSetAreaForestUnderbrush(gurtenTopId, 0.4);
	rmSetAreaCoherence(gurtenTopId, 0.8);
	
	rmBuildArea(gurtenTopId);
	
// ************************* PLACE THE STARTING AREAS **************************

	// Define players starting locations
	// should be done with rmPlacePlayerCircular, but twice, once for each team just to make sure, that 8 players are possible
	// the map will only allow 2 vs 6 in 2 teams, or FFA
	rmPlacePlayer(1, 0.15, 0.65); // Player 1
	rmPlacePlayer(2, 0.38, 0.78); // Player 2
	rmPlacePlayer(3, 0.45, 0.15); // Player 3
	rmPlacePlayer(4, 0.8, 0.7); // Player 4

	rmSetStatusText("starting locations generated",0.40);

	// Use a loop to create an area for each player
	for(i=1; <cNumberPlayers) { 

		// Create players' areas
		int id=rmCreateArea("Player"+i); 
		// Assign to player
		rmSetPlayerArea(i, id); 
		// Set the size
		rmSetAreaSize(id, rmAreaTilesToFraction(100), rmAreaTilesToFraction(100)); 
		
		rmAddAreaConstraint(id, longPlayerConstraint);
		//rmAddAreaConstraint(id, avoidImportantItem);
		rmAddAreaConstraint(id, avoidWater20);
		
		rmSetAreaCoherence(id, 1.0);
	}

	rmBuildAllAreas();

	rmSetStatusText("Settlements Built",0.5);
	
// ************************* STARTING UNITS, TOWN CENTER & RESOURCES **************************

	// Define starting units for players 
	// (explorers, dogs, scouts, orchards are included here, depending on each civ's starting units)
	int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
	rmAddObjectDefConstraint(startingUnits, avoidWater4);
	rmAddObjectDefConstraint(startingUnits, avoidImpassableLand);

	// some trees near the starting area
	int StartAreaTreeID=rmCreateObjectDef("starting trees");
	rmAddObjectDefItem(StartAreaTreeID, startTreeType, 8, 8.0);
	rmSetObjectDefMinDistance(StartAreaTreeID, 21);
	rmSetObjectDefMaxDistance(StartAreaTreeID, 24);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidStartResource);
	rmAddObjectDefConstraint(StartAreaTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidTradeRoute);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidImportantItem);
	rmAddObjectDefConstraint(StartAreaTreeID, avoidNatives);

	// 4 berry bushes to provide some nutrition
	int StartBerriesID=rmCreateObjectDef("starting berries");
	rmAddObjectDefItem(StartBerriesID, "berrybush", 3, 5.0);
	rmSetObjectDefMinDistance(StartBerriesID, 10);
	rmSetObjectDefMaxDistance(StartBerriesID, 20);
	rmAddObjectDefConstraint(StartBerriesID, avoidStartResource);
	rmAddObjectDefConstraint(StartBerriesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(StartBerriesID, avoidNatives);
	rmAddObjectDefConstraint(StartBerriesID, avoidImportantItem);
	rmAddObjectDefConstraint(StartBerriesID, avoidTradeRoute);

	// a silver mine, to make sure the players got some starting gold
	int startSilverID = rmCreateObjectDef("player silver");
	rmAddObjectDefItem(startSilverID, "mine", 1, 0);
	rmSetObjectDefMinDistance(startSilverID, 12.0);
	rmSetObjectDefMaxDistance(startSilverID, 20.0);
	rmAddObjectDefConstraint(startSilverID, avoidImpassableLand);
	rmAddObjectDefConstraint(startSilverID, avoidImportantItem);
	rmAddObjectDefConstraint(startSilverID, avoidTradeRoute);
	rmAddObjectDefConstraint(startSilverID, avoidNatives);
	rmAddObjectDefConstraint(startSilverID, avoidAll);

	rmSetStatusText("Starting Units loaded",0.6);

	// Use a loop to give them a town center and the starting units
	for(i=1; <cNumberPlayers) {
	 
		// Define town centers
		int TCID = rmCreateObjectDef("Player TC"+i); 
		if (rmGetNomadStart()){
			rmAddObjectDefItem(TCID, "CoveredWagon", 1, 0.0);
		} else {
			rmAddObjectDefItem(TCID, "townCenter", 1, 0.0);
		}
		rmAddObjectDefConstraint(TCID, shortAvoidImpassableLand);
		rmAddObjectDefConstraint(TCID, avoidWater4);
		rmAddObjectDefToClass(TCID, rmClassID("player"));
	 
		// Place town centers
		rmPlaceObjectDefAtLoc(TCID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i)); 
		
		// Place starting units & resources
		rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartAreaTreeID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(StartBerriesID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
		rmPlaceObjectDefAtLoc(startSilverID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
	}

	rmSetStatusText("Settlements complete",0.7);
	
// ************************* FORESTS **************************
	int forestID=rmCreateArea("forest fix");
	rmSetAreaWarnFailure(forestID, false);
	rmSetAreaSize(forestID, 0.05, 0.025);
	rmSetAreaForestType(forestID, forestType);
	rmAddAreaToClass(forestID, rmClassID("classForest")); 
	rmSetAreaForestDensity(forestID, 0.9);
	rmSetAreaForestClumpiness(forestID, 0.1);
	rmSetAreaForestUnderbrush(forestID, 0.4);
	rmSetAreaCoherence(forestID, 0.7);
	rmSetAreaLocation(forestID, 0.55, 0.55);
	rmAddAreaConstraint(forestID, playerConstraint);
	rmAddAreaConstraint(forestID, playerConstraintForest);
	rmAddAreaConstraint(forestID, avoidImportantItem);
	rmAddAreaConstraint(forestID, avoidTradeRoute);
	rmBuildArea(forestID);

	// Forests
	for(i=0; <numberOfForests) {
		forestID=rmCreateArea("foresta"+i);
		rmSetAreaWarnFailure(forestID, false);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(350), rmAreaTilesToFraction(400));
		
		if (i % 2 == 0) {
			rmSetAreaForestType(forestID, forestType);	
		} else {
			rmSetAreaForestType(forestID, forestTypeAlt);
		}
		
		rmAddAreaToClass(forestID, rmClassID("classForest")); 
		rmSetAreaForestDensity(forestID, 0.8);
		rmSetAreaForestClumpiness(forestID, 0.1);
		rmSetAreaForestUnderbrush(forestID, 0.4);
		rmSetAreaCoherence(forestID, 0.7);
		rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
		rmAddAreaConstraint(forestID, forestConstraintFar);
		rmAddAreaConstraint(forestID, playerConstraintForest);
		rmAddAreaConstraint(forestID, playerConstraint);
		rmAddAreaConstraint(forestID, centerConstraintFar);
		rmAddAreaConstraint(forestID, avoidResource); 
		rmAddAreaConstraint(forestID, avoidImportantItem);
		rmAddAreaConstraint(forestID, avoidTradeRoute);
		rmAddAreaConstraint(forestID, avoidAll);
	}
	rmBuildAllAreas();

	// RANDOM TREES
   int count = 0;
   int maxCount = 20 * cNumberNonGaiaPlayers;
   int maxFailCount = 10 * cNumberNonGaiaPlayers;
   int failCount = 0;
   for(i=1; <10) {
		int treeArea = rmCreateArea("forestb"+i);
		rmSetAreaSize(treeArea, 0.001, 0.003);
		
		if (i % 2 == 0) {
			rmSetAreaForestType(treeArea, forestType);	
		} else {
			rmSetAreaForestType(treeArea, forestTypeAlt);
		}
		
		rmSetAreaForestDensity(treeArea, 0.8);
		rmSetAreaForestClumpiness(treeArea, 0.1);
		rmAddAreaConstraint(treeArea, shortAvoidImpassableLand);
		rmAddAreaConstraint(treeArea, forestConstraintNear);
		rmAddAreaConstraint(treeArea, playerConstraintForest);
		rmAddAreaConstraint(treeArea, avoidImportantItem);
		rmAddAreaConstraint(treeArea, avoidTradeRoute);
		rmAddAreaConstraint(treeArea, avoidAll);
		rmAddAreaToClass(treeArea, rmClassID("classForest"));
		rmSetAreaWarnFailure(treeArea, false);
		bool ok = rmBuildArea(treeArea);
		if(ok) {
			count++;
			if(count > maxCount)
			break;
		} else {
			failCount++;
			if(failCount > maxFailCount)
			break;
		}
   }
   
   rmSetStatusText("Forests generated",0.8);
   
// ************************* Mines **************************

   // Gold mines top
	int goldMinesTopId = rmCreateObjectDef("Gold mines top");
	rmAddObjectDefItem(goldMinesTopId, "minegold", 1, 0.0);
	rmSetObjectDefMinDistance(goldMinesTopId, 0.0);
	rmSetObjectDefMaxDistance(goldMinesTopId, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(goldMinesTopId, avoidImpassableLand);
	rmAddObjectDefConstraint(goldMinesTopId, playerConstraint);
	rmAddObjectDefConstraint(goldMinesTopId, avoidWater4);
	rmAddObjectDefConstraint(goldMinesTopId, topConstraint);
	rmAddObjectDefConstraint(goldMinesTopId, avoidCoin);
	rmAddObjectDefConstraint(goldMinesTopId, avoidImportantItem);
	rmAddObjectDefConstraint(goldMinesTopId, avoidTradeRoute);
	rmPlaceObjectDefPerPlayer(goldMinesTopId, false, 2);

	// Gold mines middle
	int goldMinesMidId = rmCreateObjectDef("Gold mines middle");
	rmAddObjectDefItem(goldMinesMidId, "minegold", 1, 0.0);
	rmSetObjectDefMinDistance(goldMinesMidId, 0.0);
	rmSetObjectDefMaxDistance(goldMinesMidId, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(goldMinesMidId, avoidImpassableLand);
	rmAddObjectDefConstraint(goldMinesMidId, playerConstraint);
	rmAddObjectDefConstraint(goldMinesMidId, avoidWater4);
	rmAddObjectDefConstraint(goldMinesMidId, middleConstraint);
	rmAddObjectDefConstraint(goldMinesMidId, avoidCoin);
	rmAddObjectDefConstraint(goldMinesMidId, avoidImportantItem);
	rmAddObjectDefConstraint(goldMinesMidId, avoidTradeRoute);
	rmPlaceObjectDefPerPlayer(goldMinesMidId, false, 2);

	// Gold mines bottom
	int goldMinesBotId = rmCreateObjectDef("Gold mines bottom");
	rmAddObjectDefItem(goldMinesBotId, "minegold", 1, 0.0);
	rmSetObjectDefMinDistance(goldMinesBotId, 0.0);
	rmSetObjectDefMaxDistance(goldMinesBotId, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(goldMinesBotId, avoidImpassableLand);
	rmAddObjectDefConstraint(goldMinesBotId, playerConstraint);
	rmAddObjectDefConstraint(goldMinesBotId, avoidWater4);
	rmAddObjectDefConstraint(goldMinesBotId, bottomConstraint);
	rmAddObjectDefConstraint(goldMinesBotId, avoidCoin);
	rmAddObjectDefConstraint(goldMinesBotId, avoidImportantItem);
	rmAddObjectDefConstraint(goldMinesBotId, avoidTradeRoute);
	rmPlaceObjectDefPerPlayer(goldMinesBotId, false, 2);	
	
	rmSetStatusText("Gold spawned",0.85);

// ************************* Animals **************************
	
	// 'huntable' cows
	int huntableID=rmCreateObjectDef("huntable");
	rmAddObjectDefItem(huntableID, huntable, rmRandInt(5,7), 6.0);
	rmSetObjectDefCreateHerd(huntableID, true);
	rmSetObjectDefMinDistance(huntableID, 0.0);
	rmSetObjectDefMaxDistance(huntableID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(huntableID, avoidResource);
	rmAddObjectDefConstraint(huntableID, shortPlayerConstraint);
	rmAddObjectDefConstraint(huntableID, avoidImpassableLand);
	rmAddObjectDefConstraint(huntableID, forestObjConstraint);
	rmAddObjectDefConstraint(huntableID, avoidImportantItem);
	rmAddObjectDefConstraint(huntableID, avoidTradeRoute);
	
	rmPlaceObjectDefAtLoc(huntableID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers);
	
	rmSetStatusText("Animals spawned",0.9);

	//Text
	rmSetStatusText("Loading finished. Enjoy!",1.0);
 
}