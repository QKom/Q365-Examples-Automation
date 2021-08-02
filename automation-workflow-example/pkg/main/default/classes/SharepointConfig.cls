public with sharing class SharepointConfig {
    // Delay interval
    public static final Integer SLEEP_DELAY = 2000;

    // Custom Setting Fields
    public static final String TEMPLATE_DRIVE = Q365_Project_Settings__c.getOrgDefaults().Template_Drive__c;
    public static final String TEMPLATE_ACCOUNTS = Q365_Project_Settings__c.getOrgDefaults().Template_Accounts__c;
    public static final String DESTINATION_ROOT = Q365_Project_Settings__c.getOrgDefaults().Destination_Root__c;
    public static final String DESTINATION_DRIVE = Q365_Project_Settings__c.getOrgDefaults().Destination_Drive__c;

}
