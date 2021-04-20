@isTest
public with sharing class LeadManagerHelperTest {
    @isTest
    static void testGetRequiredFields(){
        List<String> fields = LeadManagerHelper.getRequiredFields('Lead');
        System.assert(fields.contains('lastname'));
    }
}