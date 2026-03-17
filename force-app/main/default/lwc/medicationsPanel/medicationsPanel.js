import { LightningElement, api, wire } from 'lwc';
import getMedications from '@salesforce/apex/Patient360Service.getMedications';

export default class MedicationsPanel extends LightningElement {

    @api recordId;

    medications = [];

    @wire(getMedications, { patientId: '$recordId' })
    wiredMedications({data,error}){

        if(data){

            this.medications = data;

        }

        if(error){

            console.error(error);

        }

    }

}