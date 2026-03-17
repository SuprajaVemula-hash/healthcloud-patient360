import { LightningElement, api, wire } from 'lwc';
import getConditions from '@salesforce/apex/Patient360Service.getConditions';

export default class ConditionsPanel extends LightningElement {

    @api recordId;

    conditions;

    @wire(getConditions, { patientId: '$recordId' })
    wiredConditions({ error, data }) {

        if(data){
            this.conditions = data;
        }

        if(error){
            console.error(error);
        }

    }

}