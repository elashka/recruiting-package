@isTest
public class TestDataFactory {
    public static List<Vacancy__c> createVacancies(Integer numVacancies, String status) {
        List<Vacancy__c> vacancies = new List<Vacancy__c>();

        for (Integer i = 0; i < numVacancies; i++) {
            Vacancy__c vacancy = new Vacancy__c(Title__c = 'TestVacancy' + i,
                    Status__c = status);
            vacancies.add(vacancy);
        }
        insert vacancies;

        return vacancies;
    }

    public static List<Candidate__c> createCandidates(Integer numCandidates, String status) {
        List<Candidate__c> candidates = new List<Candidate__c>();

        for (Integer i = 0; i < numCandidates; i++) {
            Candidate__c candidate = new Candidate__c(FirstName__c = 'TestCandidate' + i,
                    LastName__c = 'LastName',
                    Salary__c = 500,
                    Status__c = status);
            candidates.add(candidate);
        }
        insert candidates;

        return candidates;
    }

    public static VacancyCandidateAssociation__c createVca(String vacancyId, String candidateId) {
        VacancyCandidateAssociation__c vca = new VacancyCandidateAssociation__c(Vacancy__c = vacancyId, Candidate__c = candidateId);

        insert vca;
        return vca;
    }
}