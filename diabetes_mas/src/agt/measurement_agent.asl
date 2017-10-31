// Agent measurement_agent in project diabetes_mas

/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */

+!start : true <- .print("hello world.").

+current_patient_tuple(PatientDataTuple) : true  
	<-  .println(PatientDataTuple);  
	?number_of_last_tuple_read(NumberOfCurrentTuple);  
	!readNextPatientDataTuple(NumberOfCurrentTuple + 1)
	. 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have a agent that always complies with its organization  
{ include("$jacamoJar/templates/org-obedient.asl") }
