public with sharing class SharepointFoldersCtrl {
    public static boolean FIRST_RUN = true;

    @future(callout=true)
    public static void createAccountFolders(Id accountId, string title) {
	String destination_drive = SharepointConfig.DESTINATION_DRIVE;
	String destination_item = SharepointConfig.DESTINATION_ACCOUNTS;
	String template_drive = SharepointConfig.TEMPLATE_DRIVE;
	String template_accounts = SharepointConfig.TEMPLATE_ACCOUNTS;

	// Get HttpRequest > Copy template to destination
	HttpRequest req = SharepointUtilities.getTemplateRequest(destination_drive, destination_item, title);
	String job_url = SharepointUtilities.getCopiedItemJob(qkom365.GraphUtils.send(req, '/v1.0/drives/' + template_drive + '/items/' + template_accounts + '/copy'));

	// Get copy job information
	Http http = new Http();
	HttpRequest req_job = SharepointUtilities.getJobStatusRequest(job_url);

	String root_id = '';
	Integer k = 0;
	while(true){
	    root_id = SharepointUtilities.getIdFromJobStatusResponse(http.send(req_job));

	    if(root_id == null){
		SharepointUtilities.sleep(SharepointConfig.SLEEP_DELAY);

		if(++k > 15){
		    throw new EException('Error getting new document library id. Exiting.');
		}
		continue;
	    }
	    break;
	}

	// Get additional folder information
	HttpRequest req_top = new HttpRequest();
	req_top.setMethod('GET');

	HttpResponse res_top = qkom365.GraphUtils.send(req_top, '/v1.0/drives/' + destination_drive + '/items/' + root_id);

	Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(res_top.getBody());

	String root_url = String.valueOf(body.get('webUrl'));

	// Create link document: top-level
	SharepointUtilities.createLink(String.valueOf(accountId), title, destination_drive, root_id, root_url, 'Folder', 'Accounts', 'Account Files', null);
    }

    // Exception interface
    public class EException extends Exception {}

}
