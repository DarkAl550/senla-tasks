@isTest
public with sharing class LeadManagerTest {
    @testSetup
    static void setup(){
        Lead testLead = new Lead();
        testLead.LastName = 'Test';
        testLead.Company = 'Test';
        insert testLead;
    }
    @isTest
    static void testGetLeadById(){
        Lead createdLead = [
                                SELECT Id
                                FROM Lead
                                LIMIT 1
        ];
        RestRequest request = new RestRequest();
        request.requestUri = 'https://senla-6f-dev-ed.my.salesforce.com/services/apexrest/Leads/' + createdLead.Id;
        request.httpMethod = 'GET';
        RestContext.request = request;
        Lead gotLead1 = LeadManager.getLeadById();
        System.assert(gotLead1 != null);
        System.assertEquals(createdLead.Id, gotLead1.Id);
        request.requestUri = 'https://senla-6f-dev-ed.my.salesforce.com/services/apexrest/Leads/' ;
        request.httpMethod = 'GET';
        RestContext.request = request;
        System.assert(null, LeadManager.getLeadById());
        
    }
    @isTest
    static void testCreateTaskForLead(){
        ID taskId = LeadManager.createTaskForLead('Test Post', 'Test Company');
        System.assert(taskId != null);
        Task createdTask = [SELECT Id, Case_Created__c FROM Task WHERE Id=:taskId];
        System.assert(createdTask != null);
        System.assertEquals(createdTask.Case_Created__c, Date.today());
    }
}