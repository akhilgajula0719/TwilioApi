import { LightningElement,track } from 'lwc';
import SendSMS from '@salesforce/apex/TwilioSMS.sendSMS';
export default class TwilioSendSMS extends LightningElement {

@track message;
handelChange(event){
    this.message = event.target.value;
    //alert('Message'+this.message);
}
handleClick(){
SendSMS({textmessage:this.message}).then(result => {
//console.log('daya');
}).catch();
}
}