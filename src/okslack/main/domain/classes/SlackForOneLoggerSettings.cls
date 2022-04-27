/**
 * Domain class for Slack_for_One_Logger_Setting__mdt configurations.
 */
public class SlackForOneLoggerSettings extends SObjects {
    @TestVisible
    private static List<Slack_for_One_Logger_Setting__mdt> mocked = new List<Slack_for_One_Logger_Setting__mdt>();
    /**
     * Construct the collection from a list.
     * 
     * @param records the settings list
     */
    public SlackForOneLoggerSettings(List<Slack_for_One_Logger_Setting__mdt> records) {
        super(records, Slack_for_One_Logger_Setting__mdt.SObjectType);
    }
    /**
     * Construct the collection empty.
     */
    public SlackForOneLoggerSettings() {
        super(Slack_for_One_Logger_Setting__mdt.SObjectType);
    }
    /**
     * Factory method to construct the collection with all the settings in the org.
     * 
     * @return the collection.
     */
    public static SlackForOneLoggerSettings load() {
        // custom metadata settings should be mocked in unit tests, return empty by default in unit tests
        List<Slack_for_One_Logger_Setting__mdt> settings = Test.isRunningTest() 
                ? mocked : Slack_for_One_Logger_Setting__mdt.getAll().values();
        return new SlackForOneLoggerSettings(settings);
    }
    /**
     * Return the collection as a List.
     * 
     * @return the list.
     */
    public List<Slack_for_One_Logger_Setting__mdt> getSettingList() {
        return (List<Slack_for_One_Logger_Setting__mdt>) getList();
    }
    /**
     * Map each setting Id to a list of mention user Ids.
     * 
     * @return the mention user Ids by setting Id map.
     */
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
    /**
     * Map each setting Id to a FieldSet.
     * 
     * @return the FieldSet by setting Id map.
     */
    public Map<Id, FieldSet> getLogFieldSetByIds() {
        Map<String, FieldSet> fieldSetsByName = ok__Log__c.SObjectType.getDescribe().fieldSets.getMap();
        Map<Id, FieldSet> result = new Map<Id, FieldSet>();
        for (Slack_for_One_Logger_Setting__mdt setting : getSettingList()) {
            FieldSet value = null;
            if (String.isNotBlank(setting.Log_Field_Set__c)) {
                if (fieldSetsByName.containsKey(setting.Log_Field_Set__c)) {
                    value = fieldSetsByName.get(setting.Log_Field_Set__c);
                } else if (fieldSetsByName.containsKey('okslack__' + setting.Log_Field_Set__c)) {
                    value = fieldSetsByName.get('okslack__' + setting.Log_Field_Set__c);
                }
            }
            result.put(setting.Id, value);
        }
        return result;
    }
    /**
     * Create a new collection with only active settings.
     * 
     * @return the new collection.
     */
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