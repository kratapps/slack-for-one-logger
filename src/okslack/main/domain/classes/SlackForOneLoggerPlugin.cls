/**
 * Configurable One Logger Plugin to send Slack messages.
 */
global with sharing class SlackForOneLoggerPlugin extends ok.LogEventPlugin {
    /**
     * Plugin name should be a name describing this plugin, not null and no more than 32 characters.
     * The plugin name is added to events published from this plugin,
     * 
     * @return the name of this plugin.
     */
    global override String getPluginName() {
        return SlackForOneLoggerPlugin.class.getName();
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
