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
            //AccountManager.setCustomField2(accountIds);
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
        List<Account> testAccounts = new List<Account>();
        List<Contact> testContacts = new List<Contact>();
        List<Case> testCases = new List<Case>();
        for(Integer i=0; i<200; i++){
            Account acc = new Account();
            acc.Name = 'Test' + i; 
            testAccounts.add(acc);  

            Contact cont = new Contact();
            cont.LastName = 'Test' + i; 
            cont.AccountId = acc.Id;
            testContacts.add(cont);

            Case testCase = new Case();
            testCase.Status = 'New';
            testCase.Origin = 'Email';
            testCase.ContactId = cont.Id;
            testCases.add(testCase);
        }
        insert testCases;
        insert testContacts;
        insert testAccounts;
        System.assertEquals(200, [SELECT COUNT() FROM Task]);
    }
}