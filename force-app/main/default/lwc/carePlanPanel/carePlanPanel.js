import { LightningElement, api, wire } from 'lwc';
import getCarePlans from '@salesforce/apex/Patient360Service.getCarePlans';

export default class CarePlanPanel extends LightningElement {

    @api recordId;

    carePlans = [];

    @wire(getCarePlans,{patientId:'$recordId'})
    wiredCarePlans({data,error}){

        if(data){
            this.carePlans = data;
        }

        if(error){
            console.error(error);
        }

    }

}