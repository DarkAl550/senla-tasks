public with sharing class ProductTriggerHandler extends TriggerHandler{
    protected override void afterUpdate(){
        List<Id> unactiveProductIds = new List<Id>();
        for(sObject obj : Trigger.new){
            Product2 product = (Product2) obj;
            if(!product.IsActive){
                unactiveProductIds.add(product.Id);
            }
        }
        if(!unactiveProductIds.isEmpty()){
            createTaskForOpportunity(unactiveProductIds);
        }
    }

    private static void createTaskForOpportunity(List<Id> unactiveProductIds){
        List<OpportunityLineItem> opportunityProducts = [
                                                            SELECT OpportunityId
                                                            FROM OpportunityLineItem
                                                            WHERE Product2Id IN :unactiveProductIds AND OpportunityId != NULL
        ];
        if(opportunityProducts.isEmpty()) return;
        List<Task> newTasks = new List<Task>();
        for(OpportunityLineItem opportunityProduct : opportunityProducts){
            Task newTask = new Task(
                Subject = 'Old model deal!!!',
                Status = 'New',
                Auto_Created__c = true,
                ActivityDate = Date.newInstance(Date.today().year(), Date.today().month(), 1),
                Priority = 'High'
            );
            newTasks.add(newTask);
        }
        insert newTasks;
    }
}