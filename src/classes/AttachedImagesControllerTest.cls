@isTest
public with sharing class AttachedImagesControllerTest {
    @testSetup
    static void setup(){
        Product2 product = new Product2(
            Name = 'Test Product'
        );
        insert product;
        Blob bodyBlob=Blob.valueOf('Test Attachment Body'); 
        Attachment attachment = new Attachment(
            Name='Test Attachment',
            Body=bodyBlob,
            ParentId=product.id
        ); 
        insert attachment;
    }

    @isTest
    static void testGetProductAttachments(){
        Product2 product = [
                            SELECT Id
                            FROM Product2
                            LIMIT 1
        ];
        List<Attachment> attachments = AttachedImagesController.getAttachments(product.Id);

        System.assert(attachments.size() > 0);
        for(Attachment attachment : attachments){
            System.assertEquals('Test Attachment', attachment.Name);
        }
    }
}