/**
 * This trigger is subscribing to the log events.
 * You can use One Logger from within this plugin. 
 * Do not add try-catch and do not publish log events in this trigger to avoid event recursion.
 * The plugin framework automatically removes all events from this plugin to avoid the recursion.
 * The `execute` method has a built-in try-catch and publish call.
 */
trigger SlackLogEventTrigger on ok__Log_Event__e (after insert) {
    new SlackForOneLoggerPlugin().execute();
}