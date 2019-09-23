@isTest
public class TestAssignCandidates {
    @testSetup
    static void setup() {
        String vacancyStatus = RecruitingAppConstants.INPROGRESS_STATUS;
        String candidateStatus = RecruitingAppConstants.VALIDATED_STATUS;
        Vacancy__c[] vacancies = TestDataFactory.createVacancies(1, vacancyStatus);
        Candidate__c[] candidates = TestDataFactory.createCandidates(3);

        for (Candidate__c candidate : candidates) {
            candidate.Status__c = candidateStatus;
        }

        update candidates;
    }

    @isTest
    private static void testGetCandidates() {
        List<SelectOption> options = new List<SelectOption>();
        String candidateStatus = RecruitingAppConstants.VALIDATED_STATUS;

        Vacancy__c vacancy = [SELECT Title__c FROM Vacancy__c WHERE Title__c = 'TestVacancy0' LIMIT 1];
        Candidate__c candidate = [SELECT FirstName__c FROM Candidate__c WHERE FirstName__c LIKE 'TestCandidate%' AND Status__c = :candidateStatus LIMIT 1];

        TestDataFactory.createVca(vacancy.Id, candidate.Id);

        PageReference pref = new PageReference('/' + vacancy.Id);
        pref.getParameters().put('id', vacancy.Id);
        Test.setCurrentPage(pref);

        ApexPages.StandardController stdCtr = new ApexPages.StandardController(vacancy);
        AssignCandidatesController assignCandidatesController = new AssignCandidatesController(stdCtr);

        options = assignCandidatesController.getCandidates();
        System.assertEquals(2, options.size());
    }

    @isTest
    private static void TestAssignCandidates() {
        List<String> selectedCandidates = new List<String>();
        String candidateStatus = RecruitingAppConstants.VALIDATED_STATUS;

        Vacancy__c vacancy = [SELECT Title__c FROM Vacancy__c WHERE Title__c = 'TestVacancy0' LIMIT 1];
        String vacancyId = vacancy.Id;

        Candidate__c[] candidates = [SELECT FirstName__c FROM Candidate__c WHERE FirstName__c LIKE 'TestCandidate%' AND Status__c = :candidateStatus LIMIT 2];

        for (Candidate__c candidate : candidates) {
            selectedCandidates.add(candidate.Id);
        }

        PageReference pref = new PageReference('/' + vacancyId);
        pref.getParameters().put('id', vacancyId);
        Test.setCurrentPage(pref);

        ApexPages.StandardController stdCtr = new ApexPages.StandardController(vacancy);
        AssignCandidatesController assignCandidatesController = new AssignCandidatesController(stdCtr);
        assignCandidatesController.selectedCandidates = selectedCandidates;

        assignCandidatesController.assignCandidatesAction();

        Test.startTest();
        VacancyCandidateAssociation__c[] vacancyCandidates = [
                SELECT Id
                FROM VacancyCandidateAssociation__c
                WHERE Vacancy__c = :vacancyId
                AND Candidate__c IN :selectedCandidates
        ];

        System.assertEquals(2, vacancyCandidates.size());

        Test.stopTest();
    }
}