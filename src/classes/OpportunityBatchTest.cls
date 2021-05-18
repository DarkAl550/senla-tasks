@isTest
public with sharing class OpportunityBatchTest {
    @testSetup
    static void setup() {
        List<Opportunity> opportunites = new List<Opportunity>();
        for (Integer i=0;i<10;i++) {
            opportunites.add(new Opportunity(name='Opportunity '+i,
                StageName='Qualification', CloseDate = Date.today().addMonths(-i)));
        }
        insert opportunites;

    }
    @isTest static void test() {
        Test.startTest();
        OpportunityBatch opportunityBatch = new OpportunityBatch();
        Id batchId = Database.executeBatch(opportunityBatch);
        Test.stopTest();
        System.assertEquals(8, [SELECT COUNT() FROM Opportunity WHERE StageName = 'Close Won']);
    }
}