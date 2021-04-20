@RestResource(urlMapping='/Leads/*')
global with sharing class LeadManager extends LeadManagerHelper {

    private class SalesforceMessage {
        private String status;
        private String message;
        private SalesforceMessage(String status, string message){
            this.status = status;
            this.message = message;
        }
    }

    @HttpGet
    global static String getLeadById() {
        try{
            Id leadId = RestContext.request.requestURI.substring(RestContext.request.requestURI.lastIndexOf('/')+1);
            String query = 'SELECT Id, '+String.Join(getRequiredFields('Lead'), ', ')+' FROM Lead WHERE Id = \''+leadId+'\'';
            List<Lead> gotLeads = Database.query(query);
            SalesforceMessage message = new SalesforceMessage('SUCCESS', JSON.serialize(gotLeads[0]));
            return JSON.serialize(message);
        }catch(System.StringException e){
            SalesforceMessage error = new SalesforceMessage('ERROR', 'Lead not found');
            return JSON.serialize(error);
        }catch(Exception e){
            SalesforceMessage error = new SalesforceMessage('UNKNOWN_ERROR', 'Opps! Unknown error :/');
            return JSON.serialize(error);
        }
    }

    @HttpPost
    global static String createTaskForLead(String id) {
        try{
            Id leadId = (String.isEmpty(id)) 
                            ? RestContext.request.requestURI.substring(RestContext.request.requestURI.lastIndexOf('/')+1)
                            : id;
            List<String> requiredFields_Lead = getRequiredFields('Lead');
            String query ='SELECT Id, '+ String.Join(requiredFields_Lead, ', ') +
                            ' FROM Lead WHERE Id = \''+leadId+'\'';
            List<Lead> gotLeads = Database.query(query);
            Task newTask = new Task();
            newTask.Subject = 'Task for Lead:' + gotLeads[0].get('lastname');
            newTask.Case_Created__c = Date.today();
            newTask.WhoId = gotLeads[0].get('Id').toString();
            insert newTask;
            SalesforceMessage message = new SalesforceMessage('SUCCESS', JSON.serialize(newTask));
            return JSON.serialize(message);  
        }catch(System.StringException e){
            SalesforceMessage error = new SalesforceMessage('ERROR', 'Task can\'t created! Lead id is not empty!');
            return JSON.serialize(error); 
        }catch(Exception e){
            SalesforceMessage error = new SalesforceMessage('UNKNOWN_ERROR', 'Opps! Unknown error :/');
            return JSON.serialize(error); 
        }
    }   
}