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
            SELECT Id, Name, PersonBirthdate, PersonMobilePhone
            FROM Account
            WHERE Id = :patientId
            LIMIT 1
        ];

       
        wrapper.appointments = [
            SELECT Id, Appointment_Date__c, Status__c, Reason__c
            FROM Appointment__c
            WHERE Patient__c = :patientId
            ORDER BY Appointment_Date__c DESC
        ];

       
        wrapper.medications = [
            SELECT Id, Medicine_Name__c, Dosage__c, Start_Date__c
            FROM Medication__c
            WHERE Patient__c = :patientId
        ];

       
        wrapper.labResults = [
            SELECT Id, Test_Name__c, Result__c, Test_Date__c
            FROM Lab_Result__c
            WHERE Patient__c = :patientId
        ];

        
        wrapper.insurance = [
            SELECT Id, Provider_Name__c, Policy_Number__c, Coverage_Status__c
            FROM Insurance__c
            WHERE Patient__c = :patientId
        ];

        return wrapper;
    }
}