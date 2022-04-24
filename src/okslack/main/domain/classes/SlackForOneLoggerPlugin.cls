global with sharing class SlackForOneLoggerPlugin extends ok.LogEventPlugin {
    private final SlackService service = new SlackService();

    /**
     * Plugin name should be name describing this plugin, not null and no more than 32 characters.
     * The plugin name is added to events published from this plugin,
     * The `run` method will be called with events excluding events published in this plugin.
     * 
     * @return the name of this plugin.
     */
    global override String getPluginName() {
        return SlackForOneLoggerPlugin.class.getName();
    }

    /**
     * Process events.
     * 
     * @param logEvents a list of events excluding events published from this plugin to avoid recursion.
     */
    global override void run(List<ok__Log_Event__e> logEvents) {
        service.sendMessages(logEvents);
    }
}
