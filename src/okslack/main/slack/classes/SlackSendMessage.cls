public inherited sharing class SlackSendMessage implements Queueable, Database.AllowsCallouts {
    private static final ok.Logger logger = ok.Logger.getLogger(SlackSendMessage.class);
    private List<SlackSendMessage.Request> requests = new List<SlackSendMessage.Request>();
    
    public void sendAsync(List<SlackSendMessage.Request> requests) {
        if (!requests.isEmpty()) {
            SlackSendMessage job = new SlackSendMessage();
            job.requests = requests;
            System.enqueueJob(job);
        }
    }

    public void send(List<SlackSendMessage.Request> requests) {
        for (SlackSendMessage.Request request : requests) {
            send(request);
        }
    }

    public void send(SlackSendMessage.Request request) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(request.endpoint);
        req.setMethod('POST');
        req.setHeader('Content-type', 'application/json');
        req.setBody(JSON.serialize(request.message));
        HttpResponse resp = new Http().send(req);
        Boolean isSuccessful = resp.getStatusCode() == 200;
        if (isSuccessful) {
            logger.info().addHttpRequest(req).addHttpResponse(resp).log('Slack message success.');
        } else {
            logger.error().addHttpRequest(req).addHttpResponse(resp).log('Slack message failed.');
        }
    }

    public void execute(QueueableContext param1) {
        try {
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
        } catch (Exception e) {
            logger.error().addException(e).log('Unexpected error.');
        } finally {
            ok.Logger.publish();
        }
    }
    
    public class Request {
        public String endpoint;
        public SlackMessage message;
        
        public Request(String endpoint, SlackMessage message) {
            this.endpoint = endpoint;
            this.message = message;
        }
    }
}