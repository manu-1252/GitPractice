/**
 * @description       : 
 * @author            : Manoj Kumar
 * @group             : 
 * @last modified on  : 10-26-2023
 * @last modified by  : Manoj Kumar
**/
public with sharing class TestApex {
    /**
    * @description 
    * @author Manoj Kumar | 10-26-2023 
    **/
    public static void accountData(){
        Account acc=[select id,name from account limit 1];
    }
  
}