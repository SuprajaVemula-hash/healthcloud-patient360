import { LightningElement, api, wire } from 'lwc';
import getTimeline from '@salesforce/apex/Patient360Service.getTimeline';

export default class TimelinePanel extends LightningElement {
    @api recordId;
timeline = [];

@wire(getTimeline, { patientId: '$recordId' })
wiredTimeline({data, error}){

    if(data){
        this.timeline = data;
    }

    if(error){
        console.error(error);
    }

}
get formattedTimeline() {
    if (!this.timeline) return [];
    return this.timeline.map(event => ({
        ...event,
        formattedDate: event.eventDate ? new Date(event.eventDate).toLocaleDateString() : 'N/A'
    }));
}
getIcon(type){

    if(type === 'Condition') return '🩺';
    if(type === 'Medication') return '💊';
    if(type === 'Observation') return '🧪';

    return '📌';

}

}