
@isTest
public class Patient360ServiceTest {

 @isTest
    static void testPatient360Service(){

        
        Account patient = new Account(
            Name = 'Test Patient'
        );
        insert patient;

        
        Doctor__c doctor = new Doctor__c(
            Name = 'Dr Test',
            Specialization__c = 'Cardiology'
        );
        insert doctor;

      
        Appointment__c appt = new Appointment__c(
            Patient__c = patient.Id,
            Doctor__c = doctor.Id,
            Appointment_Date__c = Date.today(),
            Status__c = 'Scheduled',
            Reason__c = 'Chest Pain'
        );
        insert appt;

        
        Medication__c med = new Medication__c(
            Patient__c = patient.Id,
            Medicine_Name__c = 'Metformin',
            Dosage__c = '500mg',
            Start_Date__c = Date.today()
        );
        insert med;

        
        Lab_Result__c lab = new Lab_Result__c(
            Patient__c = patient.Id,
            Test_Name__c = 'Blood Sugar',
            Result__c = '120 mg/dL',
            Test_Date__c = Date.today()
        );
        insert lab;

       
        Insurance__c ins = new Insurance__c(
            Patient__c = patient.Id,
            Provider_Name__c = 'BlueCross',
            Policy_Number__c = 'BC12345',
            Coverage_Status__c = 'Active'
        );
        insert ins;

        Test.startTest();

        Patient360Service.Patient360Wrapper result =
            Patient360Service.getPatient360Data(patient.Id);

        Test.stopTest();

        
        System.assertNotEquals(null, result);
        System.assertEquals(patient.Id, result.patient.Id);
        System.assertEquals(1, result.appointments.size());
        System.assertEquals(1, result.medications.size());
        System.assertEquals(1, result.labResults.size());
        System.assertEquals(1, result.insurance.size());
    }
}