public with sharing class AssignCandidatesController {
    private Vacancy__c vacancy;
    public String[] selectedCandidates { get; set; }
    public String inProgressStatus {
        get {
            return RecruitingAppConstants.INPROGRESS_STATUS;
        }
    }
    public String cantAssignText {
        get {
            return RecruitingAppConstants.CANT_ASSIGN_TEXT;
        }
    }
    public String noCandidatesText {
        get {
            return RecruitingAppConstants.NO_CANDIDATES_TEXT;
        }
    }

    public AssignCandidatesController(ApexPages.StandardController standardController) {
        this.vacancy = (Vacancy__c) standardController.getRecord();
        selectedCandidates = new String[]{};
    }

    public PageReference assignCandidatesAction() {
        Integer selectedCandidatesSize = selectedCandidates.size();

        if (selectedCandidatesSize > 0) {
            List<VacancyCandidateAssociation__c> vacancyCandidates = new List<VacancyCandidateAssociation__c>();
            for (String selectedCandidate : selectedCandidates) {
                vacancyCandidates.add(new VacancyCandidateAssociation__c(Vacancy__c = vacancy.Id, Candidate__c = selectedCandidate));
            }
            insert vacancyCandidates;
        }

        // Redirect back to Vacancy page
        PageReference page = new PageReference('/' + vacancy.Id);
        page.setRedirect(true);
        return page;
    }

    public List<SelectOption> getCandidates() {
        List<SelectOption> candidatesOptions = new List<SelectOption>();
        List<String> assignedCandidates = new List<String>();

        // Get already assigned candidates
        for (VacancyCandidateAssociation__c vacancyCandidates : [
                SELECT Id, Candidate__r.Id
                FROM VacancyCandidateAssociation__c
                WHERE Vacancy__c = :vacancy.Id
        ]) {
            assignedCandidates.add(vacancyCandidates.Candidate__r.Id);
        }

        String status = RecruitingAppConstants.VALIDATED_STATUS;
        // Get candidates with status validated by HR
        for (Candidate__c candidate : [
                SELECT Id, Full_Name__c
                FROM Candidate__c
                WHERE Status__c = :status
                AND Id NOT IN :assignedCandidates
        ]) {
            candidatesOptions.add(new SelectOption(candidate.Id, candidate.Full_Name__c));
        }

        return candidatesOptions;
    }
}