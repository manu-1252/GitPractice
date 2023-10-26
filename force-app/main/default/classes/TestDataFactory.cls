/**
 * @description       : 
 * @author            :
 * @group             : 
 * @last modified on  : 10-09-2023
 * @last modified by  : Manoj Kumar
**/
@isTest
public class TestDataFactory {
    Id InternalRecordTypeId = Schema.SObjectType.Project_Team__c.getRecordTypeInfosByName().get('Project Team (Internal)').getRecordTypeId();       // Record type of Project Team
    Id ProposalTeamInternalRecordtypeId = Schema.SObjectType.ProposalTeam__c.getRecordTypeInfosByName().get('Proposal Team (Internal)').getRecordTypeId();   //Record type of Proposal Team
    //Insert User -1 //
    public static User createUserV1( Boolean doInsert) {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User U1 = new User();
        U1.Username = 'aklsdfjlkiw@dunzo.com';
        U1.LastName = 'test1';
        U1.Email = 'test1@gmail.com';
        U1.Alias = 'Tst1';
        U1.TimeZoneSidKey = 'GMT';
        U1.LocaleSidKey = 'en_US';
        U1.Division__c = 'Mechanical Technologies';
        U1.EmailEncodingKey = 'UTF-8';
        U1.ProfileId = p.Id; 
        U1.LanguageLocaleKey = 'en_US';
        U1.Division = 'Test Division';
        if(doInsert){
            insert U1; 
        }
        return U1;
    }
    //Insert User -2 //
    public static User createUserV2( Boolean doInsert) {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User U2 = new User();
        U2.Username = 'aklsd@dunzo.com';
        U2.LastName = 'test2';
        U2.Email = 'project@gmail.com';
        U2.Alias = 'prmano';
        U2.TimeZoneSidKey = 'GMT';
        U2.LocaleSidKey = 'en_US';
        U2.EmailEncodingKey = 'UTF-8';
        U2.ProfileId = p.Id; 
        U2.LanguageLocaleKey = 'en_US';
        U2.Division = 'Test Division1';
        if(doInsert){
            insert U2; 
        }
        return U2;
    }
    //Insert User -3//
    public static User createUserV3( Boolean doInsert) {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User U3 = new User();
        U3.Username = 'klsd@dunzo.com';
        U3.LastName = 'test3';
        U3.Email = 'roject@gmail.com';
        U3.Alias = 'prman';
        U3.TimeZoneSidKey = 'GMT';
        U3.LocaleSidKey = 'en_US';
        U3.EmailEncodingKey = 'UTF-8';
        U3.ProfileId = p.Id; 
        U3.LanguageLocaleKey = 'en_US';
        U3.Division = 'Test Division3';
        if(doInsert){
            insert U3; 
        }
        return U3;
    }
    //Insert Address//
    public static Schema.Address createAddress( Boolean doInsert) {
        Account acc = createAccount(true);
        Schema.Location lc = new Schema.Location();
        lc.Name = 'USA';
        lc.LocationType = 'Customer';
        insert lc;
        
        Schema.Address addres  = New Schema.Address();
        addres.ParentId =lc.id;
        addres.Address_Name__c = 'USA';
        addres.LocationType = 'Customer';
        addres.AddressType ='Project Location';
       // addres.Street__c = '4th Street';
        addres.city ='Portland';
        addres.Account__c = acc.id;
        addres.state ='Oregon';
        addres.postalcode = '45678';
        //addres.street ='4th Street';
        addres.country ='Multnomah';
        addres.Phone_Number__c='+919248986641';
        if(doInsert){
            insert addres;   
        }
        return addres;
    }
    //Insert Project//
    public static Project__c createProject( Boolean doInsert) {
       Account acc = createAccount(true);
    //    Account dummyAcc = createDummyAccount(true);
        Schema.Location lc = new Schema.Location();
        lc.Name = 'USA';
        lc.LocationType = 'Customer';
        insert lc;
        
        Schema.Address addres  = New Schema.Address();
        addres.ParentId =lc.id;
        addres.Address_Name__c = 'USA';
        addres.LocationType = 'Customer';
        addres.AddressType ='Project Location';
      //  addres.Street__c = '4th Street';
        addres.city ='Portland';
       addres.Account__c = acc.id;
        // addres.Account__c = dummyAcc.id;
        addres.state ='Oregon';
        addres.postalcode = '45678';
        //addres.street ='4th Street';
        addres.country ='Multnomah';
        addres.Phone_Number__c='+919248986641';
        insert addres;
        
        Project__c project = new Project__c();
        project.Name = 'Test Project555';
        project.Project_Stage__c ='Concept';
       project.Account__c = acc.id;
        // project.Account__c = dummyAcc.id;
        project.Due_Date_Time__c=Date.newInstance(2023, 02, 10);
        project.Expected_Close_Date__c =Date.newInstance(2023, 02, 08);
        project.Project_Location__c= addres.id;
        project.Account_Market_Category__c = 'HVAC Replacement';
        //project.Project_Amount__c =10;
        project.Account_Market_Segment__c='Commercial';
        if(doInsert){
            insert project;  
        }
        return project;
        
    }
    //Insert Proposal  //
    public static SBQQ__Quote__c createProposal( Boolean doInsert) {
        //Id ProposalRecordtypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Master Proposal').getRecordTypeId();        //Record type of Proposal
        SBQQ__Quote__c proposal = new SBQQ__Quote__c();
        //proposal.RecordTypeId = masterScopeRecordType;
        proposal.Project__c = createProject(True).Id;
        proposal.SBQQ__Status__c = 'Draft';
            proposal.SBQQ__Primary__c = true;
            //proposal.SBQQ__Opportunity2__c= createOpportunity(true).id;
            //proposal.SBQQ__PricebookId__c =  Test.getStandardPricebookId();
           // proposal.Project__c = TestDataFactory.createProject(True).Id;
        if(doInsert){
            insert proposal;   
        }
        return proposal;
    }
    //Insert Opportunity  //
    public static Opportunity createOpportunity(Id proposalId,Id projectId, Boolean doInsert) {
        Id RecordTypeIdScope = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Master Scope').getRecordTypeId();     //Record type of Scope 
        Opportunity opp = New Opportunity();
        opp.RecordTypeId = RecordTypeIdScope;
        opp.SBQQ__PrimaryQuote__c =proposalId;
        opp.Name = 'TestOpp';
        opp.Project__c = projectId;
        opp.StageName='Qualification';
        opp.CloseDate= Date.today() + 30;
        if(doInsert){
            Insert opp; 
        }
        return opp;
    }
    
    //insert Account//
    public static Account createAccount( Boolean doInsert) {
        Account testAccount = new Account();
        testAccount.Name = 'TestACCOUNT11';
        testAccount.Phone = '+919148986641';
        testAccount.Type='Contractor';
        testAccount.Account_Sub_Type__c = 'Energy Contractor';
    //    testAccount.Account_Market_Segment__c = 'Commercial';
      //  testAccount.Account_Market_Category__c = 'Contractor';
        if(doInsert){
            insert testAccount;  
        }
        return testAccount;
    }

     //insert DummyAccount//
    //  public static Account createDummyAccount( Boolean doInsert) {
    //     Account testAccount = new Account();
    //     testAccount.Name = 'Pending Customer';
    //     testAccount.Phone = '9148986641';
    //     testAccount.Type='Default';
    //    // testAccount.Account_Market_Segment__c = 'Commercial';
    //     //testAccount.Account_Market_Category__c = 'HVAC Renovations';
       
    //     if(doInsert){
    //         insert testAccount;  
    //     }
    //     system.debug('=test='+testAccount.Id);
    //     return testAccount;
    // }

    //insert contact//
    public static Contact createContact( Boolean doInsert){
        Contact con = New Contact();
        con.LastName = 'Test Name';
        con.Email = 'Test5678@gmail.com';
        con.Phone = '6789098767';
        con.AccountId =createAccount(true).id;
        if(doInsert){
           insert con ;
        }
        return con;
        
    }
    //Insert Case  //
    public static Case createCase(Boolean doInsert){
        Case cs = new Case();
        cs.Subject = 'Orange Inc.';
        cs.Description = 'Orange Inc.';
        cs.Account_Name__c = 'Orange Inc.';
        cs.Phone_Number__c = '2525252525';
        cs.Account_Type__c = 'Customer';
        cs.Account_Sub_Type__c = 'Business';
        cs.Account_Market_Segment__c = 'Other';
        cs.Account_Market_Category__c = 'New Construction';
        if(doInsert){
          insert cs;
        }
        return cs;

    }
    
    /**
    * @description 
    * @author Manoj Kumar | 10-06-2023 
    * @param doInsert - Boolean value to specify insert the record or not 
    * @return ProposalTeam__c 
    **/
    public static ProposalTeam__c createProposalTeamMember(Boolean doInsert){
        ProposalTeam__c pt= new ProposalTeam__c();
        pt.Proposal__c=createProposal(true).id;
        pt.Member_Name1__c=createContact(true).id;
        pt.Member_Role__c='Estimator';
        pt.Account_LK__c=createAccount(true).id;
        pt.RecordTypeId='01256000003Dt7rAAC';
        if(doInsert){
          insert pt;
        }
        return pt;

    }
    
}