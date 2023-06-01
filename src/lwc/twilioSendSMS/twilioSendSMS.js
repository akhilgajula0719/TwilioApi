import { LightningElement,track,api } from 'lwc';
import SendSMS from '@salesforce/apex/TwilioSMS.sendSMS';
export default class TwilioSendSMS extends LightningElement {

@track message;
handelChange(event){
    this.message = event.target.value;
    //alert('Message'+this.message);
}
@api async handleClick(){
await SendSMS({textmessage:this.message}).then(result => {
//console.log('daya');
}).catch();
}
}