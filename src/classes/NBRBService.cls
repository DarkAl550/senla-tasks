public with sharing class NBRBService extends ObjectSchemaManager {
    public class Rate{
        public String Cur_Abbreviation { get; set; }
        public Decimal Cur_OfficialRate { get; set; }
    }
    @future(callout=true)
    public static void getRate(){
        HttpRequest request = new HttpRequest();
        request.setEndpoint( getAPI() );
        request.setMethod('GET');
        request.setTimeout(60000);
        HttpResponse response = new Http().send(request);
        List<Rate> rates = (List<Rate>) JSON.deserialize(response.getBody(), List<Rate>.class);

        Rates__c ratesSetting = Rates__c.getOrgDefaults();
        Map<String,Schema.SObjectField> ratesFields = getFields('Rates__c');
        for(Rate rate : rates){
            for(String field : ratesFields.keyset()){
                if(rate.Cur_Abbreviation == ratesFields.get(field).getDescribe().getLabel() 
                    && rate.Cur_OfficialRate != null){
                    ratesSetting.put(field, rate.Cur_OfficialRate);
                }
            }
        }
        upsert ratesSetting;
    }

    private static String getAPI(){
        API_Service__mdt nbrbService = [
                                            SELECT API_Key__c
                                            FROM API_Service__mdt
                                            WHERE Label = 'NBRB Service'
        ];
        return nbrbService.API_Key__c;
    } 
}