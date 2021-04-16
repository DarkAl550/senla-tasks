public with sharing class AccountManager {
    @InvocableMethod
    public static void setCustomField2(List<Id> accountIds){
        List<Account> accounts = [
                                    SELECT Id, Custom_Field2__c
                                    FROM Account
                                    WHERE Id IN :accountIds
        ];
        for(Account account : accounts){
            Datetime dateNow = Datetime.now();
            account.Custom_Field2__c = dateNow.time();           
        }
        upsert accounts;
        executeFlow_ContactFlowCreateTask(accountIds);
    }
    public static void executeFlow_ContactFlowCreateTask(List<Id> accountIds){
        List<Contact> contacts = [
                                    SELECT Id
                                    FROM Contact
                                    WHERE AccountId IN :accountIds
        ];
        List<Id> contactIds = new List<Id>();
        for(Contact contact : contacts){
            contactIds.add(contact.Id);
        }
        Map<String, Object> params = new Map<String, Object>();
        params.put('RecordId', contactIds);
        Flow.Interview.Contact_Flow_Create_Task contactFlow = new Flow.Interview.Contact_Flow_Create_Task(params);
        contactFlow.start();  
    }
}