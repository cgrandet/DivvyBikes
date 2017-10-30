namespace java edu.uchicago.mpcs53013.DivvyTrips

struct DivvyTrips {
	1: required i64 tripID;
	2: required i32 startday;
	3: required i32 startmonth;
	4: required i32 startyear;
	5: required i32 starthour;
	6: required i32 startminute;
	7: required i32 endday;
	8: required i32 endmonth;
	9: required i32 endyear;
	10: required i32 endhour;
	11: required i32 endminute;
	12: required i64 bicycleID;
	13: required i64 tripduration;
	14: required i64 fromstationID;
	15: required string fromstationname;
	16: required i64 tostationID;
	17: required string tostationname;
	18: required string usertype;
	19: optional bool gender;
	20: optional i32 birthyear;
}
	

