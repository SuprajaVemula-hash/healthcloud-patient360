import { LightningElement, api, wire } from 'lwc';
import getVitals from '@salesforce/apex/Patient360Service.getVitals';

export default class VitalsPanel extends LightningElement {

    @api recordId;

    vitals;

    @wire(getVitals, { patientId: '$recordId' })
    wiredVitals({ error, data }) {

        if(data){
            this.vitals = data;
        }

        if(error){
            console.error(error);
        }

    }
    get formattedVitals() {
        if (!this.vitals) return [];
        return this.vitals.map(v => ({
            ...v,
            displayName: v.Name || 'Unknown',
            displayValue: v.ObservedValueText || 'N/A',
            displayDate: v.ObservationStartTime ? new Date(v.ObservationStartTime).toLocaleDateString() : 'N/A'
        }));
    }
getIcon(name){

    if(name.includes('Glucose')) return '🩸';
    if(name.includes('Blood')) return '🩺';
    if(name.includes('Cholesterol')) return '🧪';
    if(name.includes('Sugar test')) return '🩸';

    return '❤️';

}

}