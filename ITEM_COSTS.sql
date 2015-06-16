--SELECTION QUERY FOR ITEM_COSTS
SELECT CREATION_DATE             
|| ',' ||CREATED_BY                
|| ',' ||LAST_UPDATE_DATE          
|| ',' ||LAST_UPDATED_BY           
|| ',' ||LAST_UPDATE_LOGIN         
|| ',' ||REQUEST_ID                
|| ',' ||SOURCE                    
|| ',' ||TEMPLATE_NAME             
|| ',' ||RECORD_ID                 
|| ',' ||STATUS                    
|| ',' ||ERROR_DESCRIPTION         
|| ',' ||ORGANIZATION_CODE         
|| ',' ||ITEM_NAME                 
|| ',' ||SR_ORGANIZATION_ID        
|| ',' ||SR_INSTANCE_ID            
|| ',' ||SR_INVENTORY_ITEM_ID      
|| ',' ||STANDARD_COST ITEM_COSTS_TABLE
from xxnbty_msc_costs_st where status = 'E';

DAPAT where_clause := 'status = ''E'' AND TRUNC(creation_date) = TRUNC(SYSDATE)';                  
