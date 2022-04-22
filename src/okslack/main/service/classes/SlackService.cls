public inherited sharing class SlackService {
    private static final ok.Logger logger = ok.Logger.getLogger(SlackService.class);
    private final String DEFAULT_LOG_FIELD_SET_NAME = 'okslack__Slack_Log_Field_Set';
    
    public void sendMessages(List<ok__Log_Event__e> events) {
        SlackSendMessage sendMessage = new SlackSendMessage();
        ok.LogEvents logEvents = new ok.LogEvents(events);
        for (Slack_for_One_Logger_Setting__mdt setting : getActiveSettings()) {
            FieldSet logFieldSet = getFieldSet(setting);
            if (logFieldSet == null) {
                logger.error().linkSObject(setting).log('Log Field Set not found.');
                continue;
            }
            List<ok__Log_Event__e> eventsFiltered = filterLogEvents(setting.Log_Filter__c, logEvents);
            if (!eventsFiltered.isEmpty()) {
                String endpoint = 'callout:' + setting.Named_Credential__c;
                Set<String> mentionUserIds = getMentionUserIds(setting);
                SlackMessage message = buildSlackMessage(eventsFiltered, logFieldSet, setting.Mention_Here__c, mentionUserIds);
                sendMessage.enqueueSend(endpoint, message);
            }
        }
    }

    private SlackMessage buildSlackMessage(List<ok__Log_Event__e> logEvents, FieldSet logFieldSet, Boolean mentionHere, Set<String> mentionUserIds) {
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
    
    private Set<String> getMentionUserIds(Slack_for_One_Logger_Setting__mdt setting) {
        Set<String> result = new Set<String>();
        if (String.isBlank(setting.Mention_User_Ids__c)) {
            return result;
        }
        for (String mentionUserId : setting.Mention_User_Ids__c.split(';')) {
            result.add(mentionUserId);
        }
        return result;
    }
    
    private FieldSet getFieldSet(Slack_for_One_Logger_Setting__mdt setting) {
        String logFieldSetName = String.isNotBlank(setting.Log_Field_Set__c) ? setting.Log_Field_Set__c : DEFAULT_LOG_FIELD_SET_NAME;
        return ok__Log__c.SObjectType.getDescribe().fieldSets.getMap().get(logFieldSetName);
    }

    private List<Slack_for_One_Logger_Setting__mdt> getActiveSettings() {
        List<Slack_for_One_Logger_Setting__mdt> settings = new List<Slack_for_One_Logger_Setting__mdt>();
        for (Slack_for_One_Logger_Setting__mdt setting : Slack_for_One_Logger_Setting__mdt.getAll().values()) {
            if (setting.Is_Active__c) {
                settings.add(setting);
            }
        }
        return settings;
    }
}