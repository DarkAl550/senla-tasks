public with sharing class CardreamCommunityContentController extends ObjectSchemaManager {
    @AuraEnabled
    public static List<String> getRateAbriviatures(){
        List<String> rateAbriviatures = new List<String>();
        Map<String,Schema.SObjectField> ratesFields = getFields('Rates__c');
        for(String field : ratesFields.keyset()){
            if(field.split('_')[0].split('').size() == 3){
                rateAbriviatures.add(ratesFields.get(field).getDescribe().getLabel());
            }
        }
        return rateAbriviatures;
    }
    @AuraEnabled
    public static List<Product2> getProducts(String searchValue, Integer price, Integer loadedRecords){
        String query = 'SELECT Id, Name, Price__c, Year__c, (SELECT Id, Name FROM Attachments) FROM Product2 WHERE IsActive = true ';
        if(!String.isEmpty(searchValue)) query += 'AND Name LIKE \'%' + searchValue + '%\' ';
        query += 'AND Price__c < '+price;
        query += ' ORDER BY Name ASC LIMIT 8 OFFSET '+loadedRecords;
        List<Product2> products = Database.query(query);
        return products;
    }
    @AuraEnabled
    public static Decimal getRateAttribute(String abriviature){
        Rates__c ratesSetting = Rates__c.getOrgDefaults();
        return (Decimal)ratesSetting.get(abriviature);
    }
    @AuraEnabled
    public static List<Product2> getSelectedProduct(String productId){
        List<Product2> products = [
                                    SELECT Id, Name, Description, Year__c, Price__c,
                                        (SELECT Id, Name FROM Attachments)
                                    FROM Product2
                                    WHERE Id = :productId
        ];
        return products;
    }
}