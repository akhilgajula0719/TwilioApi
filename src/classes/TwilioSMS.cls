public class TwilioSMS {
    //Twilo API Callout method
    public void processSms(String textmessage){
        if(textmessage==''){
            textmessage='This is sample message';
        }
        Map<String, Twilio_Info__mdt> mapTwilioCodes = Twilio_Info__mdt.getAll();
        String phNumber = mapTwilioCodes.get('phNumber').Value__c;
        String accountSid = mapTwilioCodes.get('accountSid').Value__c;
        String token = mapTwilioCodes.get('token').Value__c;
        String fromPhNumber = mapTwilioCodes.get('fromPhNumber').Value__c;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(mapTwilioCodes.get('endpoint').Value__c);
        req.setMethod('POST'); 
        Blob headerValue = Blob.valueOf(accountSid+':'+token);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', mapTwilioCodes.get('contenttype').Value__c);
        String body = EncodingUtil.urlEncode('From=%2B'+phNumber+'&To=%2B'+fromPhNumber+'&Body='+'', 'UTF-8');
        req.setBody(body);
        try{
            Http ht = new Http();
            HttpResponse res = ht.send(req); 
            if(res.getStatus()!='200'){
                //API error log
                createLog('API', res.getBody(),'TwilioSMS',String.valueOf(req),String.valueOf(res));
            }
        }
        Catch(Exception e){
            //Salesforce internal failure error log
            createLog('Internal', e.getMessage(),'TwilioSMS',String.valueOf(req),'');
        }
        
    }
    //method calling from LWC
    @AuraEnabled(cacheable=false)
    public static string sendSMS(String textmessage) {
        system.debug('hello testing:'+textmessage);
        TwilioSMS twilio = new TwilioSMS();
        twilio.processSms(textmessage);
        return textmessage;
    }
    //Insert error in to log object
    public void createLog(String logtype, String error, String errorclass, String request, String response){
        Log__c log = new Log__c(Log_Type__c = logtype, Error__c = error,Class_Name__c= errorclass, Request__c = request,Response__c=response);
        insert log;
    }
}