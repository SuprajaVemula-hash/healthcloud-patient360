import { LightningElement, api, wire } from 'lwc';
import getPatient360Data from '@salesforce/apex/Patient360Service.getPatient360Data';

export default class LabResultsPanel extends LightningElement {

    @api recordId;

    labResults;
    error;

    @wire(getPatient360Data, { patientId: '$recordId' })
    wiredData({ error, data }) {

        if (data) {
            this.labResults = data.labResults;
            this.error = undefined;
        } 
        else if (error) {
            this.error = error;
            this.labResults = undefined;
        }

    }

}