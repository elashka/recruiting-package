public with sharing class AssignCandidatesController {
    private final Vacancy__c vacancy;
    public String[] selectedCandidates { get; set; }

    public AssignCandidatesController(ApexPages.StandardController standardController) {
        this.vacancy = (Vacancy__c) standardController.getRecord();
    }

    public PageReference assignCandidatesAction() {
        Integer selectedCandidatesSize = selectedCandidates.size();
        if (selectedCandidatesSize > 0) {
            List<sObject> vca = new List<sObject>();
            for (String selectedCandidate : selectedCandidates) {
                vca.add(new VacancyCandidateAssociation__c(Vacancy__c = vacancy.Id, Candidate__c = selectedCandidate));
            }
            insert vca;
        }

        // Redirect back to Vacancy page
        PageReference page = new PageReference('/' + vacancy.Id);
        page.setRedirect(true);
        return page;
    }

    public List<SelectOption> getCandidates() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> assignedCandidates = new List<String>();

        // Get already assigned candidates
        for (VacancyCandidateAssociation__c vca : [
                SELECT Id, Candidate__r.Id
                FROM VacancyCandidateAssociation__c
                WHERE Vacancy__c = :vacancy.Id
        ]) {
            assignedCandidates.add(vca.Candidate__r.Id);
        }

        String status = RecruitingAppConstants.VALIDATED_STATUS;
        // Get candidates with status validated by HR
        for (Candidate__c can : [
                SELECT Id, Full_Name__c
                FROM Candidate__c
                WHERE Status__c = :status
                AND Id NOT IN :assignedCandidates
        ]) {
            options.add(new SelectOption(can.Id, can.Full_Name__c));
        }

        return options;
    }
}