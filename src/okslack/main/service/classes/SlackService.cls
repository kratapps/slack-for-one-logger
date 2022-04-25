public inherited sharing class SlackService {
    private static final ok.Logger logger = ok.Logger.getLogger(SlackService.class);
    
    public void sendMessages(List<ok__Log_Event__e> events) {
        SlackSendMessage sendMessage = new SlackSendMessage();
        ok.LogEvents logEvents = new ok.LogEvents(events);
        SlackForOneLoggerSettings settings = SlackForOneLoggerSettings.load().getActiveSettings();
        Map<Id, List<String>> mentionUserIdsBySettingIds = settings.getMentionUserIdsByIds();
        Map<Id, FieldSet> fieldSetByIds = settings.getLogFieldSetByIds();
        for (Slack_for_One_Logger_Setting__mdt setting : settings.getSettingList()) {
            FieldSet logFieldSet = fieldSetByIds.get(setting.Id);
            if (logFieldSet == null) {
                logger.error().linkSObject(setting).log('Log Field Set not found.');
                continue;
            }
            List<ok__Log_Event__e> eventsFiltered = filterLogEvents(setting.Log_Filter__c, logEvents);
            if (!eventsFiltered.isEmpty()) {
                String endpoint = 'callout:' + setting.Named_Credential__c;
                List<String> mentionUserIds = mentionUserIdsBySettingIds.get(setting.Id);
                SlackMessage message = buildSlackMessage(eventsFiltered, logFieldSet, setting.Mention_Here__c, mentionUserIds);
                sendMessage.enqueueSend(endpoint, message);
            }
        }
    }

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
            String eventText = String.join(eventTextParts, '\n');
            message.createBlockSection().setMrkdwn(eventText);
        }
        SlackMentions mentions = new SlackMentions().mentionHere(mentionHere).addMembers(mentionUserIds);
        message.createBlockSection().setMrkdwn(mentions.toString());
        return message;
    }

    private List<ok__Log_Event__e> filterLogEvents(Id logFilterId, ok.LogEvents logEvents) {
        if (String.isBlank(logFilterId)) {
            return new List<ok__Log_Event__e>();
        }
        return logEvents.filter(logFilterId).getLogEventList();
    }
}