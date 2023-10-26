/**
 * @description       : 
 * @author            : Manoj Kumar
 * @group             : 
 * @last modified on  : 10-26-2023
 * @last modified by  : Manoj Kumar
**/
@isTest
public class CopyProposalTeamEmailMessageHandlerTest {
   @isTest
   public static void testCopiedEmailMessage(){
      //ProposalTeam__c proposalTeamMember= [Select id,Member_Name1__r.Email,Proposal__c from ProposalTeam__c where id ='a1Q56000009aKOJEA2'];
      ProposalTeam__c proposalTeamMember=TestDataFactory.createProposalTeamMember(true);
      EmailMessage replyFromUser = new EmailMessage();
       replyFromUser.Subject='test - Q-02209';
       replyFromUser.RelatedToId=proposalTeamMember.id;
       replyFromUser.FromAddress=proposalTeamMember.Member_Name1__r.Email;
       replyFromUser.ToAddress='manoj1252447@gmail.com';
       replyFromUser.Status='3';
       insert replyFromUser;
   
   EmailMessage copiedEmailMessage = [Select id,RelatedToId,Subject from EmailMessage where RelatedToId = : proposalTeamMember.Proposal__c order by CreatedDate DESC limit 1];
   System.assertEquals(copiedEmailMessage.Subject,replyFromUser.Subject);

   }
   
}