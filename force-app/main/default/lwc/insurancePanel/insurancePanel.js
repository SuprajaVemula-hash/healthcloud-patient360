import { LightningElement, api, wire } from 'lwc';
import getPatient360Data from '@salesforce/apex/Patient360Service.getPatient360Data';

export default class InsurancePanel extends LightningElement {

    @api recordId;

    insuranceList;
    error;

    @wire(getPatient360Data, { patientId: '$recordId' })
    wiredData({ error, data }) {

        if (data) {
            this.insuranceList = data.insurance;
            this.error = undefined;
        } 
        else if (error) {
            this.error = error;
            this.insuranceList = undefined;
        }

    }

}