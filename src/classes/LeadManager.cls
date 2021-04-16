@RestResource(urlMapping='/Leads/*')
global with sharing class LeadManager {
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
    global static String createTaskForLead(String lastname, String company) {
        try{
            Lead newLead = new Lead();
            newLead.LastName = lastname;
            newLead.Company = company;
            insert newLead;
            
            Task newTask = new Task();
            newTask.Subject = 'Task for Lead:' + lastname;
            newTask.Case_Created__c = Date.today();
            newTask.WhoId = newLead.Id;
            insert newTask;
    
            return newTask.Id;
        }catch(Exception ex){
            return null;
        }
    }   
}