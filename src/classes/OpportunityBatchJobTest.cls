@isTest
public with sharing class OpportunityBatchJobTest {
    @testSetup
    static void setup() {
        List<Opportunity> opportunites = new List<Opportunity>();
        for (Integer i=0;i<10;i++) {
            opportunites.add(new Opportunity(name='Opportunity '+i,
                StageName='Qualification', CloseDate = Date.today().addMonths(-i)));
        }
        insert opportunites;

    }
    @isTest
    static void testOpportunityBatchJob(){
        String cron = '20 30 8 10 2 ?';
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', cron, new OpportunityBatchJob());
        System.assertEquals(0, [SELECT COUNT() FROM Opportunity WHERE StageName = 'Close Won']);
        Test.stopTest();
        
        
    }   
}