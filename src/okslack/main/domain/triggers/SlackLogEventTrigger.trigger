trigger SlackLogEventTrigger on ok__Log_Event__e (after insert) {
    ok.Logger logger = ok.Logger.getTriggerLogger();
    LogEventTriggerHandler handler = new LogEventTriggerHandler();
    // filter out events from this package to avoid recursive publish
    List<ok__Log_Event__e> logEventsFiltered = handler.filterOutLogEventsForSlack(Trigger.new); 
    try {
        handler.onAfterInsert(logEventsFiltered);
    } catch (Exception e) {
        logger.error().addException(e).log('Unexpected error.');
    } finally {
        ok.Logger.publish();
    }
}