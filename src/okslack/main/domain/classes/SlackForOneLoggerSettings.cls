public class SlackForOneLoggerSettings extends SObjects {
    private static final String DEFAULT_LOG_FIELD_SET_NAME = 'okslack__Slack_Log_Field_Set';
    
    public SlackForOneLoggerSettings(List<Slack_for_One_Logger_Setting__mdt> records) {
        super(records, Slack_for_One_Logger_Setting__mdt.SObjectType);
    }

    public SlackForOneLoggerSettings() {
        super(Slack_for_One_Logger_Setting__mdt.SObjectType);
    }
    
    public static SlackForOneLoggerSettings load() {
        return new SlackForOneLoggerSettings(Slack_for_One_Logger_Setting__mdt.getAll().values());
    }

    public List<Slack_for_One_Logger_Setting__mdt> getSettingList() {
        return (List<Slack_for_One_Logger_Setting__mdt>) getList();
    }
    
    public Map<Id, List<String>> getMentionUserIdsByIds() {
        Map<Id, List<String>> result = new Map<Id, List<String>>();
        for (Slack_for_One_Logger_Setting__mdt setting : getSettingList()) {
            List<String> mentionUserIds = String.isBlank(setting.Mention_User_Ids__c)
                    ? new List<String>()
                    : setting.Mention_User_Ids__c.split(';');
            result.put(setting.Id, mentionUserIds);
        }
        return result;
    }
    
    public Map<Id, FieldSet> getLogFieldSetByIds() {
        Map<Id, FieldSet> result = new Map<Id, FieldSet>();
        for (Slack_for_One_Logger_Setting__mdt setting : getSettingList()) {
            String logFieldSetName = String.isNotBlank(setting.Log_Field_Set__c) ? setting.Log_Field_Set__c : DEFAULT_LOG_FIELD_SET_NAME;
            FieldSet value =  ok__Log__c.SObjectType.getDescribe().fieldSets.getMap().get(logFieldSetName);
            result.put(setting.Id, value);
        }
        return result;
    }

    public SlackForOneLoggerSettings getActiveSettings(){
        SlackForOneLoggerSettings activeSettings = new SlackForOneLoggerSettings();
        for (Slack_for_One_Logger_Setting__mdt setting : getSettingList()) {
            if (setting.Is_Active__c) {
                activeSettings.add(setting);
            }
        }
        return activeSettings;
    }
}