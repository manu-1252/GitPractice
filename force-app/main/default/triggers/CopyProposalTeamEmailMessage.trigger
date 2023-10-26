/**
 * @description       : 
 * @author            : Manoj Kumar
 * @group             : 
 * @last modified on  : 10-05-2023
 * @last modified by  : Manoj Kumar
**/
trigger CopyProposalTeamEmailMessage on EmailMessage (after insert) {
    CopyProposalTeamEmailMessageHandler.copyToProposal(Trigger.new);
}