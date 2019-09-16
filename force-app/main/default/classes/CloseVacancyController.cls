public with sharing class CloseVacancyController {
    private final Vacancy__c vacancy;
    public String candidate { get; set; }

    public CloseVacancyController(ApexPages.StandardController standardController) {
        this.vacancy = (Vacancy__c) standardController.getRecord();
    }

    public PageReference closeVacancy() {
        Map<String, Object> params = new Map<String, Object>();
        params.put('varVacancyId', vacancy.id);
        if (string.isNotBlank(candidate)) {
            // Close vacancy if candidate exists
            // Run Close flow
            params.put('varCandidateId', candidate);
            Flow.Interview.Close_Vacancy closeVacancy = new Flow.Interview.Close_Vacancy(params);
            closeVacancy.start();
        } else {
            // Cancel vacancy if candidate doesn't exist
            // Run Cancel Flow
            Flow.Interview.Cancel_Vacancy cancelVacancy = new Flow.Interview.Cancel_Vacancy(params);
            cancelVacancy.start();
        }

        // Redirect back to Vacancy page
        PageReference page = new PageReference('/' + vacancy.id);
        page.setRedirect(true);
        return page;
    }

    public List<SelectOption> getCandidates() {
        List<SelectOption> options = new List<SelectOption>();

        Id vacancyId = vacancy.id;
        // Get all related candidates available for approve
        for (VacancyCandidateAssociation__c vca : [
                SELECT Id, Candidate__r.Id, Candidate__r.Full_Name__c
                FROM VacancyCandidateAssociation__c
                WHERE Vacancy__c = :vacancyId
        ]) {
            options.add(new SelectOption(vca.Candidate__r.Id, vca.Candidate__r.Full_Name__c));
        }

        return options;
    }
}