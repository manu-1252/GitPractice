trigger GBAddressTrigger on schema.Address (after insert ,after update,before Update, before Insert)
{
    Set<Id> addressIds = new Set<Id>();
    if(trigger.isUpdate || trigger.isAfter  || trigger.isInsert)  
    {
        for(schema.Address addr : Trigger.new)
        {
            addressIds.add(addr.Id);
        }
        if(!addressIds.isEmpty())
        {
            //GBAddressTriggerHandler.updateAddress(addressIds);
        }
    }
    if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert))
    {
        if(Trigger_Configuration__mdt.getInstance('GBAddressTrigger').Is_Trigger_Enabled__c)
        {
            DynamicPhoneNumberValidateController.validatePhoneNumber(Trigger.NEW);
        }
    }
}