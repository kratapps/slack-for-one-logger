/**
 * Service class to send messages from log events.
 */
public inherited sharing class SlackService {
    private static final ok.Logger logger = ok.Logger.getLogger(SlackService.class);
    /**
     * Send Slack messages based on the settings.
     * Each setting represents a one message and a filter criteria for the log events.
     * 
     * @param events the log events
     */
    public void sendMessages(List<ok__Log_Event__e> events) {
        List<SlackSendMessage.Request> requests = new List<SlackSendMessage.Request>();
        ok.LogEvents logEvents = new ok.LogEvents(events);
        SlackForOneLoggerSettings settings = SlackForOneLoggerSettings.load().getActiveSettings();
        Map<Id, List<String>> mentionUserIdsBySettingIds = settings.getMentionUserIdsByIds();
        Map<Id, FieldSet> fieldSetByIds = settings.getLogFieldSetByIds();
        // for each setting send a message if configure correctly
        for (Slack_for_One_Logger_Setting__mdt setting : settings.getSettingList()) {
            FieldSet logFieldSet = fieldSetByIds.get(setting.Id);
            if (logFieldSet == null) {
                logger.error().linkSObject(setting).log('Log Field Set not found.');
                continue;
            }
            List<ok__Log_Event__e> eventsFiltered = logEvents.filter(setting.Log_Filter__c).getLogEventList();
            if (!eventsFiltered.isEmpty()) {
                String endpoint = 'callout:' + setting.Named_Credential__c;
                List<String> mentionUserIds = mentionUserIdsBySettingIds.get(setting.Id);
                SlackMessage message = buildSlackMessage(eventsFiltered, logFieldSet, setting.Mention_Here__c, mentionUserIds);
                requests.add(new SlackSendMessage.Request(endpoint, message));
            }
        }
        new SlackSendMessage().sendAsync(requests);
    }
    /**
     * Construct Slack message based on a setting.
     * 
     * @param logEvents the list of events
     * @param logFieldSet the fields to include
     * @param mentionHere the boolean whether to include here mention
     * @param mentionUserIds the list of Slack user Ids to mention
     *
     * @return the slack message
     */
    private SlackMessage buildSlackMessage(List<ok__Log_Event__e> logEvents, FieldSet logFieldSet, Boolean mentionHere, List<String> mentionUserIds) {
        SlackMessage message = new SlackMessage();
        String headerText = 'Logs from ' + logEvents.get(0).ok__Organization_Name__c;
        message.setText(headerText).createBlockHeader().setPlainText(headerText);
        for (ok__Log_Event__e event : logEvents) {
            List<String> eventTextParts = new List<String>();
            for (FieldSetMember member : logFieldSet.getFields()) {
                String fieldName = String.valueOf(member.getSObjectField());
                String fieldLabel = member.getLabel();
                String fieldValue = String.valueOf(event.get(fieldName));
                eventTextParts.add('*' + fieldLabel + '*: ' + fieldValue);
            }
            if (!eventTextParts.isEmpty()) {
                String eventText = String.join(eventTextParts, '\n');
                message.createBlockSection().setMrkdwn(eventText);
            }
        }
        if (mentionHere != null && mentionHere) {
            SlackMentions mentions = new SlackMentions().mentionHere(mentionHere).addMembers(mentionUserIds);
            message.createBlockSection().setMrkdwn(mentions.toString());
        }
        return message;
    }
}