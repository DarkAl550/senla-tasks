@isTest
public with sharing class ObjectSchemaManagerTest {
    @isTest
    static void testGetFields(){
        Map<String,Schema.SObjectField> ratesFields = ObjectSchemaManager.getFields('Rates__c');
        System.assert(ratesFields.containsKey('blr__c'));
        Map<String,Schema.SObjectField> accountFields = ObjectSchemaManager.getFields('Account');
        System.assert(accountFields.containsKey('name'));
    }
}