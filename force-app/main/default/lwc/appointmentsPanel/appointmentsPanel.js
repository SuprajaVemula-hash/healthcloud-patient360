import { LightningElement, api, wire } from 'lwc';
import getPatient360Data from '@salesforce/apex/Patient360Service.getPatient360Data';

export default class AppointmentsPanel extends LightningElement {

    @api recordId;

    appointments;
    error;

    @wire(getPatient360Data, { patientId: '$recordId' })
    wiredData({ error, data }) {

        if(data){
            this.appointments = data.appointments;
            this.error = undefined;
        }
        else if(error){
            this.error = error;
            this.appointments = undefined;
        }

    }

}