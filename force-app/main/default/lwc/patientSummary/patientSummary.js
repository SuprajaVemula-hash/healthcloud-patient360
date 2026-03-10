import { LightningElement, api, wire } from 'lwc';
import getPatientSummary from '@salesforce/apex/Patient360Service.getPatientSummary';

export default class PatientSummary extends LightningElement {

    @api recordId;

    patient;
    error;
    connectedCallback(){
    console.log('Record Id -> ', this.recordId);
}

    @wire(getPatientSummary, { patientId: '$recordId' })
    wiredPatient({ error, data }) {

        if(data){
            this.patient = data;
            this.error = undefined;
        }
        else if(error){
            this.error = error;
            this.patient = undefined;
        }

    }

}