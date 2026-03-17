import { LightningElement, api, wire } from 'lwc';
import getAppointments from '@salesforce/apex/Patient360Service.getAppointments';

export default class AppointmentsPanel extends LightningElement {

    @api recordId;

    appointments;

    @wire(getAppointments, { patientId: '$recordId' })
    wiredAppointments({ error, data }) {

        if(data){
            this.appointments = data;
        }

        if(error){
            console.error(error);
        }

    }

}