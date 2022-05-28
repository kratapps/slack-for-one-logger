/**
 * Slack API to send messages.
 */
public inherited sharing class SlackSendMessage implements Queueable, Database.AllowsCallouts {
    private static final ok.Logger logger = ok.Logger.getLogger(SlackSendMessage.class);
    @TestVisible
    private SlackHttp http = SlackHttp.create();
    /**
     * List of send message requests when using queueable.
     */
    private List<SlackSendMessage.Request> requests = new List<SlackSendMessage.Request>();
    /**
     * Send messages synchronously.
     * 
     * @param requests the list of send message requests
     */
    public void send(List<SlackSendMessage.Request> requests) {
        for (SlackSendMessage.Request request : requests) {
            send(request);
        }
    }
    /**
     * Send message synchronously.
     * 
     * @param request the send message request
     */
    public void send(SlackSendMessage.Request request) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(request.endpoint);
        req.setMethod('POST');
        req.setHeader('Content-type', 'application/json');
        req.setBody(request.message.toJSON());
        HttpResponse resp = http.send(req);
        if (resp.getStatusCode() != 200) {
            logger.error().addHttpRequest(req).addHttpResponse(resp).log('Slack message failed.');
        }
    }
    /**
     * Send messages using queueable.
     * 
     * @param requests the list of send message requests
     */
    public void sendAsync(List<SlackSendMessage.Request> requests) {
        if (!requests.isEmpty()) {
            SlackSendMessage job = new SlackSendMessage();
            job.requests = requests;
            System.enqueueJob(job);
        }
    }
    /**
     * Send as many as possible messages synchronously.
     * The remaining requests enqueue again.
     * 
     * @param requests the list of send message requests
     */
    public void sendMix(List<SlackSendMessage.Request> requests) {
        List<SlackSendMessage.Request> syncRequests = new List<SlackSendMessage.Request>();
        List<SlackSendMessage.Request> asyncRequests = new List<SlackSendMessage.Request>();
        for (SlackSendMessage.Request req : requests) {
            // check limits how many callouts can be done in this transaction, otherwise enqueue another job for the rest
            if (Limits.getCallouts() + syncRequests.size() < Limits.getLimitCallouts()) {
                syncRequests.add(req);
            } else {
                asyncRequests.add(req);
            }
        }
        send(syncRequests);
        sendAsync(asyncRequests);
    }
    /**
     * Execute queueable and send mix sync and async.
     * 
     * @param ctx the queueable context
     */
    public void execute(QueueableContext ctx) {
        try {
            ok.Logger.setPluginExecution(new SlackForOneLoggerPlugin());
            sendMix(requests);
        } catch (Exception e) {
            logger.error().addException(e).log('Unexpected error.');
        } finally {
            ok.Logger.publish();
        }
    }
    /**
     * Send Slack message request.
     */
    public class Request {
        public String endpoint;
        public SlackMessage message;
        /**
         * @param endpoint the Slack webhook URL
         * @param message the Slack message
         */
        public Request(String endpoint, SlackMessage message) {
            this.endpoint = endpoint;
            this.message = message;
        }
    }
}