@IsTest
private class SlackForOneLoggerPluginTest {
    @IsTest
    static void testGetPluginType() {
        SlackTest.setMock();
        SlackForOneLoggerSettings.mocked = new List<Slack_for_One_Logger_Setting__mdt>{
                new Slack_for_One_Logger_Setting__mdt(
                        Is_Active__c = true,
                        Log_Filter__c = ok__Log_Filter__mdt.getInstance('Errors_All_Time').Id,
                        Log_Field_Set__c = 'Slack_Log_Field_Set'
                )
        };
        ok.LoggerPlugin plugin = new SlackForOneLoggerPlugin();
        Assert.isEqual(SlackForOneLoggerPlugin.class, plugin.getPluginType());
        Test.startTest();
        plugin.run(new List<ok__Log_Event__e>{
                new ok__Log_Event__e(
                        ok__Log_Level__c = 'ERROR'
                )
        });
        Assert.isEqual(1, Limits.getQueueableJobs());
        Test.stopTest();
    }
}