@RestResource(urlMapping='/Leads/*')
global with sharing class LeadManager extends LeadManagerHelper {
    @HttpGet
    global static Lead getLeadById() {
        try{
            String leadId = RestContext.request.requestURI.substring(RestContext.request.requestURI.lastIndexOf('/')+1);
            List<Lead> thisLeads =  [
                            SELECT Id, LastName
                            FROM Lead
                            WHERE Id = :leadId
            ];
            return thisLeads[0];
        }catch(Exception ex){
            return null;
        }   
    }
    @HttpPost
    global static String createTaskForLead() {
        try{
            RestRequest req = RestContext.request;
            String jsonBody = req.requestBody.toString();
            Map<String, Object> body = (Map<String, Object>)JSON.deserializeUntyped(jsonBody); 

            List<String> requiredFields_Lead = getRequiredFields('Lead');
            List<String> requeredFields_Task = getRequiredFields('Task');

            for(String requiredField : requiredFields_Lead){
                if(!body.containsKey(requiredField)){
                    String error = 'Not contain required field ('+ requiredField +')';
                    return error;
                }
            }
            
            Lead newLead = new Lead();
            for(String bodyKey : body.keySet()){
                newLead.put(bodyKey, body.get(bodyKey));
            }
            insert newLead;

            Task newTask = new Task();
            newTask.Subject = 'Task for Lead:' + newLead.get('lastname');
            newTask.Case_Created__c = Date.today();
            newTask.WhoId = newLead.Id;
            insert newTask;
            return newLead.Id;
        }catch(SObjectException sobjectExeprion){
            return 'Error:  Illegal assignment!';
        }
       
    }   
}