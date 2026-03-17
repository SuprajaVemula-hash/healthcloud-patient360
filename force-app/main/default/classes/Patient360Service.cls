public with sharing class Patient360Service {

    public class Patient360Wrapper {

        @AuraEnabled public Account patient;
        @AuraEnabled public List<Appointment__c> appointments;
        @AuraEnabled public List<Medication__c> medications;
        @AuraEnabled public List<Lab_Result__c> labResults;
        @AuraEnabled public List<Insurance__c> insurance;
    }

    @AuraEnabled(cacheable=true)
    public static Patient360Wrapper getPatient360Data(Id patientId){

        Patient360Wrapper wrapper = new Patient360Wrapper();

        
        wrapper.patient = [
            SELECT Id, Name, PersonBirthdate, PersonMobilePhone, PersonEmail,PersonMailingCity
            FROM Account
            WHERE Id = :patientId
            LIMIT 1
        ];

       
        wrapper.appointments = [
            SELECT Id, Appointment_Date__c, Status__c, Reason__c
            FROM Appointment__c
            WHERE Patient__c = :patientId
            ORDER BY Appointment_Date__c DESC
            LIMIT 20
        ];

       
        wrapper.medications = [
            SELECT Id, Medicine_Name__c, Dosage__c, Start_Date__c
            FROM Medication__c
            WHERE Patient__c = :patientId
            ORDER BY Start_Date__c DESC
            LIMIT 20
        ];

       
        wrapper.labResults = [
            SELECT Id, Test_Name__c, Result__c, Test_Date__c
            FROM Lab_Result__c
            WHERE Patient__c = :patientId
            ORDER BY Test_Date__c DESC
            LIMIT 20
        ];

        
        wrapper.insurance = [
            SELECT Id, Provider_Name__c, Policy_Number__c, Coverage_Status__c
            FROM Insurance__c
            WHERE Patient__c = :patientId
            LIMIT 10
        ];

        return wrapper;
    }
   public class TimelineEvent {

    @AuraEnabled public String id;
    @AuraEnabled public String title;
    @AuraEnabled public String type;
    @AuraEnabled public String status;
    @AuraEnabled public Datetime eventDate;

}
@AuraEnabled(cacheable=true)
public static List<TimelineEvent> getTimeline(Id patientId){

    List<TimelineEvent> timeline = new List<TimelineEvent>();

  
    for(HealthCondition c : [
        SELECT Id,
               Condition_Name__c,
               OnsetStartDateTime,
               ConditionStatus,
               DiagnosticStatus
        FROM HealthCondition
        WHERE PatientId = :patientId
        ORDER BY OnsetStartDateTime DESC
        LIMIT 20
    ]){

        TimelineEvent e = new TimelineEvent();
        e.id = c.Id;
        e.title = c.Condition_Name__c;
        e.type = 'Condition';
        e.status = c.ConditionStatus;
        e.eventDate = c.OnsetStartDateTime;

        if(e.eventDate != null){
            timeline.add(e);
        }
    }

    
    for(MedicationRequest m : [
        SELECT Id, Medication_Request_Name__c, MedicationCodeId, Status, PrescribedDate
        FROM MedicationRequest
        WHERE PatientId = :patientId
        ORDER BY PrescribedDate DESC
        LIMIT 20
    ]){

        TimelineEvent e = new TimelineEvent();
        e.id = m.Id;
        e.title = m.Medication_Request_Name__c;
        e.type = 'Medication';
        e.status = m.Status;
        e.eventDate = m.PrescribedDate;

        if(e.eventDate != null){
            timeline.add(e);
        }
    }

   
    for(CareObservation o : [
        SELECT Id,
               Name,
               ObservedValueType,
               ObservedValueText,
               ObservationStartTime
        FROM CareObservation
        WHERE ObservedSubjectId = :patientId
        ORDER BY ObservationStartTime DESC
        LIMIT 20
    ]){

        TimelineEvent e = new TimelineEvent();
        e.id = o.Id;
        e.title = o.Name;
        e.type = 'Observation';
        e.status = o.ObservedValueText;
        e.eventDate = o.ObservationStartTime;

        if(e.eventDate != null){
            timeline.add(e);
        }
    }

   
    
    timeline.sort(new TimelineComparator());

    return timeline;
}

public class TimelineComparator implements System.Comparator<TimelineEvent> {
    public Integer compare(TimelineEvent a, TimelineEvent b) {
        if (a.eventDate == b.eventDate) return 0;
        if (a.eventDate > b.eventDate) return -1;
        return 1;
    }
}


@AuraEnabled(cacheable=true)
public static List<HealthCondition> getConditions(Id patientId){

    return [
        SELECT Id,
               Condition_Name__c,
               OnsetStartDateTime,
               ConditionStatus,
               DiagnosticStatus
        FROM HealthCondition
        WHERE PatientId = :patientId
        ORDER BY OnsetStartDateTime DESC
        LIMIT 20
    ];

}
@AuraEnabled(cacheable=true)
public static List<CareProgramTeamMember> getCareTeam(Id patientId){

    return [
      SELECT Id,
       MemberId,
       Role,
       Status__c,
       TYPEOF Member
           WHEN HealthcareProvider THEN Name
           WHEN HealthcarePractitionerFacility THEN Name
       END
FROM CareProgramTeamMember
    WHERE AccountId = :patientId
    LIMIT 10
    ];

}
@AuraEnabled(cacheable=true)
public static List<Appointment__c> getAppointments(Id patientId){

    return [
        SELECT Id,
               Appointment_Date__c,
               Status__c,
               Doctor__r.Name
        FROM Appointment__c
        WHERE Patient__c = :patientId
        ORDER BY Appointment_Date__c DESC
        LIMIT 20
    ];

}
@AuraEnabled(cacheable=true)
public static List<CareObservation> getVitals(Id patientId){

    return [
        SELECT Id,
               Name,
               ObservedValueType,
               ObservedValueText,
               ObservationStartTime
        FROM CareObservation
        WHERE ObservedSubjectId = :patientId
        ORDER BY ObservationStartTime DESC
        LIMIT 20
    ];

}
@AuraEnabled(cacheable=true)
public static List<Medication__c> getMedications(Id patientId){

    return [

        SELECT Id,
               Name,
               Medicine_Name__c,
               Dosage__c,
               Start_Date__c
        FROM Medication__c
        WHERE Patient__c = :patientId
        ORDER BY CreatedDate DESC
        LIMIT 20

    ];

}
@AuraEnabled(cacheable=true)
public static List<CarePlan> getCarePlans(Id patientId){

    return [

        SELECT Id,
               Name,
               Description,
               Status,
               StartDate
        FROM CarePlan
        WHERE ParticipantId = :patientId
        ORDER BY CreatedDate DESC
        LIMIT 10

    ];

}
@AuraEnabled(cacheable=true)
public static List<Task> getCommunicationHistory(Id patientId){

    return [

        SELECT Id,
               Subject,
               ActivityDate,
               Status
        FROM Task
        WHERE WhatId = :patientId
        ORDER BY ActivityDate DESC
        LIMIT 10

    ];

}
@AuraEnabled(cacheable=true)
public static String getPatientPhoto(Id patientId){

    List<ContentDocumentLink> links = [
        SELECT ContentDocumentId
        FROM ContentDocumentLink
        WHERE LinkedEntityId = :patientId
        LIMIT 1
    ];

    if(links.isEmpty()){
        return null;
    }

    return '/sfc/servlet.shepherd/document/download/' + links[0].ContentDocumentId;
}

}