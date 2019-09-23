@isTest
private class TestCloseVacancy {
    public static String candidateStatus = RecruitingAppConstants.VALIDATED_STATUS;

    @testSetup
    static void setup() {
        String vacancyStatus = RecruitingAppConstants.INPROGRESS_STATUS;
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

        Vacancy__c vacancy = [SELECT Title__c FROM Vacancy__c WHERE Title__c = 'TestVacancy0' LIMIT 1];
        Candidate__c candidate = [SELECT FirstName__c FROM Candidate__c WHERE FirstName__c LIKE 'TestCandidate%' AND Status__c = :candidateStatus LIMIT 1];

        PageReference pref = new PageReference('/' + vacancy);
        pref.getParameters().put('id', vacancy.Id);
        Test.setCurrentPage(pref);

        ApexPages.StandardController stdCtr = new ApexPages.StandardController(vacancy);
        CloseVacancyController closeVacancyController = new closeVacancyController(stdCtr);

        TestDataFactory.createVca(vacancy.Id, candidate.Id);

        options = closeVacancyController.getCandidates();
        System.assertEquals(1, options.size());
    }

    @isTest
    private static void TestCloseVacancy() {
        String closedStatus = RecruitingAppConstants.CLOSED_STATUS;
        Vacancy__c vacancy = [SELECT Status__c FROM Vacancy__c WHERE Title__c = 'TestVacancy0' LIMIT 1];
        String vacancyId = vacancy.Id;

        PageReference pref = new PageReference('/' + vacancyId);
        pref.getParameters().put('id', vacancyId);
        Test.setCurrentPage(pref);

        ApexPages.StandardController stdCtr = new ApexPages.StandardController(vacancy);
        CloseVacancyController closeVacancyController = new closeVacancyController(stdCtr);

        // Test Close Vacancy
        Candidate__c candidate = [SELECT FirstName__c FROM Candidate__c WHERE FirstName__c LIKE 'TestCandidate%' AND Status__c = :candidateStatus LIMIT 1];
        closeVacancyController.candidate = candidate.Id;

        CloseVacancyController.closeVacancy();

        VacancyCandidateAssociation__c[] vacancyCandidates = [
                SELECT Id
                FROM VacancyCandidateAssociation__c
                WHERE Vacancy__c = :vacancyId
        ];

        Vacancy__c closedVacancy = [SELECT Status__c FROM Vacancy__c WHERE Id = :vacancyId];

        System.assertEquals(0, vacancyCandidates.size());
        System.assertEquals(closedStatus, closedVacancy.Status__c);
    }

    @isTest
    private static void TestCancelVacancy() {
        String canceledStatus = RecruitingAppConstants.CANCELLED_STATUS;
        Vacancy__c vacancy = [SELECT Status__c FROM Vacancy__c WHERE Title__c = 'TestVacancy0' LIMIT 1];
        String vacancyId = vacancy.Id;

        PageReference pref = new PageReference('/' + vacancyId);
        pref.getParameters().put('id', vacancyId);
        Test.setCurrentPage(pref);

        ApexPages.StandardController stdCtr = new ApexPages.StandardController(vacancy);
        CloseVacancyController closeVacancyController = new closeVacancyController(stdCtr);

        CloseVacancyController.closeVacancy();
        Vacancy__c canceledVacancy = [SELECT Status__c FROM Vacancy__c WHERE Id = :vacancyId];
        System.assertEquals(canceledStatus, canceledVacancy.Status__c);
    }
}