public with sharing class CloseVacancyController {
    private Vacancy__c vacancy;
    public String candidate { get; set; }
    public String inProgressStatus {
        get {
            return RecruitingAppConstants.INPROGRESS_STATUS;
        }
    }
    public String cantCloseText {
        get {
            return RecruitingAppConstants.CANT_CLOSE_TEXT;
        }
    }
    public String noCandidatesText {
        get {
            return RecruitingAppConstants.NO_CANDIDATES_TO_CLOSE_TEXT;
        }
    }

    public CloseVacancyController(ApexPages.StandardController standardController) {
        this.vacancy = (Vacancy__c) standardController.getRecord();
    }

    public PageReference closeVacancy() {
        Map<String, String> flowParams = new Map<String, String>();
        flowParams.put('varVacancyId', vacancy.id);
        if (string.isNotBlank(candidate)) {
            // Close vacancy if candidate exists
            // Run Close flow
            flowParams.put('varCandidateId', candidate);
            Flow.Interview.Close_Vacancy closeVacancy = new Flow.Interview.Close_Vacancy(flowParams);
            closeVacancy.start();
        } else {
            // Cancel vacancy if candidate doesn't exist
            // Run Cancel Flow
            system.debug(candidate);
            Flow.Interview.Cancel_Vacancy cancelVacancy = new Flow.Interview.Cancel_Vacancy(flowParams);
            cancelVacancy.start();
        }

        // Redirect back to Vacancy page
        PageReference page = new PageReference('/' + vacancy.id);
        page.setRedirect(true);
        return page;
    }

    public List<SelectOption> getCandidates() {
        List<SelectOption> candidatesOptions = new List<SelectOption>();

        Id vacancyId = vacancy.id;
        // Get all related candidates available for approve
        for (VacancyCandidateAssociation__c vacancyCandidates : [
                SELECT Id, Candidate__r.Id, Candidate__r.Full_Name__c
                FROM VacancyCandidateAssociation__c
                WHERE Vacancy__c = :vacancyId
        ]) {
            candidatesOptions.add(new SelectOption(vacancyCandidates.Candidate__r.Id, vacancyCandidates.Candidate__r.Full_Name__c));
        }

        return candidatesOptions;
    }
}