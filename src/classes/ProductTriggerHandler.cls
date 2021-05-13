public with sharing class ProductTriggerHandler{
    public static void afterUpdate(){
        List<Id> unActiveProductIds = new List<Id>();
        for(sObject obj : Trigger.new){
            Product2 product = (Product2) obj;
            if(!product.IsActive){
                unActiveProductIds.add(product.Id);
            }
        }
        if(!unActiveProductIds.isEmpty()){
            createTaskForOpportunity(unActiveProductIds);
        }
    }

    private static void createTaskForOpportunity(List<Id> unactiveProductIds){
        List<OpportunityLineItem> opportunityProducts = [
                                                            SELECT OpportunityId
                                                            FROM OpportunityLineItem
                                                            WHERE Product2Id IN :unactiveProductIds AND OpportunityId != NULL
        ];
        List<Id> opportunityIds = new List<Id>();
        for(OpportunityLineItem opportunityProduct : opportunityProducts){
            opportunityIds.add(opportunityProduct.OpportunityId);
        }
        List<Opportunity> opportunites = [
                                            SELECT Id, AccountId
                                            FROM Opportunity
                                            WHERE Id IN :opportunityIds
        ];
        List<Id> accountsIds = new List<Id>();
        for(Opportunity opportunity : opportunites){
            accountsIds.add(opportunity.AccountId);
        }
        List<Account> accounts = [
                                    SELECT Id, Phone 
                                    FROM Account
                                    WHERE Id IN :accountsIds
        ];

        if(accounts.isEmpty()) return;

        RecordType taskRecordType = [
                                    SELECT Id,SobjectType,Name 
                                    FROM RecordType
                                    WHERE Name = 'Call' and SobjectType = 'Task' 
                                    LIMIT 1
        ];
        List<Task> newTasks = new List<Task>();
        for(Account account : accounts){
            Task newTask = new Task(
                Subject = 'Old model deal!!!',
                Status = 'New',
                Auto_Created__c = true,
                ActivityDate = Date.newInstance(Date.today().year(), Date.today().month(), 1),
                Priority = 'High',
                Phone__c = account.Phone
            );
            newTask.RecordTypeId = taskRecordType.Id;
            newTasks.add(newTask);
        }
        insert newTasks;
    }
}