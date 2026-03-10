import { LightningElement, api, wire } from 'lwc';
import getPatient360Data from '@salesforce/apex/Patient360Service.getPatient360Data';

export default class PatientSummary extends LightningElement {

    @api recordId;

    patient;
    error;

    @wire(getPatient360Data, { patientId: '$recordId' })
    wiredPatient({ error, data }) {

        if(data){
            this.patient = data.patient;
            this.error = undefined;
        }
        else if(error){
            this.error = error;
            this.patient = undefined;
        }

    }
}