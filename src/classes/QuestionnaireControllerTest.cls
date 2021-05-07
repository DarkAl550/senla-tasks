@isTest
public with sharing class QuestionnaireControllerTest {
    @isTest
    static void testSaveQuestionnaire(){
        Lead testLead = new Lead(
			LastName = 'Test',
			Status='Qualified',
			Company='Lacosta',
			Email = 'test@test.te',
            Language__c = 'RU'
  	    );
	    insert 	testLead;
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(testLead.Id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        System.assert(QuestionnaireController.saveQuestionnaire(testLead.Email, 5, 'test'));
        System.assert(!QuestionnaireController.saveQuestionnaire('custom@email.com', 5, 'test'));


    }
}