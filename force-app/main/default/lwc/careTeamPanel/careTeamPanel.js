import { LightningElement, api, wire } from 'lwc';
import getCareTeam from '@salesforce/apex/Patient360Service.getCareTeam';

export default class CareTeamPanel extends LightningElement {

    @api recordId;

    careTeam;

    @wire(getCareTeam, { patientId: '$recordId' })
    wiredCareTeam({ error, data }) {

        if(data){
            this.careTeam = data;
            console.log(JSON.stringify(data));
        }

        if(error){
            console.error(error);
        }

    }

}