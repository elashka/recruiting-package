@isTest
private class TestCloseVacancy {
    static CloseVacancyController closeVacancyController;
    static Vacancy__c[] vacancies;
    static PageReference pref;
    static Candidate__c[] candidates;

    private static void init() {
        String vacancyStatus = RecruitingAppConstants.INPROGRESS_STATUS;
        String candidateStatus = RecruitingAppConstants.VALIDATED_STATUS;
        vacancies = TestDataFactory.createVacancies(1, vacancyStatus);
        candidates = TestDataFactory.createCandidates(3, candidateStatus);

        pref = new PageReference('/' + vacancies[0].Id);
        pref.getParameters().put('id', vacancies[0].Id);
        Test.setCurrentPage(pref);

        ApexPages.StandardController stdCtr = new ApexPages.StandardController(vacancies[0]);
        closeVacancyController = new closeVacancyController(stdCtr);
    }

    @isTest
    private static void testGetCandidates() {
        List<SelectOption> options = new List<SelectOption>();
        init();
        Test.startTest();
        TestDataFactory.createVca(vacancies[0].Id, candidates[0].Id);
        options = closeVacancyController.getCandidates();
        System.assertEquals(true, options.size() > 0);

        Test.stopTest();

    }

    @isTest
    private static void TestCloseVacancy() {
        init();
        Test.startTest();
        PageReference page = CloseVacancyController.closeVacancy();
        PageReference vacancyPage = new PageReference('/' + vacancies[0].id);
        System.assertEquals(vacancyPage.getUrl().toLowerCase(), page.getUrl().toLowerCase());
        Test.stopTest();
    }
}