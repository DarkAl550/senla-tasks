@isTest
public with sharing class CardreamCommunityContentControllerTest {
    @testSetup
    static void setup(){
        List<Product2> products = new List<Product2>();
        for(Integer i=0; i<10; i++){
            products.add(new Product2(
                Name='Test'+i,
                Year__c=Date.today().year(),
                Price__c=1.11,
                IsActive = true 
            ));
        }
        insert products;
    }
    @isTest
    static void testGetRateAbriviatures(){
        List<String> rateAbriviatures = CardreamCommunityContentController.getRateAbriviatures();
        System.assert(rateAbriviatures.contains('BLR'));
    }
    @isTest
    static void testGetProducts(){
        List<Product2> products = CardreamCommunityContentController.getProducts('', 10, 0);
        System.assert(products.size() == 8);
        for(Integer i=0; i<products.size(); i++){
            System.assertEquals('Test'+i, products[i].Name);
        }
    }
    @isTest
    static void testGetRateAttribute(){
        Rates__c ratesSetting = Rates__c.getOrgDefaults();
        ratesSetting.BLR__c = 1;
        upsert ratesSetting;
        Decimal rateAttribute = CardreamCommunityContentController.getRateAttribute('BLR__c');
        System.assertEquals(1, rateAttribute);
    }
    @isTest
    static void testGetSelectedProduct(){
        List<Product2> testProducts = [
                                        SELECT Id, Name, Year__c
                                        FROM Product2
                                        LIMIT 1
        ];
        List<Product2> products = CardreamCommunityContentController.getSelectedProduct(testProducts[0].Id);
        System.assert(products.size() == 1);
        for(Product2 p : products){
            System.assertEquals(testProducts[0].Name, p.Name);
            System.assertEquals(testProducts[0].Year__c, p.Year__c);
        }

    }
}