/**
 * @description       : 
 * @author            : Manoj Kumar
 * @group             : 
 * @last modified on  : 10-06-2023
 * @last modified by  : Manoj Kumar
**/
public with sharing class CopyProposalTeamEmailMessageHandler {
    /**
    * @description Getting EmailMessage From Proposal Team Member Activity to Add it to Related Proposal Email Activity
    * @author Manoj Kumar | 10-05-2023 
    * @param newEmailMessage 
    **/
    public static void copyToProposal(List<EmailMessage> newEmailMessage) {
        // Create a list to store new email messages coming from trigger
        List<EmailMessage> emailMessagesToCopy = new List<EmailMessage>();
    
        // Loop through each email message in the input list
        for (EmailMessage eachEmailMessage : newEmailMessage) {
            // Check if the email message is related to a ProposalTeam__c object,
            // has a status of '3' which means Received, and has a non-null RelatedToId
            if (eachEmailMessage.RelatedToId != null &&
                eachEmailMessage.RelatedToId.getSObjectType().getDescribe().getName() == 'ProposalTeam__c' &&
                eachEmailMessage.Status == '3') {
    
                // Extract the quote name from the subject of the email message
                final String quote_Name = eachEmailMessage.subject.substringAfter('-').trim();
    
                // Query for the related Proposal (SBQQ__Quote__c) record using the quote name
                Id relatedProposal = [SELECT Id FROM SBQQ__Quote__c WHERE Name = :quote_Name WITH SECURITY_ENFORCED].Id;
    
                // Create a new EmailMessage object for the Proposal
                EmailMessage createEmailMessageInProposal = new EmailMessage();
                
                // Set various fields of the new EmailMessage object
                createEmailMessageInProposal.RelatedToId = relatedProposal;
                createEmailMessageInProposal.FromAddress = eachEmailMessage.fromAddress;
                createEmailMessageInProposal.HtmlBody = eachEmailMessage.htmlBody;
                createEmailMessageInProposal.TextBody = eachEmailMessage.TextBody;
                createEmailMessageInProposal.Subject = eachEmailMessage.subject;
                createEmailMessageInProposal.CcAddress = eachEmailMessage.CcAddress;
                createEmailMessageInProposal.MessageDate = Datetime.now();
                createEmailMessageInProposal.FromName = eachEmailMessage.fromName;
                createEmailMessageInProposal.ToAddress = eachEmailMessage.ToAddress;
                createEmailMessageInProposal.Status = '3';
                
                // Add the newly created EmailMessage to the list for insertion
                emailMessagesToCopy.add(createEmailMessageInProposal);
            }
        }
    
        // Check if the EmailMessage object is createable and if there are messages to insert
        if (Schema.sObjectType.EmailMessage.isCreateable() && emailMessagesToCopy.size() > 0) {
            // Insert the EmailMessages into the database
            insert emailMessagesToCopy;
        } else {
            // If the user doesn't have permission to perform the action or there are no messages to insert, log a debug message
            System.debug('User has no permission to perform this action');
        }
    }
    
}