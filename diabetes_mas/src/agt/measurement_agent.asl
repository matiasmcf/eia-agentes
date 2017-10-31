// Agent measurement_agent in project diabetes_mas

/* Initial beliefs and rules */ 
 
/* Initial goals */ 
 
!configure_patient_dataset_reader. 
 
/* Plans */ 
 
+!focus(ArtId) // goal sent by the Agents to focus artefacts    
	<- 	
	lookupArtifact(ArtId,MediumId);       
	focus(MediumId)
	.        

+!configure_patient_dataset_reader : true 
	<-   
	makeArtifact(patient_dataset_reader, "diabetes_mas.PatientDatasetReader", [], ArtId);  
	focus(ArtId);  
	.println("measurement agent started")  ;
	.println("Dataset to load:");  
	readHeader(DatasetHeader);  
	println(DatasetHeader)
	.       
	
+!start_patient_data_reader [source(JudgeAgent)]: true 
	<-  
	+judge_agent(JudgeAgent);  
	startTuplesReader
	.   

+!read_next_patient_data_tuple : number_of_last_tuple_read(CurrentTupleNumber) &  number_of_tuples(NumberOfTuples) & (CurrentTupleNumber + 1) < NumberOfTuples  
	<-  
	readTuple(CurrentTupleNumber + 1)
	. 
 
+!read_next_patient_data_tuple : number_of_last_tuple_read(CurrentTupleNumber) &  number_of_tuples(NumberOfTuples) & (CurrentTupleNumber + 1)  == NumberOfTuples 
	<-  
	.println("No tuples to read");  
	?judge_agent(JudgeAgent);  
	.send(JudgeAgent,tell,no_tuples_to_read)
	.   

+current_patient_tuple(PatientDataTuple) : true  
	<-   
	clearPatientMeasureData;  
 	.length(PatientDataTuple,NumberOfFields);    
 	for(.range(Index,0,NumberOfFields - 1)){
 		jia.getDoubleItemFromArrayAtIxdex(Index,PatientDataTuple,Measure);      
 		addPatientField(Measure);
 	};  
 	.println("patient data measures: ",PatientDataTuple);   
 	sendPatientMeasureData
 	. 


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
