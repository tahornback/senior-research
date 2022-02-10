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
 int MaxServersAtFacility = ...; /* matching TotalAvailableServers for now */
 int TotalAvailableServers = ...;
 int MaxWaitTime = ...; /* hours */
 int Mu = ...; /* clients per hour */
 int M3 = ...; /* "big number" */
 float MinFacilityWorkload = ...; /* clients per hour */
 range Nodes = 1..NodeCount;
 range Facilities = 1..FacilityCount;
 range Servers = 1..MaxServersAtFacility;
 float ZonePopulationPercentage[Nodes] = ...;
 ZoneFacilityPair ZoneToFacilityAllocations[Nodes] = ...;
 float ZoneToFacilityArray[Nodes] = ...;
 float GivenTable[Nodes][Facilities]= ...;
 float DeltaLambdaK[Servers] = ...;
 
 dvar int Xij[Nodes][Facilities]; /* clients from zone i require service from node j */
 dvar int Sjk[Facilities][Servers]; /* node j has k or nore servers */


 maximize /* Equation 20 */
 	lambda * (sum(i in Nodes) 
 		ZonePopulationPercentage[i] * (sum(j in Facilities)
 			(maxl(Aij-gamma*GivenTable[i][j], 0)) * Xij[i][j]
 		)
 	);
 	
 subject to {
   forall(i in Nodes)
   	  EachClientZoneHasFacility: (sum(j in Facilities) Xij[i][j]) == 1; /* Equation 21 */
   forall(i in Nodes) forall(j in Facilities)
   	  XijBoolean: Xij[i][j] == 0 || Xij[i][j] == 1; /* Equation 26, part a */
   forall(j in Facilities) forall(k in Servers)
   	  SjkBoolean: Sjk[j][k] == 0 || Sjk[j][k] == 1; /* Equation 26, part b */
   forall(i in Nodes) forall(j in Facilities)
   	  ClientsCanOnlyVisitOpenFacilities: Xij[i][j] <= Sjk[j][1]; /* Equation 22 */
   forall(i in Nodes) forall(j in Facilities) forall(p in Facilities)
   	  ClientsChooseClosestFacility: /* Equation 23 */
   	  	GivenTable[i][j]*Xij[i][j] <= GivenTable[i][p] + M3 * (1-Sjk[p][1]); 
   forall(j in Facilities)
      OpenFacilityMaintainsMinimumWorkload: /* Equation 24 */
      	lambda * (sum(i in Nodes) 
	 		ZonePopulationPercentage[i] * (sum(j in Facilities)
	 			(maxl(Aij-gamma*GivenTable[i][j], 0)) * Xij[i][j]
 			)) >= MinFacilityWorkload*Sjk[j][1];
   forall(j in Facilities)
      OpenFacilityLessThanMaxWait: /* Equation 25 */
      	lambda * (sum(i in Nodes) 
	 		ZonePopulationPercentage[i] * (sum(j in Facilities)
	 			(maxl(Aij-gamma*GivenTable[i][j], 0)) * Xij[i][j]
 			)) <= sum(k in Servers) DeltaLambdaK[k] * Sjk[j][k];
 }
 	