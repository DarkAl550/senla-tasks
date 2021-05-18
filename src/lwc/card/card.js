import { LightningElement, track, api } from 'lwc';
import SPINNER from '@salesforce/resourceUrl/community_spiner';
import getSelectedProduct from '@salesforce/apex/CardreamCommunityContentController.getSelectedProduct';

export default class Card extends LightningElement {
    spinner = SPINNER;
    @track images = [];
    @track item;
    @track selectedProduct;
    @track isLoadedProduct = false;
    @api product;

    closeModal(){
        const event = new CustomEvent('child', {
            detail: { isModalOpen : false }
        });
        this.dispatchEvent(event);
    }

    connectedCallback(){
        getSelectedProduct({productId : this.product})
        .then(result =>{
            if(result.length) {
                this.selectedProduct = result[0];
                try{
                    for(let i=0; i<this.selectedProduct.Attachments.length; i++){
                        this.images.push(
                            "https://senla-6f-dev-ed--c.documentforce.com/servlet/servlet.FileDownload?file="+this.selectedProduct.Attachments[i].Id
                        );
                    }
                }catch(e){
                    this.images.push(NOIMAGE);
                }
            }
            this.isLoadedProduct = true;
        })
        .catch(error =>{
            this.error = error;
        })
    }
}