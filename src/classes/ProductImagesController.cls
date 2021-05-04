public with sharing class ProductImagesController {
    @AuraEnabled
    public static List<Attachment> getProductAttachments(String productId){
        List<Attachment> attachments = [
                                            SELECT Id, Name 
                                            FROM Attachment
                                            WHERE ParentId = :productId
        ];
        return attachments;
    }
}