trigger SharepointFoldersAccounts on Account (after insert, after update) {
    // Due to additional custom code on the Matters object, we need to make sure that we're just get executed once
    // to avoid potential race conditions that would lead to multiple links/folder creations.
    if(SharepointFoldersCtrl.FIRST_RUN){
	for(Account a : Trigger.New){

	    // Remove forbidden characters from title
	    String title = SharepointUtilities.normalize(a.Name);

	    // Check for existing linked document
	    List<qkom365__O365_Metadata__c> link = [SELECT Id FROM qkom365__O365_Metadata__c WHERE qkom365__Deleted__c != true AND qkom365__RelatedToId__c =: a.Id AND qkom365__Document_Name__c =: a.Name LIMIT 1];

	    if(link.size() != 0){
		System.debug('Found existing active link document. Exiting.');
		continue;
	    }

	    // Start init folder creation
	    SharepointFoldersCtrl.createAccountFolders(a.Id, title);
	}

	// Prevent trigger from running twice in one Apex transaction
	SharepointFoldersCtrl.FIRST_RUN = false;
    }
}