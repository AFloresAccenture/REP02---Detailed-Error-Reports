create or replace PACKAGE BODY       XXNBTY_MSCREP02_WIP_PKG 
 ---------------------------------------------------------------------------------------------
  /*
  Package Name	: XXNBTY_MSCREP02_WIP_PKG
  Author's Name: Albert John Flores
  Date written: 10-Jun-2015
  RICEFW Object: REP02
  Description: Package that will generate detailed error log for DEMAND WORK ORDER using FND_FILE. 
  Program Style:
  Maintenance History:
  Date         Issue#  Name         			    Remarks
  -----------  ------  -------------------		------------------------------------------------
  10-Jun-2015          Albert John Flores	  	Initial Development

  */
  ----------------------------------------------------------------------------------------------
 IS 
  PROCEDURE main_proc ( x_retcode   OUT VARCHAR2
					   ,x_errbuf    OUT VARCHAR2)
  IS
   v_request_id    		NUMBER := fnd_global.conc_request_id;  
   v_main_request_id 	NUMBER; 
   v_child_request_id 	NUMBER; 
	
		CURSOR c_req_id (p_request_id NUMBER) 
		IS 
		SELECT a.parent_request_id 
		FROM apps.fnd_concurrent_requests a 
		WHERE a.request_id = p_request_id;
		
		CURSOR c_gen_error (p_main_request_id NUMBER)
		IS
		SELECT ERROR_TEXT                           
				|| ',' ||WIP_ENTITY_NAME                           
				|| ',' ||ITEM_NAME                  
				|| ',' ||ORGANIZATION_CODE                   
				|| ',' ||SR_INSTANCE_CODE          
				|| ',' ||USING_ASSEMBLY_ITEM_NAME                           
				|| ',' ||ROUTING_NAME
				|| ',' ||ORDER_PRIORITY                      
				|| ',' ||DEMAND_ID                           
				|| ',' ||INVENTORY_ITEM_ID                   
				|| ',' ||ORGANIZATION_ID                     
				|| ',' ||USING_ASSEMBLY_ITEM_ID              
				|| ',' ||USING_ASSEMBLY_DEMAND_DATE          
				|| ',' ||USING_REQUIREMENT_QUANTITY          
				|| ',' ||ASSEMBLY_DEMAND_COMP_DATE           
				|| ',' ||DEMAND_TYPE                         
				|| ',' ||DAILY_DEMAND_RATE                   
				|| ',' ||ORIGINATION_TYPE                    
				|| ',' ||SOURCE_ORGANIZATION_ID              
				|| ',' ||DISPOSITION_ID                      
				|| ',' ||RESERVATION_ID                      
				|| ',' ||DEMAND_SCHEDULE_NAME                
				|| ',' ||PROJECT_ID                          
				|| ',' ||TASK_ID                             
				|| ',' ||PLANNING_GROUP                      
				|| ',' ||END_ITEM_UNIT_NUMBER                
				|| ',' ||SCHEDULE_DATE                       
				|| ',' ||OPERATION_SEQ_NUM                   
				|| ',' ||QUANTITY_ISSUED                     
				|| ',' ||DEMAND_CLASS                        
				|| ',' ||SALES_ORDER_NUMBER                  
				|| ',' ||SALES_ORDER_PRIORITY                
				|| ',' ||FORECAST_PRIORITY                   
				|| ',' ||MPS_DATE_REQUIRED                   
				|| ',' ||PO_NUMBER                     
				|| ',' ||DELETED_FLAG                        
				|| ',' ||LAST_UPDATE_DATE                    
				|| ',' ||LAST_UPDATED_BY                     
				|| ',' ||CREATION_DATE                       
				|| ',' ||CREATED_BY                          
				|| ',' ||LAST_UPDATE_LOGIN                   
				|| ',' ||REQUEST_ID                          
				|| ',' ||PROGRAM_APPLICATION_ID              
				|| ',' ||PROGRAM_ID                          
				|| ',' ||PROGRAM_UPDATE_DATE                 
				|| ',' ||SR_INSTANCE_ID                      
				|| ',' ||REFRESH_ID                          
				|| ',' ||REPETITIVE_SCHEDULE_ID              
				|| ',' ||WIP_ENTITY_ID                       
				|| ',' ||SELLING_PRICE                       
				|| ',' ||DMD_LATENESS_COST                   
				|| ',' ||DMD_SATISFIED_DATE                  
				|| ',' ||DMD_SPLIT_FLAG                      
				|| ',' ||REQUEST_DATE                        
				|| ',' ||ORDER_NUMBER                        
				|| ',' ||WIP_STATUS_CODE                     
				|| ',' ||WIP_SUPPLY_TYPE                     
				|| ',' ||ATTRIBUTE1                          
				|| ',' ||ATTRIBUTE2                          
				|| ',' ||ATTRIBUTE3                          
				|| ',' ||ATTRIBUTE4                          
				|| ',' ||ATTRIBUTE5                          
				|| ',' ||ATTRIBUTE6                          
				|| ',' ||ATTRIBUTE7                          
				|| ',' ||ATTRIBUTE8                          
				|| ',' ||ATTRIBUTE9                          
				|| ',' ||ATTRIBUTE10                         
				|| ',' ||ATTRIBUTE11                         
				|| ',' ||ATTRIBUTE12                         
				|| ',' ||ATTRIBUTE13                         
				|| ',' ||ATTRIBUTE14                         
				|| ',' ||ATTRIBUTE15                         
				|| ',' ||SALES_ORDER_LINE_ID                 
				|| ',' ||CONFIDENCE_PERCENTAGE               
				|| ',' ||BUCKET_TYPE                         
				|| ',' ||BILL_ID                             
				|| ',' ||CUSTOMER_ID                         
				|| ',' ||PROBABILITY                         
				|| ',' ||SERVICE_LEVEL                       
				|| ',' ||FORECAST_MAD                        
				|| ',' ||FORECAST_DESIGNATOR                 
				|| ',' ||ORIGINAL_SYSTEM_REFERENCE           
				|| ',' ||ORIGINAL_SYSTEM_LINE_REFERENCE      
				|| ',' ||DEMAND_SOURCE_TYPE                  
				|| ',' ||SHIP_TO_SITE_ID                     
				|| ',' ||COMPANY_ID                          
				|| ',' ||COMPANY_NAME                        
				|| ',' ||CUSTOMER_NAME                       
				|| ',' ||CUSTOMER_SITE_ID                    
				|| ',' ||CUSTOMER_SITE_CODE                  
				|| ',' ||BILL_CODE                        
				|| ',' ||ALTERNATE_ROUTING_DESIGNATOR        
				|| ',' ||OPERATION_EFFECTIVITY_DATE            
				|| ',' ||PROJECT_NUMBER                      
				|| ',' ||TASK_NUMBER                         
				|| ',' ||SCHEDULE_LINE_NUM                   
				|| ',' ||OPERATION_SEQ_CODE                    
				|| ',' ||MESSAGE_ID                          
				|| ',' ||PROCESS_FLAG                        
				|| ',' ||BATCH_ID                            
				|| ',' ||DATA_SOURCE_TYPE                    
				|| ',' ||ST_TRANSACTION_ID                          
				|| ',' ||COMMENTS                            
				|| ',' ||PROMISE_DATE                        
				|| ',' ||LINK_TO_LINE_ID                     
				|| ',' ||QUANTITY_PER_ASSEMBLY               
				|| ',' ||ORDER_DATE_TYPE_CODE                
				|| ',' ||LATEST_ACCEPTABLE_DATE              
				|| ',' ||SHIPPING_METHOD_CODE                
				|| ',' ||SCHEDULE_SHIP_DATE                  
				|| ',' ||SCHEDULE_ARRIVAL_DATE               
				|| ',' ||REQUEST_SHIP_DATE                   
				|| ',' ||PROMISE_SHIP_DATE                   
				|| ',' ||SOURCE_ORG_ID                       
				|| ',' ||SOURCE_INVENTORY_ITEM_ID            
				|| ',' ||SOURCE_USING_ASSEMBLY_ITEM_ID       
				|| ',' ||SOURCE_SALES_ORDER_LINE_ID          
				|| ',' ||SOURCE_PROJECT_ID                   
				|| ',' ||SOURCE_TASK_ID                      
				|| ',' ||SOURCE_CUSTOMER_SITE_ID             
				|| ',' ||SOURCE_BILL_ID                      
				|| ',' ||SOURCE_DISPOSITION_ID               
				|| ',' ||SOURCE_CUSTOMER_ID                  
				|| ',' ||SOURCE_OPERATION_SEQ_NUM            
				|| ',' ||SOURCE_WIP_ENTITY_ID                
				|| ',' ||ROUTING_SEQUENCE_ID                 
				|| ',' ||ASSET_SERIAL_NUMBER                 
				|| ',' ||ASSET_ITEM_ID                       
				|| ',' ||COMPONENT_SCALING_TYPE              
				|| ',' ||COMPONENT_YIELD_FACTOR              
				|| ',' ||ITEM_TYPE_ID                        
				|| ',' ||ITEM_TYPE_VALUE                     
				|| ',' ||REPAIR_LINE_ID                      
				|| ',' ||RO_STATUS_CODE                      
				|| ',' ||REPAIR_NUMBER                       
				|| ',' ||ENTITY                              
				|| ',' ||REVISED_DMD_DATE                    
				|| ',' ||REVISED_DMD_PRIORITY                
				|| ',' ||SCHEDULE_DESIGNATOR_ID              
				|| ',' ||OBJECT_TYPE                         
				|| ',' ||OPERATING_FLEET                     
				|| ',' ||MAINTENANCE_REQUIREMENT             
				|| ',' ||CLASS_CODE                          
				|| ',' ||MAINTENANCE_OBJECT_SOURCE WIP_DATA_TABLE       
				FROM msc_st_demands 
				WHERE process_flag = 3 AND TRUNC(creation_date) = TRUNC(SYSDATE) AND abs(request_id) >= p_main_request_id;
						
	TYPE err_tab_type		   IS TABLE OF c_gen_error%ROWTYPE;
	  
	l_detailed_error_tab	   err_tab_type; 
	v_step          		   NUMBER;
	v_mess          		   VARCHAR2(500);
	
   BEGIN
	v_step := 1;
		v_child_request_id := v_request_id; 
		
		LOOP 
			OPEN c_req_id(v_child_request_id); 
			FETCH c_req_id INTO v_main_request_id; 
			EXIT WHEN c_req_id%notfound; 
			
			IF v_main_request_id = -1 THEN 
				v_main_request_id := v_child_request_id; 
				EXIT; 
			ELSE 
				v_child_request_id := v_main_request_id; 
			END IF;
			CLOSE c_req_id; 
		END LOOP;
	v_step := 2;		
		IF c_req_id%isopen THEN 
			CLOSE c_req_id; 
		END IF; 
	v_step := 3;	
		FND_FILE.PUT_LINE(FND_FILE.LOG,'v_main_request_id : ' || v_main_request_id);
		FND_FILE.PUT_LINE(FND_FILE.OUTPUT,'ERROR_TEXT,WIP_ENTITY_NAME,ITEM_NAME,ORGANIZATION_CODE,SR_INSTANCE_CODE,USING_ASSEMBLY_ITEM_NAME,ROUTING_NAME,ORDER_PRIORITY ,DEMAND_ID ,INVENTORY_ITEM_ID ,ORGANIZATION_ID ,USING_ASSEMBLY_ITEM_ID ,USING_ASSEMBLY_DEMAND_DATE ,USING_REQUIREMENT_QUANTITY ,ASSEMBLY_DEMAND_COMP_DATE ,DEMAND_TYPE ,DAILY_DEMAND_RATE ,ORIGINATION_TYPE ,SOURCE_ORGANIZATION_ID ,DISPOSITION_ID ,RESERVATION_ID ,DEMAND_SCHEDULE_NAME ,PROJECT_ID ,TASK_ID ,PLANNING_GROUP ,END_ITEM_UNIT_NUMBER   ,SCHEDULE_DATE          ,OPERATION_SEQ_NUM      ,QUANTITY_ISSUED        ,DEMAND_CLASS           ,SALES_ORDER_NUMBER     ,SALES_ORDER_PRIORITY   ,FORECAST_PRIORITY      ,MPS_DATE_REQUIRED      ,PO_NUMBER              ,DELETED_FLAG           ,LAST_UPDATE_DATE       ,LAST_UPDATED_BY        ,CREATION_DATE          ,CREATED_BY             ,LAST_UPDATE_LOGIN      ,REQUEST_ID             ,PROGRAM_APPLICATION_ID ,PROGRAM_ID             ,PROGRAM_UPDATE_DATE    ,SR_INSTANCE_ID         ,REFRESH_ID             ,REPETITIVE_SCHEDULE_ID ,WIP_ENTITY_ID          ,SELLING_PRICE          ,DMD_LATENESS_COST      ,DMD_SATISFIED_DATE     ,DMD_SPLIT_FLAG         ,REQUEST_DATE           ,ORDER_NUMBER           ,WIP_STATUS_CODE        ,WIP_SUPPLY_TYPE        ,ATTRIBUTE1             ,ATTRIBUTE2             ,ATTRIBUTE3             ,ATTRIBUTE4             ,ATTRIBUTE5             ,ATTRIBUTE6             ,ATTRIBUTE7             ,ATTRIBUTE8             ,ATTRIBUTE9             ,ATTRIBUTE10            ,ATTRIBUTE11            ,ATTRIBUTE12            ,ATTRIBUTE13            ,ATTRIBUTE14            ,ATTRIBUTE15  ,SALES_ORDER_LINE_ID    ,CONFIDENCE_PERCENTAGE          ,BUCKET_TYPE                    ,BILL_ID                        ,CUSTOMER_ID                    ,PROBABILITY                    ,SERVICE_LEVEL                  ,FORECAST_MAD                   ,FORECAST_DESIGNATOR            ,ORIGINAL_SYSTEM_REFERENCE      ,ORIGINAL_SYSTEM_LINE_REFERENCE ,DEMAND_SOURCE_TYPE             ,SHIP_TO_SITE_ID                ,COMPANY_ID                     ,COMPANY_NAME                   ,CUSTOMER_NAME                  ,CUSTOMER_SITE_ID               ,CUSTOMER_SITE_CODE             ,BILL_CODE                      ,ALTERNATE_ROUTING_DESIGNATOR   ,OPERATION_EFFECTIVITY_DATE     ,PROJECT_NUMBER                 ,TASK_NUMBER                    ,SCHEDULE_LINE_NUM              ,OPERATION_SEQ_CODE             ,MESSAGE_ID                     ,PROCESS_FLAG                   ,BATCH_ID                       ,DATA_SOURCE_TYPE               ,ST_TRANSACTION_ID              ,COMMENTS                       ,PROMISE_DATE                   ,LINK_TO_LINE_ID                ,QUANTITY_PER_ASSEMBLY          ,ORDER_DATE_TYPE_CODE           ,LATEST_ACCEPTABLE_DATE         ,SHIPPING_METHOD_CODE           ,SCHEDULE_SHIP_DATE             ,SCHEDULE_ARRIVAL_DATE          ,REQUEST_SHIP_DATE              ,PROMISE_SHIP_DATE              ,SOURCE_ORG_ID                  ,SOURCE_INVENTORY_ITEM_ID       ,SOURCE_USING_ASSEMBLY_ITEM_ID  ,SOURCE_SALES_ORDER_LINE_ID     ,SOURCE_PROJECT_ID              ,SOURCE_TASK_ID                 ,SOURCE_CUSTOMER_SITE_ID        ,SOURCE_BILL_ID                 ,SOURCE_DISPOSITION_ID          ,SOURCE_CUSTOMER_ID             ,SOURCE_OPERATION_SEQ_NUM       ,SOURCE_WIP_ENTITY_ID           ,ROUTING_SEQUENCE_ID            ,ASSET_SERIAL_NUMBER            ,ASSET_ITEM_ID                  ,COMPONENT_SCALING_TYPE         ,COMPONENT_YIELD_FACTOR         ,ITEM_TYPE_ID                   ,ITEM_TYPE_VALUE                ,REPAIR_LINE_ID                 ,RO_STATUS_CODE                 ,REPAIR_NUMBER                  ,ENTITY                         ,REVISED_DMD_DATE               ,REVISED_DMD_PRIORITY           ,SCHEDULE_DESIGNATOR_ID         ,OBJECT_TYPE                    ,OPERATING_FLEET                ,MAINTENANCE_REQUIREMENT        ,CLASS_CODE                     ,MAINTENANCE_OBJECT_SOURCE');
		
		OPEN c_gen_error(v_main_request_id);
	v_step := 4;	
		FETCH c_gen_error BULK COLLECT INTO l_detailed_error_tab;
		FOR i in 1..l_detailed_error_tab.COUNT
			LOOP
				FND_FILE.PUT_LINE(FND_FILE.OUTPUT, l_detailed_error_tab(i).WIP_DATA_TABLE );
			END LOOP;
		CLOSE c_gen_error;
	v_step := 5;
	
	EXCEPTION
		WHEN OTHERS THEN
		  v_mess := 'At step ['||v_step||'] - SQLCODE [' ||SQLCODE|| '] - ' ||substr(SQLERRM,1,100);
		  x_errbuf  := v_mess;
		  x_retcode := 2; 

   END main_proc;
		
END XXNBTY_MSCREP02_WIP_PKG;