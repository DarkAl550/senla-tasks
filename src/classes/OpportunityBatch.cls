public with sharing class OpportunityBatch implements Database.Batchable<sObject>, Database.Stateful {
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, StageName, CloseDate '+
            'FROM Opportunity '+
            'WHERE CloseDate < LAST_MONTH AND StageName != \'Closed Won\' AND StageName != \'Closed Lost\''
        );
    }
    public void execute(Database.BatchableContext bc, List<Opportunity> opportunites){
        for(Opportunity opportunity : opportunites){
            opportunity.StageName = 'Closed Won';
            opportunity.CloseDate = Date.today();
            recordsProcessed += 1;
        }
        update opportunites;
    }
    public void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed successfuly!');
    }
}