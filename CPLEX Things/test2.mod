/*********************************************
 * OPL 20.1.0.0 Model
 * Author: tahor
 * Creation Date: Feb 7, 2022 at 9:48:40 PM
 *********************************************/
 
 tuple ZoneFacilityPair {
	int zone;
	int facility;
	float allocationValue;
}
 
 float lambda = ...;
 float gamma = ...;
 float Aij = ...;
 int NodeCount = ...;
 int FacilityCount = ...;
 range Nodes = 1..NodeCount;
 range Facilities = 1..FacilityCount;
 float ZonePopulationPercentage[Nodes] = ...;
 ZoneFacilityPair ZoneToFacilityAllocations[Nodes] = ...;
 float ZoneToFacilityArray[Nodes] = ...;
 float GivenTable[Nodes][Facilities]= ...;
 
 dvar int Xij[Nodes][Facilities];


 maximize 
 	lambda * (sum(i in Nodes) 
 		ZonePopulationPercentage[i] * (sum(j in Facilities)
 			(maxl(Aij-gamma*GivenTable[i][j], 0)) * Xij[i][j]
 		)
 	);
 	
 subject to {
   forall(i in Nodes)
   	  EachClientZoneHasFacility: (sum(j in Facilities) Xij[i][j]) == 1;
   forall(i in Nodes) forall(j in Facilities)
   	  DecisionVariablesAreBoolean: Xij[i][j] == 0 || Xij[i][j] == 1;
   
 }
 	