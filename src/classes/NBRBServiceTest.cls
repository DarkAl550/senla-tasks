@isTest
public with sharing class NBRBServiceTest {
    @isTest
    static void testGetRate() {
        Test.setMock(HttpCalloutMock.class, new NBRBServiceMock());

        Test.startTest();
        NBRBService.getRate();
        Test.stopTest();
        
        Rates__c rates = Rates__c.getOrgDefaults();
        System.assertEquals(1.9928, rates.USD__c);
    }
    @isTest
    static void testGetAPI(){
        API_Service__mdt nbrbService = [
                            SELECT API_Key__c
                            FROM API_Service__mdt
                            WHERE Label = 'NBRB Service'
        ];
        System.assertEquals('https://www.nbrb.by/api/exrates/rates?periodicity=0', nbrbService.API_Key__c);
    }
}