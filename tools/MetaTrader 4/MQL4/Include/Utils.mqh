/*
A few functions which get used over and over again.
*/

int TimeframeDescToMinutes(string xxx)
   {
   if( xxx == "M1" )   return(PERIOD_M1);
   if( xxx == "M5" )   return(PERIOD_M5);
   if( xxx == "M15" )  return(PERIOD_M15);
   if( xxx == "M30" )  return(PERIOD_M30);
   if( xxx == "H1" )   return(PERIOD_H1);
   if( xxx == "H4" )   return(PERIOD_H4);
   if( xxx == "D1" )   return(PERIOD_D1);
   if( xxx == "W1" )   return(PERIOD_W1);
   if( xxx == "MN" )   return(PERIOD_MN1);
   
   return(-1);
   }


// COMPARISONS OF DOUBLES (accurate to 6 decimal places)

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bool IsNE( double a, double b ) {
   return( MathAbs(a-b) > 0.0000005 );}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
bool IsGT( double a, double b ) {
   return( (a-b) > 0.0000005 );}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
bool IsLT( double a, double b ) {
   return( (b-a) > 0.0000005 );}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
bool IsGE( double a, double b ) {
   return( (a-b) > -0.0000005 );}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



// Remove objects with obj_string in their name
// ============================================
void RemoveObjects(string obj_string)
   {
	for (int i = ObjectsTotal(); i >= 0; i--)
      {
		string objname = ObjectName(i);
		if (StringFind(objname, obj_string, 0) > -1) ObjectDelete(objname);
      }
   return;
   }
   

