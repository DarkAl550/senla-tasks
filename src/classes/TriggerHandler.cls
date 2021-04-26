public virtual class TriggerHandler {
    public virtual void run(){
        if(Trigger.isInsert && Trigger.isBefore){
            beforeInsert();
        }else if (Trigger.isInsert && Trigger.isAfter){
            afterInsert();
        }else if(Trigger.isUpdate && Trigger.isBefore){
            beforeUpdate();
        }else if(Trigger.isUpdate && Trigger.isAfter){
            afterUpdate();
        }else if(Trigger.isDelete && Trigger.isBefore){
            beforeDelete();
        }else if(Trigger.isDelete && Trigger.isAfter){
            afterDelete();
        }
    }
    
    protected virtual void beforeInsert(){}
    protected virtual void afterInsert(){}
    protected virtual void beforeUpdate(){}
    protected virtual void afterUpdate(){}
    protected virtual void beforeDelete(){}
    protected virtual void afterDelete(){}
}