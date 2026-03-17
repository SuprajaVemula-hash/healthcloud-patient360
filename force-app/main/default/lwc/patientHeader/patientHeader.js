// import { LightningElement, api, wire } from 'lwc';
// import { getRecord } from 'lightning/uiRecordApi';

// const FIELDS = [
// 'Account.Name',
// 'Account.PersonBirthdate',
// 'Account.PersonMobilePhone',
// 'Account.PersonEmail',
// 'Account.PersonMailingCity'
// ];

// export default class PatientHeader extends LightningElement {

//     @api recordId;

//     patient;

//     @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
//     wiredPatient({ error, data }) {

//         if(data){
//             this.patient = data.fields;
//         }

//         if(error){
//             console.error(error);
//         }

//     }

// }
import { LightningElement, api, wire } from 'lwc';
import getPatient from '@salesforce/apex/Patient360Service.getPatient360Data';
import getPatientPhoto from '@salesforce/apex/Patient360Service.getPatientPhoto';

export default class PatientHeader extends LightningElement {

    @api recordId;
    photoUrl;

    patient;

    @wire(getPatient, { patientId: '$recordId' })
    wiredPatient({data,error}){

        if(data){
            this.patient = data.patient;
        }

        if(error){
            console.error(error);
        }

    }
    @wire(getPatientPhoto, { patientId: '$recordId' })
wiredPhoto({data,error}){

    if(data){
        this.photoUrl = data;
    }

    if(error){
        console.error(error);
    }
}

}