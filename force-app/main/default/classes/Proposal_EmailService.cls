/**
 * @description       : 
 * @author            : Manoj Kumar
 * @group             : 
 * @last modified on  : 10-05-2023
 * @last modified by  : Manoj Kumar
**/
public without sharing class Proposal_EmailService implements Messaging.InboundEmailHandler {

    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope) {
    
     Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
     System.debug('quote id'+email.subject.substringAfter('-'));
     if(email.plainTextBody.contains('please click the link below to confirm the request')){
        sendVerificationEmail(email, 'manoj.s@prudentconsulting.com');
        
    }
        
     try{
        System.debug('quote idddd'+email.subject.substringAfter('-').trim());
        final String quote_Name=email.subject.substringAfter('-').trim();
        Id relatedProposal=[select Id from SBQQ__Quote__c where Name = :quote_Name WITH SECURITY_ENFORCED].Id;
        EmailMessage replyFromUser = new EmailMessage();
        replyFromUser.RelatedToId=relatedProposal;
        replyFromUser.FromAddress=email.fromAddress;
        replyFromUser.HtmlBody = email.htmlBody;

        replyFromUser.TextBody	= email.plainTextBody;
        replyFromUser.Subject = email.subject;
        replyFromUser.MessageDate=Datetime.now();
        replyFromUser.FromName=email.fromName;
        replyFromUser.ToAddress=email.toAddresses[0];
        replyFromUser.Status='2';
        
        if (Schema.sObjectType.EmailMessage.isCreateable()) {
            insert replyFromUser;
        } else {
          System.debug('User has no permission to perform this action');
        }
      
        
        System.debug('New EmailMessage Object: ' + replyFromUser );   

        Id recordTypeId = Schema.SObjectType.ProposalTeam__c.getRecordTypeInfosByName().get('Proposal Team (Internal)').getRecordTypeId();

        System.debug('Record Type Id: ' + recordTypeId);
        
        List<ProposalTeam__c> internalTeamAddresses = new List<ProposalTeam__c>();

        if (Schema.sObjectType.ProposalTeam__c.isQueryable()) {
           internalTeamAddresses=[Select Member_Name__r.Email,Member_Name__r.Name,Proposal__r.Name,Proposal__r.id,Member_Name__r.id,Member_Name__c 
        from ProposalTeam__c where RecordTypeId= :recordTypeId AND Proposal__r.Name = :quote_Name];
      } else {
        System.debug('User has no permission to perform this action');
      }

        if(internalTeamAddresses.size()>0){
         sendNotificationEmail(email,internalTeamAddresses,replyFromUser);
        }
     }
       catch (QueryException e) {
        System.debug('Query Issue: ' + e);
    }
    result.success = true; 
    return result;  
    
      }

      public void sendNotificationEmail(Messaging.InboundEmail email,List<ProposalTeam__c> proposalInternalTeamMembers,EmailMessage replyFromUser){

        System.debug('Internal team addresses'+proposalInternalTeamMembers);
        
        EmailTemplate template;
        List<CustomNotificationType> TemplateInfoDetail = new List<CustomNotificationType>();

        if (Schema.sObjectType.EmailTemplate.isQueryable()) {
        template  = [Select id,HtmlValue,Subject from Emailtemplate where Name =: 'Reply Notification Email Template' Limit 1];
        }
        else{
          System.debug('User has no permission to querying emailtemplate');
        }

        if(Schema.sObjectType.CustomNotificationType.isQueryable()){
        TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Quote_User_Replied_to_Proposal_Email_Notification'];
        }
        else{
          System.debug('User has no permission to querying CustomNotificationType');
        }
        
        
        String templateSubject = template.Subject; 
        String recordLink = '<a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/'+proposalInternalTeamMembers[0].Proposal__r.id+'>'+proposalInternalTeamMembers[0].Proposal__r.Name+'</a>';

        Messaging.reserveSingleEmailCapacity(proposalInternalTeamMembers.size());

        List<Messaging.SingleEmailMessage> notificationMails = new List<Messaging.SingleEmailMessage>() ;
      

        for(Integer i=0;i<proposalInternalTeamMembers.size();i++){

          String templateHtmlBody = template.HtmlValue;
          templateHtmlBody=templateHtmlBody.replace('{ProposalTeamMemberName}',proposalInternalTeamMembers[i].Member_Name__r.Name);
          templateHtmlBody=templateHtmlBody.replace('{replyEmailSubject}',email.subject);
          templateHtmlBody=templateHtmlBody.replace('{relatedProposalName}',recordLink);
          templateHtmlBody=templateHtmlBody.replace('{replyEmailFromName}',email.fromName);
          templateSubject=templateSubject.replace('{relatedProposalName}',proposalInternalTeamMembers[i].Proposal__r.Name);
          //templateHtmlBody=templateHtmlBody+'\n'+email.plainTextBody;
          system.debug('template'+templateHtmlBody);

          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          mail.setToAddresses(new List<String>{proposalInternalTeamMembers[i].Member_Name__r.Email});
          mail.setSubject(templateSubject);
          mail.setHtmlBody(templateHtmlBody);
          mail.setWhatId(proposalInternalTeamMembers[i].Proposal__r.id);
        //  mail.setInReplyTo(replyFromUser.id);
          notificationMails.add(mail);

          Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
          currNotification.setTitle(templateSubject);
          currNotification.setBody('A reply is received for the proposal email you sent to '+proposalInternalTeamMembers[i].Member_Name__r.Name+'. '+'To access the item,click on this notification' );
          currNotification.setNotificationTypeId(TemplateInfoDetail[0].Id);
          currNotification.setTargetId(proposalInternalTeamMembers[i].Proposal__r.id);
          currNotification.send(new Set<String>{proposalInternalTeamMembers[i].Member_Name__c});
          
        }

        Messaging.sendEmail(notificationMails);
 
        
    }
      

      private void sendVerificationEmail(Messaging.InboundEmail email,String toAddress){


        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {toAddress};


        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Test');

        mail.setSubject('Test');
        mail.setPlainTextBody(email.plainTextBody);
        mail.setHtmlBody(email.htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   

    }
  
    
    }