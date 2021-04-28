@isTest
public with sharing class ProductTriggerHandlerTest {
    @testSetup
    static void setup() {
        Account account = new Account(
            Name = 'Test', 
            Phone = '345678'
        );
        insert account;
        Opportunity opportunity = new Opportunity(Name='Test',
            CloseDate=Date.today(), 
            StageName='Prospecting', 
            AccountId = account.Id
        );
        insert opportunity; 

        Id pricebookId = Test.getStandardPricebookId();
        Product2 product = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert product;
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = product.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opportunity.Id,
            Quantity = 5,
            PricebookEntryId = pbEntry.Id,
            TotalPrice = 10 * pbEntry.UnitPrice
        );
        insert oli;
    }
    @isTest
    static void testAfterUpdate(){
        Product2 product = [
                        SELECT Id, IsActive 
                        FROM Product2 
                        LIMIT 1
        ];
        Account account = [
                        SELECT Id, Phone
                        FROM Account
                        LIMIT 1
        ];
        Test.startTest();
        product.IsActive = false;
        update product;            
        Test.stopTest();
        List<Task> tasks = [
                            SELECT Id, Subject, Phone__c, WhatId 
                            FROM Task 
                            WHERE Status = 'New'
        ];
        for(Task task : tasks){
            System.assertEquals(task.Phone__c, account.Phone);
            System.assertEquals(task.Subject, 'Old model deal!!!');
        }
    }
}