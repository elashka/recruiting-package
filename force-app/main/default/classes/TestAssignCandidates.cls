@isTest
public class TestAssignCandidates {
    static AssignCandidatesController assignCandidatesController;
    static Vacancy__c[] vacancies;
    static PageReference pref;
    static Candidate__c[] candidates;
    static List<String> selectedCandidates = new List<String>();

    private static void init() {
        String vacancyStatus = RecruitingAppConstants.INPROGRESS_STATUS;
        String candidateStatus = RecruitingAppConstants.VALIDATED_STATUS;
        vacancies = TestDataFactory.createVacancies(1, vacancyStatus);
        candidates = TestDataFactory.createCandidates(3, candidateStatus);

        for (Candidate__C candidate : candidates) {
            selectedCandidates.add(candidate.Id);
            candidate.Status__c = candidateStatus;
        }

        update candidates;

        TestDataFactory.createVca(vacancies[0].Id, candidates[0].Id);

        pref = new PageReference('/' + vacancies[0].Id);
        pref.getParameters().put('id', vacancies[0].Id);
        Test.setCurrentPage(pref);

        ApexPages.StandardController stdCtr = new ApexPages.StandardController(vacancies[0]);
        assignCandidatesController = new AssignCandidatesController(stdCtr);
        assignCandidatesController.selectedCandidates = selectedCandidates;
    }

    @isTest
    private static void testGetCandidates() {
        List<SelectOption> options = new List<SelectOption>();

        init();
        Test.startTest();
        options = assignCandidatesController.getCandidates();
        System.assertEquals(2, options.size());

        Test.stopTest();

    }

    @isTest
    private static void TestAssignCandidates() {
        init();
        Test.startTest();
        assignCandidatesController.assignCandidatesAction();

        String vacancyId = vacancies[0].Id;
        VacancyCandidateAssociation__c[] vca = [
                SELECT Id
                FROM VacancyCandidateAssociation__c
                WHERE Vacancy__c = :vacancyId
                AND Candidate__c IN :selectedCandidates
        ];
        System.assertEquals(true, vca.size() > 0);

        Test.stopTest();
    }
}