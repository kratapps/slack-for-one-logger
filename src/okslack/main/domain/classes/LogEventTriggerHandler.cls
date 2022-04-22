public with sharing class LogEventTriggerHandler {
    private static final String NAMESPACE = LogEventTriggerHandler.class.getName().substringBefore('.'); 
    private final SlackService service = new SlackService();
    
    public void onAfterInsert(List<ok__Log_Event__e> logEvents) {
        service.sendMessages(logEvents);
    }
    
    public List<ok__Log_Event__e> filterOutLogEventsForSlack(List<ok__Log_Event__e> logEvents) {
        List<ok__Log_Event__e> logEventsFiltered = new List<ok__Log_Event__e>();
        for (ok__Log_Event__e event : logEvents) {
            if (event.ok__Namespace_Prefix__c != NAMESPACE) {
                logEventsFiltered.add(event);
            }
        }
        return logEventsFiltered;
    }
}