import { LightningElement, api, wire } from 'lwc';
import getPatient360Data from '@salesforce/apex/Patient360Service.getPatient360Data';

export default class MedicationsPanel extends LightningElement {

    @api recordId;

    medications;
    error;

    @wire(getPatient360Data, { patientId: '$recordId' })
    wiredData({ error, data }) {

        if(data){
            this.medications = data.medications;
            this.error = undefined;
        }
        else if(error){
            this.error = error;
            this.medications = undefined;
        }

    }

}