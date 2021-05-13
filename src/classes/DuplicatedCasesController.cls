public with sharing class DuplicatedCasesController {
    @AuraEnabled(cacheable=true)
    public static List<Case> getDuplicatedCases(Id recordId){
        List<Case> currentCase = [
                                    SELECT Id, Subject, SuppliedEmail, Reason
                                    FROM Case
                                    WHERE Id = :recordId
                                        AND Status != 'Closed'
        ];
        List<Case> duplicatedCases = [
                                        SELECT Id, CaseNumber, Origin, SuppliedEmail, Status, Reason, Owner.Name, OwnerId
                                        FROM Case
                                        WHERE Subject = :currentCase[0].Subject
                                            AND SuppliedEmail = :currentCase[0].SuppliedEmail
                                            AND Reason = :currentCase[0].Reason
                                            AND Id != :currentCase[0].Id
                                            AND Status != 'Closed'
        ];
        return duplicatedCases;
    }
    @AuraEnabled
    public static Boolean checkRecordInQueue(String queueId){
        List<Group> queues = [
                                SELECT Id, Name
                                FROM Group
                                WHERE Type = 'Queue'  
        ];
        for(Group queue : queues){
            if(queue.Id == queueId) return true;
        }
        return false;
    }
    @AuraEnabled
    public static void sendBellNotification(String ownerId, String caseNumber, String caseId){
        FeedItem notification = new FeedItem();
        notification.ParentId = ownerId;
        notification.Body = 'Внимание: кейс  '+caseNumber+' был закрыт как дубликат.';
        notification.Title = 'Case was closed!';
        notification.LinkUrl = '/lightning/r/Case/' + caseId + '/view';
        insert notification;                
    }
    @AuraEnabled
    public static void mergingCases(String parentId, String childId){
        Case parentCase = [
                            SELECT Id, Description, Status, Priority, Lead__c, AccountId, Country__c, SuppliedName
                            FROM  Case
                            WHERE Id = :parentId
        ][0];
        Case childCase = [
                            SELECT Id, Description, Status, Priority, Lead__c, AccountId, Country__c, SuppliedName, ParentId
                            FROM  Case
                            WHERE Id = :childId
        ][0];
        parentCase.Description += '\n----//----\n' + childCase.Description;
        parentCase.Priority = setPriority(parentCase.Priority, childCase.Priority);
        parentCase.AccountId = (parentCase.AccountId != null) 
                                    ? parentCase.AccountId : childCase.AccountId;
        parentCase.Lead__c = (parentCase.Lead__c != null) 
                                    ? parentCase.Lead__c : childCase.Lead__c;
        parentCase.Country__c = (parentCase.Country__c != null) 
                                    ? parentCase.Country__c : childCase.Country__c;
        parentCase.SuppliedName = (parentCase.SuppliedName != null) 
                                    ? parentCase.SuppliedName : childCase.SuppliedName;
        update parentCase;
        childCase.ParentId = parentCase.Id;
        childCase.Status = 'Closed';
        update childCase;
        setEmailMessages(parentCase.Id, childCase.Id);
    }

    private static String setPriority(String parentPriority, String childPriority){
        if(parentPriority == 'High') return parentPriority;
        if(childPriority == 'High') return childPriority;
        if(parentPriority == 'Low') return childPriority;
        return parentPriority;
    }
    private static void setEmailMessages(String parentId, String childId){
        List<EmailMessage> childEmailMessages = [
                                            SELECT Id, ParentId, FromAddress, ToAddress, Subject, TextBody
                                            FROM EmailMessage 
                                            WHERE ParentId = :childId
        ];
        List<EmailMessage> parentEmailMessages = new List<EmailMessage>();
        for(EmailMessage emailMessage : childEmailMessages){
            EmailMessage parentEmailMessage = emailMessage.clone();
            parentEmailMessage.ParentId = parentId;
            parentEmailMessages.add(parentEmailMessage);
        }
        insert parentEmailMessages;
    }

}