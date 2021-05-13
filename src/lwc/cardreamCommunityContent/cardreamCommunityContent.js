import { LightningElement, track } from 'lwc';
import NOIMAGE from '@salesforce/resourceUrl/noImage';
import SPINNER from '@salesforce/resourceUrl/community_spiner';
import SEARCHICON from '@salesforce/resourceUrl/SearchIcon';
import getProducts from '@salesforce/apex/CardreamCommunityContentController.getProducts';
import getSelectedProduct from '@salesforce/apex/CardreamCommunityContentController.getSelectedProduct';
import getRateAbriviatures from '@salesforce/apex/CardreamCommunityContentController.getRateAbriviatures';
import getRateAttribute from '@salesforce/apex/CardreamCommunityContentController.getRateAttribute';

export default class CardreamCommunityContent extends LightningElement {
    @track sliderValue = 100000;
    @track searchValue = '';
    @track selectedRate = 'BLR__c';
    @track rateValue = 1;
    @track products = [];
    @track rateOptions = [];
    @track isAllProducts = false;
    @track isModalOpen = false;
    @track selectedProduct = {};
    @track images = [];
    @track isLoadedProduct = false;
    @track isFormError = false;
    @track errorMessage;
    spinner = SPINNER;
    searchIcon = SEARCHICON;
    error;

    connectedCallback(){
        this.getProductsFromApex();
        this.getRatesAbriviature();   
        window.addEventListener('scroll', (event) => {this.handleScroll(event)});
    }
    getProductsFromApex(){
        getProducts({ searchValue: this.searchValue, price: this.sliderValue, rate: this.selectedRate, loadedRecords:this.products.length})
        .then(result => {
            this.isAllProducts = false;
            if(!result.length || result.length < 8) this.isAllProducts = true; 
            for(let i=0; i<result.length; i++){
                this.products.push({ 
                    "id" : result[i].Id, 
                    "name" : result[i].Name, 
                    "price" : result[i].Price__c * this.rateValue,
                    "year" : result[i].Year__c,
                    "imageUrl" : NOIMAGE
                });
                try{
                    if(this.products.length < 8) this.products[i].imageUrl = "https://senla-6f-dev-ed--c.documentforce.com/servlet/servlet.FileDownload?file="+result[i].Attachments[0].Id;
                    else this.products[i+result.length].imageUrl = "https://senla-6f-dev-ed--c.documentforce.com/servlet/servlet.FileDownload?file="+result[i].Attachments[0].Id;
                }catch(e){}
            }
        })
        .catch(error => {
            this.error = error;
        });
    }
    getRatesAbriviature(){
        getRateAbriviatures()
        .then(result =>{
            this.rateOptions = [];
            for(let i=0; i<result.length; i++){
                this.rateOptions.push(
                    { label: result[i], value: result[i] + '__c' }
                );
            }
        })
        .catch(error => {
            this.error = error;
        });
    }
    handleSliderChanges(event){
        this.sliderValue = event.target.value;
    }
    handleKeyUp(event) {
        const isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
            this.searchValue = event.target.value;
            this.products = [];
            this.isAllProducts = false;
            this.getProductsFromApex();
        }
    }
    handleComboboxChanges(event){
        this.selectedRate = event.detail.value;
        getRateAttribute({abriviature: this.selectedRate})
        .then(result=>{
            for(let i=0; i<this.products.length; i++){
                if(this.rateValue == 1) this.products[i].price = Math.round(this.products[i].price / result);
                else this.products[i].price = Math.round(this.products[i].price * this.rateValue / result);
            }
            this.rateValue = result;
        })
        .catch(error =>{
            this.error = error;
        })
        
    }
    handleOnProductClick(event){
        let productId = event.target.id;
        this.images = [];
        this.isLoadedProduct = false;
        this.isModalOpen = true;
        getSelectedProduct({productId : productId.split("-")[0]})
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
    handleScroll(event) { 
        const container = event.target.body
        const {clientHeight, scrollHeight, scrollY: scrollTop} = container
        if (clientHeight + scrollY >= scrollHeight) {
            this.getProductsFromApex();
        }
    }
    closeModal(){
        this.isModalOpen = false;
    }
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