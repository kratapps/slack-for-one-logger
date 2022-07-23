/**
 * Configurable One Logger Plugin to send Slack messages.
 */
global with sharing class SlackForOneLoggerPlugin extends ok.LoggerPlugin {
    /**
     * Unique class type to identify this plugin.
     * Usually this class type.
     * 
     * @return the name of this plugin.
     */
    global override Type getPluginType() {
        return SlackForOneLoggerPlugin.class;
    }
    /**
     * Do not publish Log Events to avoid event recursion.
     * The plugin framework automatically removes all events from this plugin to avoid the recursion.
     * 
     * @param logEvents a list of events excluding events published from this plugin.
     */
    global override void run(List<ok__Log_Event__e> logEvents) {
        final SlackService service = new SlackService();
        service.sendMessages(logEvents);
    }
}
