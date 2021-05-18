public with sharing class AttachedImagesController {
    @AuraEnabled
    public static List<Attachment> getAttachments(String recordId){
        List<Attachment> attachments = [
                                            SELECT Id, Name 
                                            FROM Attachment
                                            WHERE ParentId = :recordId
        ];
        return attachments;
    }
}