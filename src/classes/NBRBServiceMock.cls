@isTest
global with sharing class NBRBServiceMock implements HttpCalloutMock{
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"Cur_Abbreviation":"USD", "Cur_OfficialRate":1.9928}]');
        res.setStatusCode(200);
        return res;
    }
}