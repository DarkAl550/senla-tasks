@isTest
public with sharing class AccountManagerTest {

    @isTest
    static void testSetCustomField2(){
        List<Account> testAccounts = new List<Account>();
        for(Integer i=0; i<200; i++){
            Account acc = new Account();
            acc.Name = 'Test' + i; 
            testAccounts.add(acc);  
        }
        
        Test.startTest();
            insert testAccounts;
        Test.stopTest();
        List<Account> updatedAccounts = [
                                            SELECT Id, Custom_Field2__c 
                                            FROM Account
        ];
        for(Account updatedAccount : updatedAccounts){
            System.assertNotEquals(updatedAccount.Custom_Field2__c, null); 
        }
    }

    @isTest
    static void testExecuteFlow_ContactFlowCreateTask(){
        Account testAccount = new Account();
        testAccount.Name = 'Test'; 
        insert testAccount;

        Contact testContact = new Contact();
        testContact.LastName = 'Test'; 
        testContact.AccountId = testAccount.Id;
        insert testContact;

        Case testCase = new Case();
        testCase.Status = 'New';
        testCase.Origin = 'Email';
        testCase.ContactId = testContact.Id;
        insert testCase;

        Test.startTest();
            testAccount.Name ='TestName';
            update testAccount;
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM Task]);

    }
}