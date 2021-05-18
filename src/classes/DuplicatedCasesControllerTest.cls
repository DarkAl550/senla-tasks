@isTest
public with sharing class DuplicatedCasesControllerTest {
    @testSetup
    static void setup(){
        List<Case> testCases = new List<Case>();
        for(Integer i=0; i<2; i++){
            Case testCase = new Case(
                Subject = 'Test',
                Status = 'In progress',
                Priority = 'Medium',
                SuppliedEmail = 'test@test.te',
                Reason = 'Insurance',
                Origin = 'Manual',
                Language__c = 'EN'
            );
            testCases.add(testCase);
        }
        insert testCases;

        EmailMessage emailMessage= new EmailMessage();
        emailMessage.FromAddress='test@test.com';
        emailMessage.ToAddress = 'test@test.te';
        emailMessage.Subject = 'Opt Out Test Message';
        emailMessage.TextBody= 'This is the message body BR-Interno.';
        emailMessage.ParentId=testCases[1].id;
        insert emailMessage; 
    }
    @isTest
    static void testGetDuplicatedCases(){
        Case testCase = [
                            SELECT Id, Subject, SuppliedEmail, Reason
                            FROM Case
                            LIMIT 1
        ];
        List<Case> cases = DuplicatedCasesController.getDuplicatedCases(testCase.Id);
        System.assert(cases.size() > 0);
        for(Case c : cases){
            System.assertEquals(testCase.SuppliedEmail, c.SuppliedEmail);
            System.assertEquals(testCase.Reason, c.Reason);
        }
    }
    @isTest
    static void testCheckRecordInQueue(){
        Group testGroup = new Group(Name='test group', Type='Queue');
        insert testGroup;

        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
        }
        System.assert(!DuplicatedCasesController.checkRecordInQueue(UserInfo.getUserId()));
        System.assert(DuplicatedCasesController.checkRecordInQueue(testGroup.Id));
    }
    @isTest
    static void testSendBellNotification(){
        Case testCase = [
                            SELECT Id, CaseNumber, OwnerId
                            FROM Case
                            LIMIT 1
        ];
        Test.startTest();
        DuplicatedCasesController.sendBellNotification(testCase.OwnerId, testCase.CaseNumber, testCase.Id);
        Test.stopTest();
        List<FeedItem> notifications = [
                                            SELECT Id, ParentId
                                            FROM FeedItem
        ];
        System.assert(notifications.size()>0);
        for(FeedItem notification : notifications){
            System.assertEquals(testCase.OwnerId, notification.ParentId);
        }
    }
    @isTest
    static void testMergingCases(){
        List<Case> testCases = [
                                    SELECT Id
                                    FROM Case
                                    LIMIT 2
        ];
          
        Test.startTest();
        DuplicatedCasesController.mergingCases(testCases[0].Id, testCases[1].Id);
        Test.stopTest();
        List<EmailMessage> emailMessages = [
                            SELECT Id, Subject
                            FROM EmailMessage
                            WHERE ParentId = :testCases[0].Id
        ];
        for(EmailMessage em : emailMessages){
            System.assertEquals('Opt Out Test Message', em.Subject);
        }
        List<Case> mergedCases = [
                                    SELECT Id, Status
                                    FROM Case
                                    WHERE ParentId != NULL
        ];
        for(Case c : mergedCases){
            System.assertEquals('Closed', c.Status);
        }
    }
}