trigger ProductTrigger on Product2 (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Trigger.isUpdate && Trigger.isAfter){
        ProductTriggerHandler.afterUpdate();
    }
}