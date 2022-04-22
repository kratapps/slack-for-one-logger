public inherited sharing class SlackSendMessage implements Queueable, Database.AllowsCallouts {
    private static final ok.Logger logger = ok.Logger.getLogger(SlackSendMessage.class);

    private String endpoint;
    private SlackMessage message;

    public void enqueueSend(String endpoint, SlackMessage message) {
        this.endpoint = endpoint;
        this.message = message;
        System.enqueueJob(this);
    }

    public void send(String endpoint, SlackMessage message) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-type', 'application/json');
        req.setBody(JSON.serialize(message));
        logger.info().addHttpRequest(req).log('Sending slack message.');
        HttpResponse resp = new Http().send(req);
        if (resp.getStatusCode() != 200) {
            logger.error().addHttpRequest(req).addHttpResponse(resp).log('Slack message failed.');
        }
    }

    public void execute(QueueableContext param1) {
        try {
            new SlackSendMessage().send(endpoint, message);
        } catch (Exception e) {
            logger.error().addException(e).log('Unexpected error.');
        } finally {
            ok.Logger.publish();
        }
    }
}