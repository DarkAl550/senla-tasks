@isTest
public with sharing class LeadManagerTest {
    @isTest
    static void testGetLeadById_Success(){
        Lead testLead = new Lead();
        testLead.LastName = 'Test';
        testLead.Company = 'testCompany';
        testLead.CustomField__c = 'testt';
        insert testLead;

        RestRequest request = new RestRequest();
        request.requestUri = 'https://senla-6f-dev-ed.my.salesforce.com/services/apexrest/Leads/' + testLead.Id;
        request.httpMethod = 'GET';
        RestContext.request = request;
        String result = LeadManager.getLeadById();
        System.assert(result != null);
        Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals('SUCCESS', resultMap.get('status'));
        
    }
    @isTest
    static void testGetLeadById_Error(){
        Lead testLead = new Lead();
        testLead.LastName = 'Test';
        testLead.Company = 'testCompany';
        testLead.CustomField__c = 'testt';
        insert testLead;

        RestRequest request = new RestRequest();
        request.requestUri = 'https://senla-6f-dev-ed.my.salesforce.com/services/apexrest/Leads/' ;
        request.httpMethod = 'GET';
        RestContext.request = request;
        String result = LeadManager.getLeadById();
        System.assert(result != null);
        Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals('ERROR', resultMap.get('status'));
        System.assertEquals('Lead not found', resultMap.get('message'));
    }
    @isTest
    static void testCreateTaskForLead_Success(){
        Lead testLead = new Lead();
        testLead.LastName = 'TestName';
        testLead.Company = 'TestCompany';
        testLead.CustomField__c = 'test';
        insert testLead;
        RestRequest request = new RestRequest();
        request.requestUri = 'https://senla-6f-dev-ed.my.salesforce.com/services/apexrest/Leads/' + testLead.Id;
        request.httpMethod = 'POST';
        RestContext.request = request;
        LeadManager.createTaskForLead(null);
        request.requestUri = 'https://senla-6f-dev-ed.my.salesforce.com/services/apexrest/Leads/';
        request.httpMethod = 'POST';
        RestContext.request = request;
        LeadManager.createTaskForLead(testLead.Id);
        List<Task> tasks = [SELECT Id, Case_Created__c FROM Task WHERE WhoId = :testLead.Id];
        System.assert(tasks.size() == 2);
        for(Task createdTask : tasks){
            System.assertEquals(createdTask.Case_Created__c, Date.today());
        }
        
    }
    @isTest
    static void testCreateTaskForLead_Error(){
        RestRequest request = new RestRequest();
        request.requestUri = 'https://senla-6f-dev-ed.my.salesforce.com/services/apexrest/Leads/';
        RestContext.request = request;
        String result = LeadManager.createTaskForLead(null);
        Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals('ERROR', resultMap.get('status'));
        System.assertEquals('Task can\'t created! Lead id is not empty!', resultMap.get('message'));
    }
}