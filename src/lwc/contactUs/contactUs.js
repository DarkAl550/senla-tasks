import { LightningElement, track } from 'lwc';
 
export default class ContactUs extends LightningElement {
    @track errorMessage;

    setPriority(){
        let reason = this.template.querySelector('[data-id="reason"]');
        let priority = this.template.querySelector('[data-id="priority"]');
        if(reason.value === 'Financial Claim') priority.value = 'High';
        else priority.value = 'Medium';
    }
    emailValid(){
        this.isFormError = false;
        let email = this.template.querySelector('[data-id="email"]');
        const regex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
        if(!regex.test(email.value)){
            this.errorMessage = "Ivalid Email";
            this.isFormError = true;
            email.value = "";
        }
    }   
}