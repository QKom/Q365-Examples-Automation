trigger SharepointFoldersAccounts on Account (after insert, after update) {
    if(SharepointFoldersCtrl.FIRST_RUN){
	for(Account a : Trigger.New){
	    String title = SharepointUtilities.normalize(a.Name);
	    List<qkom365__O365_Metadata__c> link = [SELECT Id FROM qkom365__O365_Metadata__c WHERE qkom365__Deleted__c != true AND qkom365__RelatedToId__c =: a.Id AND qkom365__Document_Name__c =: a.Name LIMIT 1];

	    if(link.size() != 0){
		System.debug('Found existing active link document. Exiting.');
		continue;
	    }

	    if(!Test.isRunningTest()){
		SharepointFoldersCtrl.createAccountFolders(a.Id, title);
	    }
	}

	SharepointFoldersCtrl.FIRST_RUN = false;
    }
}