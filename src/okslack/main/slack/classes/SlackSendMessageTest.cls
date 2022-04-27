@IsTest
private class SlackSendMessageTest {
    @IsTest
    static void testSend() {
        Test.setMock(HttpCalloutMock.class, new SlackSendMessageMock());
        SlackSendMessage api = new SlackSendMessage();
        SlackMessage msg = new SlackMessage();
        SlackSendMessage.Request request = new SlackSendMessage.Request('end', msg);
        api.send(new List<SlackSendMessage.Request>{
                request
        });
        Assert.isEqual(1, Limits.getCallouts(), '1 callout expected in synchronous context');
        Assert.isEqual(0, Limits.getAsyncCalls(), 'No async call expected in synchronous context');
        Assert.isEqual(1, SlackHttp.requestLogs.size(), 'Expected 1 http request.');
        SlackHttp.HttpRequestLog req = SlackHttp.requestLogs.get(0);
        Assert.isEqual(msg.toJSON(), req.body, 'Expected body to be Slack message JSON.');
    }

    @IsTest
    static void testSendAsync() {
        Test.setMock(HttpCalloutMock.class, new SlackSendMessageMock());
        SlackSendMessage api = new SlackSendMessage();
        SlackMessage msg = new SlackMessage();
        SlackSendMessage.Request request = new SlackSendMessage.Request('end', msg);
        Test.startTest();
        api.sendAsync(new List<SlackSendMessage.Request>{
                request
        });
        Assert.isEqual(0, Limits.getCallouts(), 'No callout expected in synchronous context');
        Assert.isEqual(1, Limits.getAsyncCalls(), '1 async call expected in synchronous context');
        Test.stopTest();
        Assert.isEqual(1, SlackHttp.requestLogs.size(), 'Expected 1 http request.');
        SlackHttp.HttpRequestLog req = SlackHttp.requestLogs.get(0);
        Assert.isEqual(msg.toJSON(), req.body, 'Expected body to be Slack message JSON.');
    }

    @IsTest
    static void testSendMix() {
        Test.setMock(HttpCalloutMock.class, new SlackSendMessageMock());
        SlackSendMessage api = new SlackSendMessage();
        SlackMessage msg = new SlackMessage();
        List<SlackSendMessage.Request> requests = new List<SlackSendMessage.Request>();
        Integer overTheLimitCount = 10;
        // create over the limit requests
        for (Integer i = 0; i < Limits.getLimitCallouts() + overTheLimitCount; i++) {
            requests.add(new SlackSendMessage.Request('end', msg));
        }
        Test.startTest();
        api.sendMix(requests);
        Assert.isEqual(Limits.getLimitCallouts(), Limits.getCallouts(), 'Limit callout should be reached in synchronous context');
        Assert.isEqual(1, Limits.getAsyncCalls(), '1 async call expected in synchronous context');
        Test.stopTest();
        Assert.isEqual(Limits.getLimitCallouts() + overTheLimitCount, SlackHttp.requestLogs.size(), 'Expected all http requests to be send.');
        SlackHttp.HttpRequestLog req = SlackHttp.requestLogs.get(0);
        Assert.isEqual(msg.toJSON(), req.body, 'Expected body to be Slack message JSON.');
    }

    public class SlackSendMessageMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse resp = new HttpResponse();
            resp.setStatusCode(200);
            return resp;
        }
    }
}