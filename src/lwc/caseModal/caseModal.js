import { LightningElement, track, api } from 'lwc';
import mergingCases from '@salesforce/apex/DuplicatedCasesController.mergingCases';
import sendBellNotification from '@salesforce/apex/DuplicatedCasesController.sendBellNotification';

export default class CaseModal extends LightningElement {
    @api owner;
    @api number;
    @api record;
    @api child;
    @track isSendNotification;
    error;

    closeModal(){
        const event = new CustomEvent('child', {
            detail: { isModalOpen : false }
        });
        this.dispatchEvent(event);
    }
    merging(){

        if(this.isSendNotification){
            sendBellNotification({ownerId:this.owner, caseNumber:this.number, caseId:this.child});
        }
        mergingCases({ parentId: this.record, childId: this.child})
        .then(result =>{
            this.closeModal();
        })
        .catch(error =>{
            this.error = error;
        })
    }
    handleCheckboxValue(event){
        this.isSendNotification = event.target.checked;
    }
}