public with sharing class Patient360Service {

    public class PatientSummaryWrapper {
        @AuraEnabled public Id patientId;
        @AuraEnabled public String name;
        @AuraEnabled public Date birthDate;
       // @AuraEnabled public String gender;
        @AuraEnabled public String phone;
       // @AuraEnabled public String bloodType;
    }

    @AuraEnabled(cacheable=true)
    public static PatientSummaryWrapper getPatientSummary(Id patientId){

        Account patient = [
            SELECT Id,
                   Name,
                   PersonBirthdate,
                   PersonMobilePhone,
                   PersonMailingCity
                   
            FROM Account
            WHERE Id = :patientId
            LIMIT 1
        ];

        PatientSummaryWrapper wrapper = new PatientSummaryWrapper();

        wrapper.patientId = patient.Id;
        wrapper.name = patient.Name;
        wrapper.birthDate = patient.PersonBirthdate;
        wrapper.phone = patient.PersonMobilePhone;
        

        return wrapper;
    }
}