public with sharing class QuestionnaireController {
    @AuraEnabled
    public static Boolean saveQuestionnaire(String email, Integer rating, String description){
        List<Lead> leads = [
                                SELECT Id, ConvertedAccountId
                                FROM Lead
                                WHERE Email = :email
        ];
        if(!leads.isEmpty()){
            Questionnaire_Result__c questionnaire = new Questionnaire_Result__c();
            questionnaire.Rating__c = rating;
            questionnaire.Description__c = description;
            questionnaire.AccountId__c = leads[0].ConvertedAccountId;
            questionnaire.LeadId__c = leads[0].Id;
            insert questionnaire;
            return true;
        }
        return false;
        
    }
}