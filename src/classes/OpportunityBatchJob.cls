global class OpportunityBatchJob implements Schedulable {
    global void execute(SchedulableContext ctx) {
        OpportunityBatch opportunityBatch = new OpportunityBatch();
        Id batchId = Database.executeBatch(opportunityBatch);
    }
}