public abstract class ObjectSchemaManager {
    public static Map<String,Schema.SObjectField> getFields(String obj){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe() ;
        Schema.SObjectType objType = schemaMap.get(obj);
        Schema.DescribeSObjectResult objResult = objType.getDescribe() ;
        Map<String,Schema.SObjectField> fields = objResult.fields.getMap();
        return fields;
    }
}