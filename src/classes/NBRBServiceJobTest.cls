@isTest
public with sharing class NBRBServiceJobTest {
    @isTest
    static void testNBRBServiceJob(){
        String cron = '20 30 8 10 2 ?';
        Test.setMock(HttpCalloutMock.class, new NBRBServiceMock());
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', cron, new NBRBServiceJob());
        List<Rates__c> rates = [
                                SELECT USD__c 
                                FROM Rates__c
        ];
        System.assertEquals(0, rates.size());
        Test.stopTest();
        
    }   
}