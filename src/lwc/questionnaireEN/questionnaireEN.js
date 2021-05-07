import { LightningElement, track } from 'lwc';
import saveQuestionnaire from '@salesforce/apex/QuestionnaireController.saveQuestionnaire';
 

export default class QuestionnaireRU extends LightningElement {
    @track rating = 1;
    @track description = '';
    @track email = '';
    @track completeSendQuestionnaire = false;
    @track errorMessage = false;
    @track message;
  
    handleButtonClick(){
        const regex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
        if(regex.test(this.email)){
            saveQuestionnaire({ email: this.email, rating: this.rating, description: this.description })
            .then(result => {
                this.completeSendQuestionnaire = result;
                if(!this.completeSendQuestionnaire){
                    this.message = "This Email is not Customer Email!";
                    this.errorMessage = true;
                } 
            })
            .catch(error => {
                this.error = error;
            });
        }else{
            this.message = "Invalid Email";
            this.errorMessage = true;
        }
        
    }
    handleEmailFieldChanges(event){
        this.email = event.target.value;
    }
    handleRatingChanges(event){
        this.rating = event.target.value;
    }
    handlDescriptionFieldChanges(event){
        this.description = event.target.value;
    }

}