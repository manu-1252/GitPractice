trigger UserTrigger on User (after insert, after update, before insert) {
    
    if(trigger.isinsert && trigger.isBefore){
        UserHandler.updateUserAlias(trigger.new);
    }
    
    set<Id> userIds = new set<Id>();
    if(trigger.isinsert && trigger.isAfter){
        
        for(User u : trigger.new)
        {
            userIds.add(u.Id);
        }
        if(!userIds.IsEmpty()){}
            UserHandler.createSalesPerson(userIds);
    }
    
    if(trigger.isupdate && trigger.isAfter)
    {
        for(user u :trigger.new){
            if(trigger.oldmap != null
               && trigger.oldmap.get(u.Id) != u
               && trigger.oldmap.get(U.Id).X_BC_Salesperson_ID__c != null)
            {
                userIds.add(u.Id);
            }
            if(!userIds.IsEmpty())
                UserHandler.createSalesPerson(userIds);
        }
    }
}