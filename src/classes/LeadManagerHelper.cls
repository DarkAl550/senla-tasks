public abstract class LeadManagerHelper {
    public static List<String> getRequiredFields(String objAPI){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe() ;
        Schema.SObjectType objType = schemaMap.get(objAPI) ;
        Schema.DescribeSObjectResult objResult = objType.getDescribe() ;
        Map<String,Schema.SObjectField> fields = objResult.fields.getMap() ;
        List<String> requiredFields = new List<String>();
        for(String field : fields.keyset())
        {
            Schema.DescribeFieldResult desribeResult = fields.get(field).getDescribe();
            if( desribeResult.isCreateable() && !desribeResult.isNillable() 
                && !desribeResult.isDefaultedOnCreate() )
            {
                requiredFields.add(field);
            }
        }
        return requiredFields;
    }
}