/*********************************************
 * OPL 20.1.0.0 Model
 * Author: tahor
 * Creation Date: Feb 7, 2022 at 9:11:59 PM
 *********************************************/
 
 dvar float x;
 dvar float y;
float fencing=200;

 maximize x*(fencing-2*x);
 
 subject to {
   constr1: (2 * x) + y == fencing;
 } 