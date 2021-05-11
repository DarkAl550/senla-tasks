import { LightningElement, api, wire, track} from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getDuplicatedCases from '@salesforce/apex/DuplicatedCasesController.getDuplicatedCases';
import checkRecordInQueue from '@salesforce/apex/DuplicatedCasesController.checkRecordInQueue';
import mergingCases from '@salesforce/apex/DuplicatedCasesController.mergingCases';
import sendBellNotification from '@salesforce/apex/DuplicatedCasesController.sendBellNotification';
 

export default class DuplicatedCases extends LightningElement {
    @api recordId;
    cases;
    @track isModalOpen = false;
    @track isSendNotification = false;
    @track childId;
    @track ownerId;
    @track caseNumber;
    columns = [
        { label: 'CaseNumber', fieldName: 'CaseNumber' },
        { label: 'Origin', fieldName: 'Origin' },
        { label: 'Email', fieldName: 'SuppliedEmail', type:'email' },
        { label: 'Status', fieldName: 'Status' },
        { label: 'Reason', fieldName: 'Reason' },
        { label: 'Owner', fieldName: 'Owner.Name' },
        { label: 'Action', type: 'button', typeAttributes: 
                                        { label: 'Merge', name: 'mergeRecord', variant: 'brand' }}
        
    ];

    @wire(getDuplicatedCases, { recordId : '$recordId' })
    cases;

    handleAction(event){
        let action = event.detail.action;
        switch (action.name) {
            case 'mergeRecord':
                let row = event.detail.row;
                this.childId = row.Id;
                this.caseNumber = row.CaseNumber;
                console.log(JSON.stringify(event.detail));
                
                checkRecordInQueue({ queueId: row.Owner.Id })
                .then(result => {
                    console.log(result);
                    if(!result && (row.Status == 'In progress' || row.Status == 'On Hold')){
                        this.ownerId = row.Owner.Id;
                        this.isModalOpen = true;
                        return;
                    }
                    mergingCases({ parentId: this.recordId, childId: row.Id});
                    refreshApex(this.cases);

                })
                .catch(error => {
                    this.error = error;
                });
                break;
        }
    }
    merging(){
        if(this.isSendNotification){
            sendBellNotification({ownerId:this.ownerId, caseNumber:this.caseNumber, caseId:this.childId});
        }
        mergingCases({ parentId: this.recordId, childId: this.childId})
        .then(result =>{
            this.isModalOpen = false;
        })
        .catch(error =>{
            this.error = error;
        })
        refreshApex(this.cases);
    }
    handleCheckboxValue(event){
        this.isSendNotification = event.target.checked;
    }
    closeModal(){
        this.isModalOpen = false;
    }
}