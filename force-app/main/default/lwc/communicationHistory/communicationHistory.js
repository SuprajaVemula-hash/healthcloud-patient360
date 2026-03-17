import { LightningElement, api, wire } from 'lwc';
import getCommunicationHistory from '@salesforce/apex/Patient360Service.getCommunicationHistory';

export default class CommunicationHistory extends LightningElement {

    @api recordId;

    communications = [];

    @wire(getCommunicationHistory,{patientId:'$recordId'})
    wiredCommunications({data,error}){

        if(data){
            this.communications = data;
        }

        if(error){
            console.error(error);
        }

    }

}